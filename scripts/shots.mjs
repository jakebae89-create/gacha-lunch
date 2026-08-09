// 스토어 스크린샷 생성 — 실제 폰 에뮬레이션 + 설치된 Chrome 사용
// 실행: node scripts/shots.mjs           (플레이스토어 + 앱스토어 둘 다)
//       node scripts/shots.mjs play      (플레이스토어만)
//       node scripts/shots.mjs ios       (앱스토어만)
// 개발서버가 8778에서 떠 있어야 함 (.claude/launch.json 의 "gacha")
import { chromium } from 'playwright-core';

const BASE = 'http://localhost:8778';
const OUT = 'store-assets';

const TARGETS = {
  // 플레이스토어: 세로:가로 비율 ≤ 2:1 유지. 850/430 = 1.98:1
  play: {
    prefix: 'screenshot',
    viewport: { width: 430, height: 850 },
    deviceScaleFactor: 2.5,
  },
  // 앱스토어: 6.9" 아이폰(iPhone 16 Pro Max) = 1320 x 2868 정확히 요구됨.
  // 440 x 956 논리 픽셀 × 3배 = 1320 x 2868
  ios: {
    prefix: 'ios-screenshot',
    viewport: { width: 440, height: 956 },
    deviceScaleFactor: 3,
  },
};

const which = process.argv[2];
const targets = which ? [which] : Object.keys(TARGETS);

const browser = await chromium.launch({ channel: 'chrome', headless: true });

for (const key of targets) {
  const t = TARGETS[key];
  if (!t) { console.error(`알 수 없는 타깃: ${key}`); continue; }

  const ctx = await browser.newContext({
    viewport: t.viewport,
    deviceScaleFactor: t.deviceScaleFactor,
    isMobile: true,
    hasTouch: true,
    locale: 'ko-KR',
    // 위치권한 미부여 → 앱이 즉시 더미 풀로 폴백(로컬 캡처용)
  });
  const page = await ctx.newPage();
  const wait = (ms) => page.waitForTimeout(ms);
  const shot = (n) => page.screenshot({ path: `${OUT}/${t.prefix}-${n}.png` });

  // 1) 메인 (대기 화면)
  await page.goto(`${BASE}/index.html`, { waitUntil: 'load' });
  await wait(700);
  await shot('1-main');

  // 2) 준비 (돔에 캡슐 가득) — 검색 클릭 후 더미 채움
  await page.click('#searchBtn').catch(() => {});
  await wait(3000);
  await shot('2-ready');

  // 3) 결과 (당첨 모달) — crank() 직접 호출 → 캡슐 → 톡 열기
  await page.evaluate(() => { if (typeof crank === 'function') crank(); });
  await page.waitForSelector('#bigcap', { timeout: 6000 }).catch(() => {});
  await wait(400);
  await page.evaluate(() => { const c = document.querySelector('#bigcap'); if (c) c.click(); });
  await wait(1500);
  await shot('3-result');

  // 4) 레트로 퀴즈
  await page.goto(`${BASE}/quiz/index.html`, { waitUntil: 'load' });
  await wait(700);
  await shot('4-quiz');

  await ctx.close();
  const { width, height } = t.viewport;
  const s = t.deviceScaleFactor;
  console.log(`${key} OK — ${width * s} x ${height * s} 4장`);
}

await browser.close();
console.log('DONE');
