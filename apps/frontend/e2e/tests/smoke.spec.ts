import { test, expect } from "@playwright/test";

test("homepage loads and shows heading", async ({ page }) => {
  await page.goto("/");
  await expect(page).toHaveTitle(/.*/);

  // Assert something stable:
  await expect(page.getByRole("heading", { name: "Frontend" })).toBeVisible();
});