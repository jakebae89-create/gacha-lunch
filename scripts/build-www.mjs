// 가챠밥 웹 자산을 Capacitor 빌드 폴더(www/)로 복사한다.
// - 루트 파일들은 GitHub Pages 배포용으로 그대로 두고,
//   여기서는 앱(Capacitor)에 들어갈 파일만 골라 www/ 로 복사한다.
// - 변경 후에는 `npm run sync` 로 www/ 갱신 + 안드로이드 동기화.

import { existsSync, rmSync, mkdirSync, cpSync } from "node:fs";
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

console.log(`\n✅ www/ 생성 완료 (${copied}개 항목)`);
