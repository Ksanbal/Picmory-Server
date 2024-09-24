/*
  Warnings:

  - A unique constraint covering the columns `[provider_id]` on the table `member` will be added. If there are existing duplicate values, this will fail.
  - Added the required column `provider_id` to the `member` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE "member" ADD COLUMN     "provider_id" TEXT NOT NULL;

-- CreateIndex
CREATE UNIQUE INDEX "member_provider_id_key" ON "member"("provider_id");
