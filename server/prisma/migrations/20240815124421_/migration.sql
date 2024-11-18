/*
  Warnings:

  - You are about to drop the column `uri` on the `memory_file` table. All the data in the column will be lost.
  - Added the required column `path` to the `memory_file` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE "memory_file" DROP COLUMN "uri",
ADD COLUMN     "path" TEXT NOT NULL;
