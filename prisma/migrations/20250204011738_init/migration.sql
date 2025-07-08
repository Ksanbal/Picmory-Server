-- CreateTable
CREATE TABLE "member" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "created_at" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" DATETIME NOT NULL,
    "deleted_at" DATETIME,
    "provider_id" TEXT NOT NULL,
    "provider" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "metadata" TEXT NOT NULL,
    "fcm_token" TEXT,
    "is_admin" BOOLEAN NOT NULL DEFAULT false
);

-- CreateTable
CREATE TABLE "refresh_token" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "created_at" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "token" TEXT NOT NULL,
    "member_id" INTEGER NOT NULL,
    "expired_at" DATETIME NOT NULL
);

-- CreateTable
CREATE TABLE "memory" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "created_at" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" DATETIME NOT NULL,
    "deleted_at" DATETIME,
    "member_id" INTEGER NOT NULL,
    "date" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "brand_name" TEXT NOT NULL,
    "like" BOOLEAN NOT NULL DEFAULT false
);

-- CreateTable
CREATE TABLE "memory_file" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "created_at" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" DATETIME NOT NULL,
    "deleted_at" DATETIME,
    "member_id" INTEGER NOT NULL,
    "memory_id" INTEGER,
    "type" TEXT NOT NULL,
    "originalName" TEXT NOT NULL,
    "size" INTEGER NOT NULL,
    "path" TEXT NOT NULL,
    "thumbnail_uri" TEXT
);

-- CreateTable
CREATE TABLE "album" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "created_at" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" DATETIME NOT NULL,
    "deleted_at" DATETIME,
    "member_id" INTEGER NOT NULL,
    "name" TEXT NOT NULL,
    "last_add_at" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- CreateTable
CREATE TABLE "album_memory" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "album_id" INTEGER NOT NULL,
    "memory_id" INTEGER NOT NULL
);

-- CreateTable
CREATE TABLE "brand" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "created_at" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" DATETIME NOT NULL,
    "deleted_at" DATETIME,
    "name" TEXT NOT NULL
);

-- CreateIndex
CREATE UNIQUE INDEX "refresh_token_token_key" ON "refresh_token"("token");

-- CreateIndex
CREATE INDEX "memory_member_id_idx" ON "memory"("member_id");

-- CreateIndex
CREATE INDEX "memory_file_memory_id_idx" ON "memory_file"("memory_id");

-- CreateIndex
CREATE INDEX "memory_file_member_id_idx" ON "memory_file"("member_id");

-- CreateIndex
CREATE INDEX "album_member_id_idx" ON "album"("member_id");

-- CreateIndex
CREATE INDEX "album_memory_album_id_idx" ON "album_memory"("album_id");

-- CreateIndex
CREATE INDEX "album_memory_memory_id_idx" ON "album_memory"("memory_id");
