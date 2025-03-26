import { chromium } from "playwright";
import { configDotenv } from 'dotenv'; configDotenv()

const browser = await chromium.launchServer({
    headless: true,
    port: 3501,
    wsPath: process.env.HOST
})

console.log(browser.wsEndpoint())
