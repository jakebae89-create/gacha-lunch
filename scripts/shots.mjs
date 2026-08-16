// 스토어 스크린샷 생성 — 실제 폰 에뮬레이션 + 설치된 Chrome 사용
// 실행: node scripts/shots.mjs                (플레이 + 앱스토어, 한/영 전부)
//       node scripts/shots.mjs play           (플레이스토어만, 한/영)
//       node scripts/shots.mjs play ko        (플레이스토어 한국어만)
//       node scripts/shots.mjs ios en         (앱스토어 영문만)
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

// 앱은 localStorage(gachaLang)가 없으면 navigator.language로 언어를 정한다.
// locale만 바꾸면 토글을 누르지 않아도 그 언어로 뜬다.
const LOCALES = {
  ko: { locale: 'ko-KR', suffix: '' },
  en: { locale: 'en-US', suffix: '-en' },
};

// 대표 메뉴·가격은 DUMMY_POOL(데모)에만 있고 카카오 실검색 결과에는 없다.
// 로컬 캡처는 더미로 도는데, 그대로 찍으면 실사용자가 보지 못하는 화면을
// 스토어에 올리게 된다. 캡처 동안만 숨겨 실제 결과 카드와 같은 모습으로 맞춘다.
const HIDE_MENU = '.menu-title, #result ul.menu { display: none !important; }';

const args = process.argv.slice(2);
const targets = args.filter((a) => TARGETS[a]);
const langs = args.filter((a) => LOCALES[a]);
const runTargets = targets.length ? targets : Object.keys(TARGETS);
const runLangs = langs.length ? langs : Object.keys(LOCALES);

const browser = await chromium.launch({ channel: 'chrome', headless: true });

for (const key of runTargets) {
  const t = TARGETS[key];

  for (const lang of runLangs) {
    const L = LOCALES[lang];
    const ctx = await browser.newContext({
      viewport: t.viewport,
      deviceScaleFactor: t.deviceScaleFactor,
      isMobile: true,
      hasTouch: true,
      locale: L.locale,
      // 위치권한 미부여 → 앱이 즉시 더미 풀로 폴백(로컬 캡처용)
    });
    const page = await ctx.newPage();
    const wait = (ms) => page.waitForTimeout(ms);
    const shot = (n) => page.screenshot({ path: `${OUT}/${t.prefix}${L.suffix}-${n}.png` });
    const tap = (sel) => page.click(sel, { timeout: 4000 }).catch(() => {});
    const done = [];

    // 캡슐을 뽑고 결과 카드를 여는 한 사이클
    const draw = async () => {
      await page.evaluate(() => { if (typeof crank === 'function') crank(); });
      await page.waitForSelector('#bigcap', { timeout: 6000 }).catch(() => {});
      await wait(400);
      await page.evaluate(() => { const c = document.querySelector('#bigcap'); if (c) c.click(); });
      await wait(1500);
    };

    await page.goto(`${BASE}/index.html`, { waitUntil: 'load' });
    await page.addStyleTag({ content: HIDE_MENU });
    await wait(700);

    // 1) 캡슐이 가득 찬 머신 — 빈 유리돔을 첫 장으로 쓰던 문제를 여기서 바로잡는다
    await tap('#searchBtn');
    await wait(3000);
    await shot('1-ready'); done.push('1-ready');

    // 2) 당첨 결과 카드
    await draw();
    if (await page.$('#resultWrap:not(.hidden)')) { await shot('2-result'); done.push('2-result'); }

    // 3) 기록/맛집 목록 — 저장 한 번 + 몇 번 더 뽑아 목록을 채운 뒤 연다
    await tap('#favBtn');
    await wait(300);
    for (let i = 0; i < 3; i++) { await tap('#againBtn'); await wait(900); await draw(); }
    await tap('#favBtn');
    await wait(300);
    await page.evaluate(() => {
      const w = document.querySelector('#resultWrap');
      if (w) w.classList.add('hidden');
    });
    await wait(300);
    await tap('#dexBtn');
    await wait(900);
    if (await page.$('#dexWrap:not(.hidden)')) { await shot('3-dex'); done.push('3-dex'); }
    await tap('#dexClose');
    await wait(500);

    // 4) 약속 장소(중간지점) — 카카오 검색이 로컬에서 막히면 입력 화면까지만 담긴다
    // 도감을 닫은 직후엔 버튼 클릭이 백드롭에 먹히는 일이 있어 openMeet()을 직접 부른다
    await page.evaluate(() => { if (typeof openMeet === 'function') openMeet(); });
    await wait(900);
    if (await page.$('#meetWrap:not(.hidden)')) { await shot('4-meet'); done.push('4-meet'); }
    await tap('#meetClose');
    await wait(400);

    // 5) 레트로 퀴즈
    await page.goto(`${BASE}/quiz/index.html`, { waitUntil: 'load' });
    await wait(900);
    await shot('5-quiz'); done.push('5-quiz');

    await ctx.close();
    const { width, height } = t.viewport;
    const s = t.deviceScaleFactor;
    console.log(`${key}/${lang} OK — ${width * s} x ${height * s} — ${done.length}장: ${done.join(', ')}`);
  }
}

await browser.close();
console.log('DONE');
