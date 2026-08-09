# 앱스토어 출시 가이드 — 가챠밥 iOS

맥 없이 Windows에서 아이폰 앱을 앱스토어에 올리는 절차입니다.
프로젝트 쪽 준비는 끝나 있고, 남은 건 **애플·카카오·Codemagic 계정 작업**입니다.

---

## 먼저 알아야 할 두 가지

**1. 맥은 없어도 되지만, 돈과 시간은 든다.**
Xcode는 macOS에서만 돌기 때문에 빌드는 클라우드 맥에서 합니다(Codemagic, 개인 무료 500분/월).
피할 수 없는 비용은 **Apple Developer Program 연 $99**(약 13만 원대) 하나입니다.
Play는 25달러 1회였지만 애플은 매년 냅니다. 안 내면 TestFlight도 심사 제출도 안 됩니다.

**2. 아이폰 실기기가 필요하다 — 이미 있음.**
TestFlight로 설치해 카카오 지도가 뜨는지 확인해야 합니다(아래 "가장 큰 기술 리스크" 참고).
본인 아이폰이 있으므로 이 관문은 해결돼 있습니다.
덤으로 **가입도 아이폰의 Apple Developer 앱으로 하는 게 웹보다 빠릅니다**(1단계 참고).

---

## 이미 해둔 것 (프로젝트 쪽)

| 항목 | 상태 |
|---|---|
| `ios/` Xcode 프로젝트 생성 | 완료 (`@capacitor/ios` 설치 + `cap add ios`) |
| 번들 ID | `com.gachalunch.app` (Play와 동일) |
| 버전 | 1.0.0 (빌드 번호는 CI가 자동 증가) |
| 앱 아이콘 1024 | 완료 — 알파 채널 없이 생성(있으면 업로드 거부됨). `make-icons.ps1` |
| 런치스크린 | 완료 — Capacitor 기본값이 **캡시터 로고**였음. 가챠밥 캡슐로 교체(`make-ios-splash.ps1`) |
| 위치 권한 안내 문구 | `Info.plist`에 한국어로 작성 (없으면 앱이 그냥 죽음) |
| 세로 화면 고정 | 완료 (가로 레이아웃이 없어서) |
| iPhone 전용 | 완료 — iPad를 빼서 iPad 스크린샷·심사 리스크 제거 |
| 암호화 수출 신고 | `ITSAppUsesNonExemptEncryption=false` — 업로드마다 묻는 절차 생략 |
| 광고(AdMob) | **iOS에서 제외** (`capacitor.config.json`의 `ios.includePlugins: []`) |
| 앱스토어 스크린샷 | `npm run shots` → `store-assets/ios-screenshot-*.png` (1320x2868) |
| 클라우드 빌드 설정 | `codemagic.yaml` |
| 등록 문구 | `store-listing-ios.md` |
| 지원 페이지 | `support.html` (앱스토어는 지원 URL이 필수) |

**광고를 왜 뺐나:** AdMob 계정이 아직 승인 전이라 iOS 광고 단위를 만들 수 없습니다.
유효한 `GADApplicationIdentifier` 없이 광고 SDK를 넣으면 앱이 실행 즉시 죽고,
넣기만 해도 App Privacy 설문에서 추적·광고 ID 신고가 줄줄이 딸려옵니다.
어차피 수익이 0원이므로 v1은 광고 없이 내고, 계정이 승인되면 그때 붙이는 게 맞습니다.
(Android 쪽 광고 설정은 손대지 않았습니다.)

---

## 순서

### 1단계 — Apple Developer Program 가입

**2026-08-09 웹으로 가입·결제 완료. 애플 승인 대기 중.**
(아이폰의 Apple Developer 앱은 진행이 안 돼서 웹으로 감.)
승인 메일이 올 때까지 이 단계에서 할 일은 없습니다. 그 사이 아래 "승인 기다리는 동안 할 일"을 하세요.

- 웹 가입은 **신분증 제출 요청 메일이 따로 올 수 있습니다.** 정상 절차이니 받으면 제출하세요.
  단 발신 도메인이 `apple.com`인지, 링크가 `developer.apple.com`으로 가는지 확인할 것.
