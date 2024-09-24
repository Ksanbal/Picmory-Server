/*
  Warnings:

  - You are about to drop the `AlbumsOnMemory` table. If the table is not empty, all the data it contains will be lost.

*/
-- DropTable
DROP TABLE "AlbumsOnMemory";

-- CreateTable
CREATE TABLE "albums_on_memory" (
    "album_id" INTEGER NOT NULL,
    "memory_id" INTEGER NOT NULL,

    CONSTRAINT "albums_on_memory_pkey" PRIMARY KEY ("album_id","memory_id")
);

-- CreateIndex
CREATE INDEX "albums_on_memory_album_id_idx" ON "albums_on_memory"("album_id");

-- CreateIndex
CREATE INDEX "albums_on_memory_memory_id_idx" ON "albums_on_memory"("memory_id");
