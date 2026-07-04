// 스토어 스크린샷 생성 — 실제 폰(Pixel) 에뮬레이션 + 설치된 Chrome 사용
// 실행: node scripts/shots.mjs   (개발서버가 8778에서 떠 있어야 함)
import { chromium, devices } from 'playwright-core';

const BASE = 'http://localhost:8778';
const OUT = 'store-assets';

const pixel = devices['Pixel 7'] ?? {
  viewport: { width: 412, height: 915 },
  deviceScaleFactor: 3, isMobile: true, hasTouch: true,
};

const browser = await chromium.launch({ channel: 'chrome', headless: true });
const ctx = await browser.newContext({
  ...pixel,
  locale: 'ko-KR',
  // 위치권한 미부여 → 앱이 즉시 더미 풀로 폴백(로컬 캡처용)
});
const page = await ctx.newPage();

async function wait(ms){ await page.waitForTimeout(ms); }

// 1) 메인 (대기 화면)
await page.goto(`${BASE}/index.html`, { waitUntil: 'load' });
await wait(700);
await page.screenshot({ path: `${OUT}/screenshot-1-main.png` });
console.log('1 main OK');

// 2) 준비 (돔에 캡슐 가득) — 검색 클릭 후 더미 채움
await page.click('#searchBtn').catch(()=>{});
await wait(3000);
await page.screenshot({ path: `${OUT}/screenshot-2-ready.png` });
console.log('2 ready OK');

// 3) 결과 (당첨 모달) — crank() 직접 호출 → 캡슐 → 톡 열기
await page.evaluate(() => { if (typeof crank === 'function') crank(); });
await page.waitForSelector('#bigcap', { timeout: 6000 }).catch(()=>{});
await wait(400);
// 캡슐 톡 (synthetic click → openCapsule 리스너 발동)
await page.evaluate(() => { const c = document.querySelector('#bigcap'); if (c) c.click(); });
await page.waitForTimeout(1500);
await page.screenshot({ path: `${OUT}/screenshot-3-result.png` });
console.log('3 result OK');

// 4) 레트로 퀴즈
await page.goto(`${BASE}/quiz/index.html`, { waitUntil: 'load' });
await wait(700);
await page.screenshot({ path: `${OUT}/screenshot-4-quiz.png` });
console.log('4 quiz OK');

await browser.close();
console.log('DONE');
