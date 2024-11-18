-- CreateEnum
CREATE TYPE "user_provider" AS ENUM ('APPLE', 'GOOGLE');

-- CreateEnum
CREATE TYPE "MemoryFileType" AS ENUM ('IMAGE', 'VIDEO');

-- CreateTable
CREATE TABLE "member" (
    "id" SERIAL NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "deleted_at" TIMESTAMP(3),
    "email" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "metadata" JSONB NOT NULL,
    "provider" "user_provider" NOT NULL,
    "fcm_token" TEXT,
    "is_admin" BOOLEAN NOT NULL DEFAULT false,

    CONSTRAINT "member_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "refresh_token" (
    "id" SERIAL NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "deleted_at" TIMESTAMP(3),
    "token" TEXT NOT NULL,
    "member_id" INTEGER NOT NULL,
    "expired_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "refresh_token_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "memory" (
    "id" SERIAL NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "deleted_at" TIMESTAMP(3),
    "member_id" INTEGER NOT NULL,
    "date" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "brand_name" TEXT NOT NULL,
    "like" BOOLEAN NOT NULL DEFAULT false,

    CONSTRAINT "memory_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "memory_file" (
    "id" SERIAL NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "deleted_at" TIMESTAMP(3),
    "memory_id" INTEGER,
    "type" "MemoryFileType" NOT NULL,
    "originalName" TEXT NOT NULL,
    "size" INTEGER NOT NULL,
    "uri" TEXT NOT NULL,
    "thumbnail_uri" TEXT NOT NULL,

    CONSTRAINT "memory_file_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "album" (
    "id" SERIAL NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "deleted_at" TIMESTAMP(3),
    "member_id" INTEGER NOT NULL,
    "name" TEXT NOT NULL,

    CONSTRAINT "album_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "AlbumsOnMemory" (
    "album_id" INTEGER NOT NULL,
    "memory_id" INTEGER NOT NULL,

    CONSTRAINT "AlbumsOnMemory_pkey" PRIMARY KEY ("album_id","memory_id")
);

-- CreateTable
CREATE TABLE "brand" (
    "id" SERIAL NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "deleted_at" TIMESTAMP(3),
    "name" TEXT NOT NULL,

    CONSTRAINT "brand_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "member_email_key" ON "member"("email");

-- CreateIndex
CREATE UNIQUE INDEX "refresh_token_token_key" ON "refresh_token"("token");

-- CreateIndex
CREATE INDEX "memory_member_id_idx" ON "memory"("member_id");

-- CreateIndex
CREATE INDEX "memory_file_memory_id_idx" ON "memory_file"("memory_id");

-- CreateIndex
CREATE INDEX "album_member_id_idx" ON "album"("member_id");

-- CreateIndex
CREATE INDEX "AlbumsOnMemory_album_id_idx" ON "AlbumsOnMemory"("album_id");

-- CreateIndex
CREATE INDEX "AlbumsOnMemory_memory_id_idx" ON "AlbumsOnMemory"("memory_id");
