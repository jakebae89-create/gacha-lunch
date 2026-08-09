// 가챠밥 웹 자산을 Capacitor 빌드 폴더(www/)로 복사한다.
// - 루트 파일들은 GitHub Pages 배포용으로 그대로 두고,
//   여기서는 앱(Capacitor)에 들어갈 파일만 골라 www/ 로 복사한다.
// - 변경 후에는 `npm run sync` 로 www/ 갱신 + 안드로이드 동기화.

import { existsSync, rmSync, mkdirSync, cpSync, readFileSync, writeFileSync } from "node:fs";
import { dirname, join } from "node:path";
import { fileURLToPath } from "node:url";

const root = join(dirname(fileURLToPath(import.meta.url)), "..");
const out = join(root, "www");

// 앱에 포함할 파일/폴더 화이트리스트
const include = [
  "index.html",
  "manifest.webmanifest",
  "sw.js",
  "privacy.html",
  "icon-192.png",
  "icon-512.png",
  "apple-touch-icon-180.png",
  "quiz",
];

// www/ 초기화
rmSync(out, { recursive: true, force: true });
mkdirSync(out, { recursive: true });

let copied = 0;
for (const name of include) {
  const src = join(root, name);
  if (!existsSync(src)) {
    console.warn(`  (건너뜀) 없음: ${name}`);
    continue;
  }
  cpSync(src, join(out, name), { recursive: true });
  copied++;
  console.log(`  복사: ${name}`);
}

// ── 카카오 REST 키 주입 ──
// iOS는 웹뷰 출처가 capacitor:// 라서 JS SDK 장소검색이 막힌다. 그래서 REST API를
// 네이티브 HTTP로 부르는데, 그 키를 저장소나 GitHub Pages에 남기지 않으려고
// 여기서만 채워 넣는다. 키는 Codemagic 환경변수 KAKAO_REST_KEY 로 넣는다.
const restKey = (process.env.KAKAO_REST_KEY || "").trim();
const indexPath = join(out, "index.html");
if (restKey && existsSync(indexPath)) {
  const html = readFileSync(indexPath, "utf8");
  writeFileSync(indexPath, html.replaceAll("__KAKAO_REST_KEY__", restKey));
  console.log("  카카오 REST 키 주입 완료");
} else if (!restKey) {
  console.warn("  (주의) KAKAO_REST_KEY 가 없어 iOS 장소검색은 더미로 동작합니다");
}

console.log(`\n✅ www/ 생성 완료 (${copied}개 항목)`);
