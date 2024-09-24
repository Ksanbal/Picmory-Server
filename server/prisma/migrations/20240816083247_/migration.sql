/*
  Warnings:

  - The primary key for the `albums_on_memory` table will be changed. If it partially fails, the table could be left without primary key constraint.
  - You are about to drop the column `deleted_at` on the `refresh_token` table. All the data in the column will be lost.
  - You are about to drop the column `updated_at` on the `refresh_token` table. All the data in the column will be lost.

*/
-- AlterTable
ALTER TABLE "albums_on_memory" DROP CONSTRAINT "albums_on_memory_pkey",
ADD COLUMN     "id" SERIAL NOT NULL,
ADD CONSTRAINT "albums_on_memory_pkey" PRIMARY KEY ("id");

-- AlterTable
ALTER TABLE "refresh_token" DROP COLUMN "deleted_at",
DROP COLUMN "updated_at";
