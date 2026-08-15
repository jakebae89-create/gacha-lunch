# 심사 회신 — Guideline 2.1 Information Needed (제출 ID 4d6ffc94-653b-461b-9578-ee46349bafee)

App Store Connect → 앱 심사 → **앱 심사에 회신**에 아래 영문 본문을 그대로 붙여넣습니다.
**"제출 취소"는 누르지 마세요** — 누르면 처음부터 다시 제출해야 합니다.

## 지금 남은 것 (2026-08-15)

**고친 빌드 1.0(3)으로 간다**로 정했습니다(2026-08-14). 빌드는 TestFlight에 올라가 있고
"제출 준비 완료"까지 확인했습니다.

**2026-08-15 11:22 녹화(66초)로 중간지점 실기기 검증 완료.** 어제 고친 두 곳 다 정상입니다 —
"강남" 검색 → 결과 목록에서 강남대학교 선택(47초), 추천 약속 장소 **🚇 어정역 에버라인**과
각자 거리 1.8km/945m 표시(56초). 실기기 검증이 없던 `findSubwayNear`도 살았습니다.

### 쓸 녹화 두 개 — 실행 장면용 + 기능용

애플 1번은 "**must begin with launching the app**"이라고 못박아 놨는데 49초 테이크는
메인 화면에서 시작합니다(0초 프레임이 이미 앱 안). 그래서 실행부터 찍은 테이크를 하나 더 받아
**둘 다 첨부**하기로 했습니다. 회신 본문 1번도 두 영상을 설명하도록 고쳤습니다.

**① `ios/ScreenRecording_08-15-2026 17-42-03_1.MP4` (21초) → 변환본 `gacha-lunch-review-launch.mp4`**
홈 화면에서 **가챠밥 아이콘 탭** → 스플래시 → 메인 → 1km → 주변 식당 검색 → 캡슐 채워짐 →
손잡이 → 캡슐 열기 → 결과 카드(마야카페) → 카카오맵 보기 → 카카오맵 장소 페이지.
끝의 **제어센터 내리는 1.7초는 잘라냈습니다**(19.6초, 2.5MB). 길찾기는 안 열어서 경로 기록 노출 없음.

**② `ios/ScreenRecording_08-15-2026 11-48-23_1.MP4` (49초) → 변환본 `gacha-lunch-review-final.mp4`**
①에 없는 기능이 여기 있습니다:
10초 결과 카드 + **⭐저장됨**(맛집 저장) → 16초 한 번 더 뽑기 → 34초 압구정로데오거리 →
**🚇 판교역 신분당선** 추천 + 각자 거리 → 40초 "이 근처 식당 가챠로 뽑기" →
49초 카카오맵에서 디켄트(성남시 분당구 판교역로) 확인.
알림 배너 없고, 앱 스위처 안 열리고, 카카오맵 개인 경로 기록도 안 나옵니다.
H.264 변환본 49초 4.6MB.

### 같이 첨부할 스크린샷 = `ios/IMG_5463.PNG`

**위치 권한 팝업은 영상에 안 담깁니다 — iOS 제약입니다.** 시스템 권한 알림은 앱 창 밖 별도
프로세스에 그려져 화면 녹화에서 제외됩니다(기기에서 확인함). 앱 코드로 어쩔 수 있는 게 아닙니다.
**스크린샷으로는 잡혀서**(1125×2436) 영상과 함께 첨부하고, 회신 본문 1번에 그 사정을 적었습니다.
한때 이 해상도가 12 mini(패널 1080×2340)와 안 맞아 보였는데, 12 mini는 375×812 pt @3x로
**1125×2436을 렌더한 뒤 패널 크기로 줄이는** 기종이라 스크린샷은 이 값이 맞습니다. 기기명 수정 불필요.

스크린샷에 팝업 전문 + 뒤에 "주변 식당을 캡슐에 담는 중…" 화면이 같이 나와서 팝업이 뜨는
시점까지 보입니다. 용도 설명("위치는 식당을 검색할 때만 쓰고 저장하지 않습니다")도 들어가 있어
심사에 유리합니다.

팝업은 앱 실행 시가 아니라 **"주변 식당 검색"을 누르는 순간** 나갑니다
(`getPosition()` → `navigator.geolocation.getCurrentPosition`, index.html 1331행).
영상에서는 캡슐이 차기 시작하는 지점이 그 순간입니다.

### 남은 일 — 전부 App Store Connect에서 하는 일입니다

1. ASC 버전 1.0에 **빌드 3**을 붙이고 재제출
2. **앱 심사 → 앱 심사에 회신**에 아래 본문을 붙여넣고 **세 파일을 같이 첨부**(전부 바탕화면)
   - `gacha-lunch-review-launch.mp4` (19.6초, 2.5MB) — 앱 실행부터
   - `gacha-lunch-review-final.mp4` (49초, 4.6MB) — 저장·재추첨·중간지점
   - `gacha-lunch-permission-prompt.png` (1125×2436) — 위치 권한 팝업
   `ios/`의 원본 `.MP4`(HEVC)가 아니라 변환본을 올려야 합니다.
3. **같은 본문을 앱 심사 정보의 메모(Notes)** 에도 넣기
   (애플이 요청한 사항이고, 다음 제출부터 같은 문의를 안 받습니다)
4. 제출 전에 **EU 거래자(DSA) 자격** 배너 처리 — 미신고면 EU에서 앱이 내려갑니다.
   한국 데이터뿐이라 EU 배포 제외도 선택지입니다.