- 가입 화면에 뜬 **Enrollment ID를 적어두세요.** 승인이 늦어져 문의할 때 이 번호를 요구합니다.
- 승인까지 보통 24~48시간. 그 안에 아무 메일도 없으면 developer.apple.com/contact 로 문의.
- **개인(Individual)** 자격으로 가입하세요. 법인(Organization)은 D-U-N-S 번호가 필요해 몇 주 걸립니다.
- Apple 계정에 **2단계 인증이 켜져 있어야** 진행됩니다. 계정 이름은 **실명**이어야 합니다.
- 이름·주소는 **영문(로마자)** 으로, 신분증 표기와 정확히 일치하게. 사서함 주소는 안 됩니다.
- 앱으로 가입하면 **연 자동 갱신 구독**, 웹으로 가입하면 연 1회 결제입니다.
- 결제 후 승인까지 보통 24~48시간. 이게 끝나야 나머지가 전부 시작됩니다.
- 개인 자격이면 스토어에 **실명이 개발자 이름으로 공개**됩니다. 상호로 내고 싶으면 법인 자격이 필요합니다.
- 무료 앱이라 **유료 앱 계약(은행·세금 정보)은 입력하지 않아도** 됩니다.

### 승인 기다리는 동안 할 일 (애플과 무관하게 진행 가능)

**1. 이번 작업분을 커밋·push.**
`privacy.html`(iOS 광고 없음 문구)과 `support.html`(지원 URL)은 **GitHub Pages에 실제로 올라가야**
심사에서 열립니다. `ios/` 프로젝트도 저장소에 있어야 Codemagic이 빌드할 수 있습니다.

**2. Codemagic 가입 + 저장소 연결.**
4단계 중 App Store Connect API 키를 빼면 전부 지금 할 수 있습니다.

**3. 카카오 콘솔에 iOS 플랫폼 등록.** ← 이게 제일 중요합니다
아래 "가장 큰 기술 리스크"의 대응 ①②를 지금 해두세요. 애플 승인과 아무 상관이 없고,
가장 오래 막힐 수 있는 항목이라 미리 손대두면 나중에 며칠을 법니다.

**4. 앱 이름 확정.**
`가챠밥 - 점심 메뉴 추천 랜덤 맛집 뽑기` 를 그대로 갈지, 짧은 안으로 갈지.
애플은 이름에 키워드 나열을 Play보다 깐깐하게 봅니다(지침 2.3.7).

### 2단계 — App Store Connect에 앱 만들기

가입 승인 후 appstoreconnect.apple.com 에서:

1. **Certificates, Identifiers & Profiles → Identifiers → +** 로 `com.gachalunch.app` 등록
   (Capabilities는 아무것도 켜지 마세요. 안 쓰는 걸 켜면 심사에서 물어봅니다.)
2. **App Store Connect → 앱 → +** 로 새 앱 생성
   - 플랫폼 iOS / 이름·기본 언어·번들 ID·SKU는 `store-listing-ios.md` 표대로
3. 생성된 앱의 **앱 정보 → Apple ID** 에 뜨는 숫자(10자리)를 복사

### 3단계 — App Store Connect API 키 발급

Codemagic이 자동으로 서명하고 업로드하려면 이 키가 필요합니다.

**사용자 및 액세스 → 통합 → App Store Connect API → 팀 키 → +**

- 역할: **App Manager**
- 발급되면 **`.p8` 파일은 딱 한 번만 다운로드됩니다.** 잃어버리면 재발급뿐입니다.
- `Issuer ID`, `Key ID`, `.p8` 세 개를 챙겨두세요.

### 4단계 — Codemagic 연결

codemagic.io 가입(GitHub 계정으로) →

1. `jakebae89-create/gacha-lunch` 저장소 연결
2. **Teams → Integrations → App Store Connect** 에 3단계의 키 3종을 등록.
   **이름은 반드시 `gachalunch`** 로 지으세요 — `codemagic.yaml`이 그 이름을 찾습니다.
3. `codemagic.yaml`의 `APP_STORE_APP_ID: 0000000000` 을 2단계에서 복사한 숫자로 교체 → 커밋·push
4. 대시보드에서 `가챠밥 iOS (App Store)` 워크플로 **Start new build**

성공하면 IPA가 자동으로 TestFlight에 올라갑니다. 첫 빌드는 20~30분쯤 봅니다.
실패하면 로그에서 `xcodebuild` 단계를 먼저 보세요. 대부분 서명(2·3단계) 문제입니다.

### 5단계 — TestFlight에서 실기기 확인 (여기가 진짜 관문)

App Store Connect → TestFlight → 내부 테스터로 본인 추가 → 아이폰에 TestFlight 앱 설치.

**반드시 확인할 것:**

- [ ] 앱이 켜지고 가챠 머신이 그려지는가
- [ ] 위치 권한 팝업이 뜨고, 허용하면 **주변 식당이 실제로 검색되는가** ← 최우선
- [ ] 캡슐 뽑기 → 결과 카드 → 카카오맵 열기 / 길찾기
- [ ] 맛집 저장·기록이 앱을 껐다 켜도 남아 있는가
- [ ] 하단에 광고 자리가 비어 보이지 않는가 (iOS는 광고를 뺐으니 레이아웃이 안 비어야 함)

