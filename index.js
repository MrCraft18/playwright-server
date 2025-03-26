import { chromium } from "playwright";
import { configDotenv } from 'dotenv'; configDotenv()

const browser = await chromium.launchServer({
    headless: true,
    port: process.env.PORT,
    wsPath: process.env.HOST
})

console.log(browser.wsEndpoint())
