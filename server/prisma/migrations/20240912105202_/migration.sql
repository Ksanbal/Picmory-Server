/*
  Warnings:

  - Added the required column `member_id` to the `memory_file` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE "memory_file" ADD COLUMN     "member_id" INTEGER NOT NULL;

-- CreateIndex
CREATE INDEX "memory_file_member_id_idx" ON "memory_file"("member_id");