### 6단계 — 심사 제출

`store-listing-ios.md` 의 문구·스크린샷·App Privacy 답안을 채우고 **심사 제출**.
보통 24~48시간 안에 결과가 옵니다. 첫 제출은 반려를 각오하는 게 정상입니다.

---

## 가장 큰 기술 리스크 — 카카오 지도가 iOS에서 안 뜰 수 있음

**증상이 나오면 여기부터 보세요.** 앱은 켜지는데 식당 검색이 아예 안 되는 경우입니다.

Android는 `capacitor.config.json`의 `androidScheme: "https"` + `hostname` 덕분에
웹뷰 주소가 `https://jakebae89-create.github.io` 가 되고, 이게 카카오에 등록한 도메인과
정확히 일치해서 통과하고 있습니다.

**iOS는 이 수법을 못 씁니다.** WKWebView는 `https` 스킴을 앱이 가로채는 걸 금지해서
(`iosScheme`를 `https`로 두면 실행 즉시 크래시) iOS 웹뷰 주소는
`capacitor://jakebae89-create.github.io` 가 됩니다. 카카오 서버가 이 Referer를 보고
등록 안 된 도메인이라고 거절할 수 있습니다.

**대응 순서:**

1. 카카오 개발자 콘솔 → 내 애플리케이션 → 앱 설정 → **플랫폼 → Web** 의 사이트 도메인에
   `capacitor://jakebae89-create.github.io` 추가를 시도. (형식 검증에 걸려 거부될 수 있음)
2. 같은 화면의 **플랫폼 → iOS** 에 번들 ID `com.gachalunch.app` 등록 (무료, 해둬서 나쁠 것 없음)
3. 그래도 안 되면 최후 수단으로 `capacitor.config.json` 에
   `"server": { "url": "https://jakebae89-create.github.io/gacha-lunch/" }` 를 넣어
   앱이 웹을 직접 띄우게 합니다.
   **단 이건 권하지 않습니다** — 오프라인에서 앱이 백지가 되고,
   애플 심사 지침 4.2(웹사이트를 그냥 감싼 앱)에 걸릴 확률이 크게 올라갑니다.

이건 Windows에서는 확인할 방법이 없습니다. **5단계 TestFlight가 유일한 검증 지점입니다.**

---

## 반려 위험 요소

애플은 Play보다 반려가 잦습니다. 이 앱에서 걸릴 만한 곳:

**4.2 최소 기능** — 가장 현실적인 위험입니다. 심사자가 "웹페이지를 앱으로 감싼 것"으로 보면
반려합니다. 방어 논리는 위치 기반 검색 + 가챠 연출 + 기기 내 저장(맛집·기록)이며,
심사 메모(`store-listing-ios.md` 하단)에 이걸 미리 적어두는 게 도움이 됩니다.

**2.1 완전한 정보 / 지역 제한** — 심사자는 대개 미국에서 앱을 엽니다.
가챠밥은 한국 데이터만 있어서 심사자 눈에는 "아무것도 안 나오는 앱"으로 보입니다.
심사 메모에 **서울 좌표(37.5665, 126.9780)로 위치를 시뮬레이션해 달라**고 반드시 적으세요.
이 한 줄이 없어서 반려되는 경우가 많습니다.

**5.1.1 위치 권한** — 권한 요청 문구가 목적을 설명해야 합니다. 이미 넣었습니다.

**1.4.3 / 지원 URL** — 지원 URL이 404거나 연락처가 없으면 반려됩니다.
`support.html` 을 **push 해서 실제로 열리는지** 확인하세요.

**개인정보처리방침** — 이미 있는 방침에 "iOS 버전에는 광고가 없다"는 문장을 넣어뒀습니다.
방침이 광고를 얘기하는데 App Privacy 설문에는 광고가 없다고 답하면 심사자가 의심하기 때문입니다.
이것도 **push 해야 반영**됩니다.

---

## 코드 고칠 때 (Android와 함께)

```bash
npm run sync:all
```

`www/` 를 다시 만들고 android·ios 양쪽에 반영합니다.
iOS는 커밋만 하면 Codemagic이 알아서 빌드하므로, 로컬에서 `cap sync ios` 를
직접 돌릴 일은 거의 없습니다(Windows에서는 CocoaPods 단계가 어차피 건너뜁니다).

버전을 올릴 때는 `ios/App/App.xcodeproj/project.pbxproj` 의 `MARKETING_VERSION` 을 고치세요.
빌드 번호(`CURRENT_PROJECT_VERSION`)는 CI가 TestFlight 최신 번호 +1로 자동 지정합니다.
