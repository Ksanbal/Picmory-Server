# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Picmory is a backend server for a photo booth service that crawls QR codes from various photo booth vendors to collect and store original photos and videos in user albums. The project previously included a Flutter mobile app but now contains only the server implementation.

## Development Commands

```bash
# Install dependencies
yarn install

# Development with live reload and Prisma Studio
yarn start:dev

# Build application
yarn build

# Production mode
yarn start:prod

# Linting and formatting
yarn lint
yarn format

# Testing
yarn test                    # Run tests
yarn test:watch             # Watch mode
yarn test:cov               # With coverage
yarn test:e2e               # End-to-end tests

# Database
npx prisma generate         # Generate Prisma client
npx prisma migrate dev      # Run migrations
npx prisma studio           # Open database browser

# Production deployment
yarn build
yarn pm2:start             # Start with PM2
yarn pm2:stop              # Stop PM2 processes
yarn pm2:reload            # Reload PM2 processes
```

## Architecture

This project follows **Hexagonal Architecture** with clear layer separation:

### 1-presentation (Interface Adapters)
- **controllers**: HTTP endpoints that handle requests and delegate to facades
- **dto**: Data Transfer Objects for request/response validation using `class-validator`
- **guards**: Authentication/authorization middleware (JWT-based)
- **docs**: Swagger API documentation decorators
- **events**: Event handlers for async operations

### 2-application (Use Cases)  
- **facade**: Orchestrates domain services and provides simplified interfaces to controllers
- Coordinates complex business flows between multiple domain services

### 3-domain (Business Logic)
- **services**: Core business logic implementation
- **models**: Domain entities and value objects
- Contains the essential business rules and processes

### 4-infrastructure (External Concerns)
- **repositories**: Database access layer using Prisma ORM
- **clients**: External service integrations (Cloudflare R2, Discord webhooks)

## Key Technical Patterns

### Event-Driven Architecture
The application uses `@nestjs/event-emitter` for async processing:
- `MEMORY_CREATED`: Triggers thumbnail generation
- `QR_CRAWLER_FAILED`: Sends Discord notifications
- Events are defined in `src/lib/constants/event-names.ts`

### Database Design
- **SQLite** with Prisma ORM (migrated from PostgreSQL)
- Soft delete pattern with `deletedAt` fields
- Proper indexing for member-based queries
- Junction tables for many-to-many relationships (AlbumMemory)

### File Management
- **Cloudflare R2** for object storage using S3-compatible SDK
- **Sharp** for image processing and thumbnail generation
- Local uploads directory for temporary files
- Automatic cleanup of temporary files

### QR Code Crawling
The core feature supports 25+ photo booth brands with brand-specific crawling logic:
- Each brand has custom parsing logic in `qr-crawler.service.ts`
- Uses Puppeteer for dynamic content and JSDOM for static parsing
- Validates QR URLs against supported brand hosts
- Returns structured data with photo/video URLs

## Code Conventions

- **File naming**: kebab-case (e.g., `albums.controller.ts`)
- **Commit messages**: Conventional commits with emojis (`✨ feat:`, `🐛 fix:`)
- **API responses**: Use DTOs with `class-transformer` for serialization
- **Error handling**: Structured error messages in `src/lib/constants/error-messages.ts`
- **Configuration**: Environment-based config with `@nestjs/config`

## API Documentation

- **Swagger**: Auto-generated API docs at `/api-docs` (Basic Auth protected)
- **Scalar**: Modern API reference UI using `@scalar/nestjs-api-reference`
- All endpoints documented with proper DTOs and response schemas

## Authentication & Security

- **JWT-based authentication** with refresh tokens
- **Bearer token** authentication for API access
- **Basic Auth** protection for API documentation
- **Social login** support (Apple, Google providers)

## External Integrations

- **Discord Webhooks**: Error notifications and monitoring
- **Cloudflare R2**: File storage with presigned URL generation
- **Multiple photo booth APIs**: Brand-specific crawling implementations

## Database Schema Key Relationships

```
Member (1) -> (N) Memory -> (N) MemoryFile
Member (1) -> (N) Album
Album (N) <-> (N) Memory (via AlbumMemory junction)
```

## Development Notes

- The server runs on port 3000 with PM2 clustering (2 instances)
- Static files served from `/uploads` and `/public` directories  
- Global validation pipe with transformation enabled
- Response serialization with `excludeAll` strategy for DTOs
- Error handling through Discord webhooks for production monitoring