**회신 입력란은 4000자 제한입니다.** 처음 본문이 6,897자여서 7항목 답을 하나도 빼지 않고
문장만 조여 **3,961자**로 줄였습니다(개행을 CRLF로 세도 3,988자). 그대로 붙여넣으면 들어갑니다.
줄이면서 4-a에 **좌상단 EN 버튼으로 UI 전체가 영어로 바뀐다**는 안내를 넣었고, 권한 문구는
한국어 원문 대신 **영문 설명**만 남겼습니다(심사자가 스크린샷의 한글을 못 읽으므로).

### 헷갈리기 쉬운 파일 — 이건 올리면 안 됩니다

`ios/`의 못 쓰는 녹화들은 정리됐고 최종본 하나만 남아 있습니다. 다만 **바탕화면에 이름이 비슷한
구 빌드 영상 두 개가 그대로 있습니다** — 첨부 파일 고를 때 이걸 집으면 안 됩니다.

- `gacha-lunch-review.mp4`(6.4MB) / `gacha-lunch-review-short.mp4`(3.7MB) — **구 빌드**.
  중간지점에서 "검색을 사용할 수 없어요 — 키/도메인을 확인하세요"가 찍혀 있습니다.
- 올릴 것은 **`-launch`** 와 **`-final`** 이 붙은 두 개뿐입니다.

**녹화 원본은 git에 올라가면 안 됩니다.** 100MB를 넘으면 GitHub가 push 자체를 거부합니다.
`.gitignore`에 `*.MP4`/`*.mov`를 넣어 뒀습니다.

> 고친 내용(참고): 중간지점의 친구 위치 검색이 카카오 **JS SDK**(`keywordSearch`)를 계속 쓰고
> 있었고, iOS 웹뷰 출처(`capacitor://`)에서는 이 호출이 응답을 주지 않습니다. 장소검색을 REST로
> 옮길 때 카테고리 검색만 바꾸고 이쪽을 빠뜨린 것입니다. `restKeywordSearch()`를 추가하고
> `meetSearch`·`findSubwayNear` 두 곳을 `useRestSearch()`로 분기했습니다(커밋 `be079c2`).
> 웹·안드로이드 경로는 그대로입니다.

---

## 회신 본문 (영문, 그대로 복사)

```
Thank you for the review.

1. SCREEN RECORDING
Two recordings are attached, both made on a physical iPhone 12 mini (iOS 18.7.8). The 20-second one begins on the Home Screen with tapping the app icon and shows the core flow: choosing a radius, searching, the machine filling with the real restaurants found nearby, pulling the lever, opening the capsule, the result card, and its map link opening that restaurant in Kakao Map. The 49-second one adds saving to favorites, a second draw, and the midpoint search, which suggests a subway station between two locations and draws a restaurant near it.
The location permission prompt is in the attached screenshot, not the videos: iOS draws that alert outside the app's window and excludes it from recordings. It appears when the user first taps "주변 식당 검색" (Search nearby restaurants), when the machine starts filling. Its Korean text says the location is needed to find restaurants near the user, is used only for the search, and is not stored.
The app has no registration, login, account deletion, paid content, in-app purchases, or user-generated content. Location is the only sensitive-data prompt; the app does not use App Tracking Transparency because it does not track users.

2. DEVICES AND OS TESTED
iPhone 12 mini, iOS 18.7.8 - physical device, via TestFlight.

3. WHAT THE APP DOES AND WHO IT IS FOR
Gachabap ("가챠밥") answers the daily question "what should we eat?". It finds real restaurants around the user's location and picks one at random, shown as a capsule-toy (gacha) machine: each capsule is an actual nearby restaurant, and pulling the lever draws one. It is for office workers and students in South Korea, people new to a neighborhood, and friends meeting halfway. Other features: rarity grades, favorites, an exclude list, history, midpoint search, sharing, and a quiz during the search; all stored only on the device.

4. HOW TO SET UP AND ACCESS THE MAIN FEATURES
No credentials or sample files are needed: there is no account of any kind, and every feature works on first launch.
a. Launch the app and allow location access. "EN" (top left) switches the interface to English.
b. Choose a radius (500 m to 5 km) and, optionally, a food category, then tap "주변 식당 검색" (Search nearby restaurants); the machine fills with what it finds.
c. Pull the lever, then tap the capsule. The result card shows the restaurant's category, distance, phone number, and map and directions links.
IMPORTANT FOR TESTING: restaurant data covers South Korea only (item 6). If the device is outside South Korea, please simulate a location in Seoul - for example 37.5665, 126.9780 - so that real data is returned.

5. EXTERNAL SERVICES USED
Kakao Local API (Kakao Corp., developers.kakao.com) is the only external service: it returns nearby places with name, category, phone number, address, coordinates, and a Kakao Map link; on iOS the app calls its REST endpoint over HTTPS from native code. Result cards also link out to Kakao Map pages. There is no authentication, payment, AI, analytics, or advertising SDK, and no backend of our own: coordinates go only to Kakao for the search and are never stored on a server we operate. Everything else is bundled and works offline.

6. REGIONAL DIFFERENCES
Yes. Kakao Local API covers South Korea only, so real results appear only there. Elsewhere the app is fully functional but shows a notice banner and uses built-in sample data. Behavior is otherwise identical, and the app is available in Korean and English.

7. REGULATED INDUSTRY / THIRD-PARTY MATERIAL
The app is not in a regulated industry: no gambling, real-money mechanics, health or financial content, or age-restricted material, and the capsule draw is a visual randomizer with no wagering or prizes. Restaurant data comes from the Kakao Local API under the Kakao Developers terms of service with our registered application, and each result links back to its Kakao Map page. All other assets were created by us.
```
