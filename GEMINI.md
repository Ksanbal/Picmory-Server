# Picmory 프로젝트 분석

### 프로젝트 개요

**Picmory**는 다양한 포토부스 업체에서 제공하는 QR 코드를 크롤링하여 원본 사진과 영상을 사용자의 앨범에 저장하고 관리하는 서비스의 백엔드 서버입니다. 과거에는 Flutter로 개발된 모바일 앱도 존재했으나, 현재는 서버 프로젝트만 남아있습니다.

### 기술 스택 (Tech Stack)

-   **언어**: TypeScript
-   **프레임워크**: **NestJS**를 사용하여 서버를 구축했습니다.
-   **데이터베이스**: **Prisma**를 ORM으로 사용하며, 초기에는 PostgreSQL을 사용했으나 현재는 **SQLite**로 마이그레이션되었습니다.
-   **API**: RESTful API를 제공하며, **Swagger** (`@nestjs/swagger`)와 **Scalar** (`@scalar/nestjs-api-reference`)를 통해 API 문서를 자동화하고 있습니다.
-   **인증**: **JWT (JSON Web Token)** 기반의 인증 시스템을 사용합니다 (`@nestjs/jwt`, `passport`).
-   **웹 크롤링**: **Puppeteer**와 **JSDOM**을 사용하여 다양한 포토부스 웹사이트의 QR 코드 링크를 크롤링합니다.
-   **파일 처리**:
    -   **Multer**: 파일 업로드를 처리합니다.
    -   **Sharp**: 이미지 썸네일 생성 등 이미지 프로세싱에 사용됩니다.
-   **외부 스토리지**: **Cloudflare R2**와 같은 S3 호환 객체 스토리지를 사용합니다 (`@aws-sdk/client-s3`).
-   **비동기 처리**: **`@nestjs/event-emitter`**를 사용하여 썸네일 생성, 알림 발송 등 시간이 소요되는 작업을 비동기적으로 처리합니다.
-   **알림**: **Discord Webhook**을 통해 서비스의 주요 이벤트(예: 크롤링 실패)를 개발자에게 알립니다.
-   **배포**: **Docker**와 **PM2**를 사용하여 배포 및 프로세스를 관리합니다.
-   **패키지 매니저**: **Yarn**을 사용합니다.

### 아키텍처 및 구조

이 프로젝트는 **계층형 아키텍처 (Layered Architecture)**, 특히 **헥사고날 아키텍처 (Hexagonal Architecture)**의 원칙을 따르고 있습니다. `src` 디렉토리를 보면 각 계층의 역할이 명확하게 분리되어 있습니다.

1.  **`1-presentation` (표현 계층)**
    -   **`controller`**: HTTP 요청의 엔드포인트입니다. 요청을 받아 유효성을 검사하고 애플리케이션 계층으로 전달합니다.
    -   **`dto` (Data Transfer Object)**: API 요청(Request)과 응답(Response)의 데이터 구조를 정의합니다. `class-validator`와 `class-transformer`를 통해 데이터 유효성 검사와 변환을 수행합니다.
    -   **`guard`**: 인증/인가와 같은 요청 가드 로직을 처리합니다 (예: `JwtAuthGuard`).
    -   **`docs`**: Swagger를 위한 API 문서 데코레이터를 모아 관리합니다.

2.  **`2-application` (애플리케이션 계층)**
    -   **`facade`**: 도메인 계층의 여러 서비스를 조합하여 표현 계층에 단순화된 인터페이스를 제공합니다. 복잡한 비즈니스 로직의 흐름을 여기서 제어합니다.

3.  **`3-domain` (도메인 계층)**
    -   **`service`**: 핵심 비즈니스 로직을 구현합니다. 이 프로젝트의 가장 중요한 규칙과 절차가 여기에 포함됩니다.
    -   **`model`**: 도메인의 핵심 데이터 구조(엔티티, 모델)를 정의합니다.

4.  **`4-infrastructure` (인프라스트럭처 계층)**
    -   **`repository`**: Prisma를 사용하여 데이터베이스와의 통신을 담당합니다. 데이터 영속성 로직을 추상화합니다.
    -   **`client`**: Cloudflare R2, Discord Webhook 등 외부 서비스와의 통신을 담당합니다.

### 코드 패턴 및 개발 문화

-   **모듈화 (Modularity)**: 기능 단위(Auth, Members, Memories, Albums 등)로 코드를 모듈화하여 관리의 용이성과 재사용성을 높였습니다.
-   **DTO 패턴**: API의 요청과 응답 명세를 DTO 클래스로 명확하게 정의하여 코드 안정성과 예측 가능성을 높입니다.
-   **Facade 패턴**: 복잡한 도메인 로직을 감싸서 표현 계층에서는 간단하게 호출할 수 있도록 하는 Facade 패턴을 적극적으로 사용합니다.
-   **Repository 패턴**: 비즈니스 로직(Service)과 데이터 접근 로직(Repository)을 분리하여 테스트 용이성을 높이고 의존성을 낮춥니다.
-   **의존성 주입 (Dependency Injection)**: NestJS의 핵심 기능인 DI를 적극 활용하여 모듈 간의 결합도를 낮춥니다.
-   **이벤트 기반 아키텍처**: `@nestjs/event-emitter`를 사용해 특정 이벤트(예: `MEMORY_CREATED`)가 발생했을 때 관련 작업(예: 썸네일 생성)을 비동기적으로 처리하여 시스템의 응답성을 유지합니다.
-   **Conventional Commits**: Git 커밋 메시지를 `✨ Feat:`, `🐛 Fix:`, `🚀 Chore:` 와 같이 유형별로 표준화하여 히스토리 가독성을 높이고 변경 사항을 쉽게 추적할 수 있도록 합니다.
-   **파일 네이밍 컨벤션**: 파일 이름은 케밥 케이스(kebab-case, 예: `albums.controller.ts`)를 일관되게 사용합니다.
