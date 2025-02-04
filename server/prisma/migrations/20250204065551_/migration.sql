/*
  Warnings:

  - You are about to drop the column `size` on the `memory_file` table. All the data in the column will be lost.

*/
-- RedefineTables
PRAGMA defer_foreign_keys=ON;
PRAGMA foreign_keys=OFF;
CREATE TABLE "new_memory_file" (
    "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
    "created_at" DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" DATETIME NOT NULL,
    "deleted_at" DATETIME,
    "member_id" INTEGER NOT NULL,
    "memory_id" INTEGER,
    "type" TEXT NOT NULL,
    "originalName" TEXT NOT NULL,
    "path" TEXT NOT NULL,
    "thumbnail_uri" TEXT
);
INSERT INTO "new_memory_file" ("created_at", "deleted_at", "id", "member_id", "memory_id", "originalName", "path", "thumbnail_uri", "type", "updated_at") SELECT "created_at", "deleted_at", "id", "member_id", "memory_id", "originalName", "path", "thumbnail_uri", "type", "updated_at" FROM "memory_file";
DROP TABLE "memory_file";
ALTER TABLE "new_memory_file" RENAME TO "memory_file";
CREATE INDEX "memory_file_memory_id_idx" ON "memory_file"("memory_id");
CREATE INDEX "memory_file_member_id_idx" ON "memory_file"("member_id");
PRAGMA foreign_keys=ON;
PRAGMA defer_foreign_keys=OFF;
