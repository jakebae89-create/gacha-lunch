# 심사 회신 초안 — Guideline 2.1 Information Needed (제출 ID 4d6ffc94-653b-461b-9578-ee46349bafee)

App Store Connect → 앱 심사 → **앱 심사에 회신**에 아래 영문 본문을 그대로 붙여넣습니다.
회신 전에 **① 화면 녹화 파일**과 **② 아래 대괄호 두 곳**(기기 모델/iOS 버전)을 채워야 합니다.

---

## 화면 녹화 — 준비됨, 다만 마지막 부분에 실패 장면이 들어 있습니다

`ios/gacha-lunch.MP4`(84초, 108MB, HEVC)를 프레임 단위로 확인했습니다. 필요한 건 다 들어 있습니다:
TestFlight에서 앱 실행 → 위치 권한 팝업 → 반경 선택 → 주변 식당 검색 → 캡슐이 차는 화면 →
손잡이 → 캡슐 열기 → 결과 카드 → 길찾기로 카카오맵 이동 → 앱 복귀 → 재검색 → 맛집 저장(⭐저장됨).

**문제는 47~68초 구간의 "어디서 만날까요"(중간지점)입니다.** "강남"을 검색하면 10초쯤 "검색 중…"
이 돌다가 **"검색을 사용할 수 없어요 — 키/도메인을 확인하세요"** 로 끝납니다. 연출이 아니라
실제 버그였고, 이 영상을 그대로 보내면 심사자가 기능 실패 장면을 보게 됩니다(2.1 bugs 반려 사유).

원인은 이미 아는 것과 같습니다 — 중간지점의 친구 위치 검색만 카카오 **JS SDK**(`keywordSearch`)를
계속 쓰고 있었습니다. iOS 웹뷰 출처(`capacitor://`)에서는 이 호출이 응답을 주지 않습니다.
장소검색을 REST로 옮길 때 카테고리 검색만 바꾸고 이쪽을 빠뜨린 것입니다.

**고쳐 뒀습니다**(`index.html`, 미커밋):
- `restKeywordSearch()` 추가 → iOS에서 친구 위치 검색이 REST로 나갑니다.
- `findSubwayNear()`도 iOS에서 REST로 — 이쪽은 조용히 빈 결과를 반환해서 **중간지점을 찾아도 추천
  지하철역이 안 나오고 지도 링크만 뜨는 상태**였습니다. 화면에 에러가 안 떠서 영상만으로는 안 보입니다.
- 웹·안드로이드 경로는 그대로입니다(`useRestSearch()`가 iOS에서만 true).

### 그래서 두 갈래입니다

**A. 고친 빌드로 다시 (권장)** — Codemagic 새 빌드 → TestFlight 설치 → 같은 흐름으로 재녹화 →
새 빌드를 버전에 붙여 재제출 + 회신. 하루쯤 더 걸리지만, 심사자가 중간지점을 직접 눌러봐도
멀쩡합니다. 이 기능은 앱스토어 설명에도 "친구랑 중간지점 찾기"로 적혀 있어서, 깨진 채로 통과해도
다음 심사나 사용자 리뷰에서 다시 문제가 됩니다.

**B. 지금 바로 회신** — 실패 구간을 잘라낸 46초짜리로 회신하고, 중간지점 수정은 1.0.1로 넘깁니다.
빠르지만 심사자가 그 기능을 직접 눌러보면 같은 에러를 만납니다.

바탕화면에 두 파일을 만들어 뒀습니다(H.264로 변환 — 원본 HEVC 108MB는 첨부 용량에 걸립니다):
- `gacha-lunch-review.mp4` — 전체 84초, 6.4MB (A안에서 재녹화 전까지의 참고용)
- `gacha-lunch-review-short.mp4` — 0~46초, 3.7MB (B안 첨부용, 실패 구간 잘림)

재녹화한다면 TestFlight 앱을 **한 번 삭제 후 재설치**하세요 — 위치 권한 팝업이 다시 나와야 합니다.
애플이 "sensitive data 접근 프롬프트를 녹화에 포함하라"고 명시했습니다.

> 참고: 30~32초의 앱 전환 화면에 사파리·카카오맵 등 다른 앱 미리보기가 같이 찍혔습니다.
> 문제될 건 없지만 재녹화한다면 앱 전환 대신 좌하단 "뒤로" 링크로 돌아오는 편이 깔끔합니다.

**녹화 원본은 git에 올라가면 안 됩니다.** 108MB라 GitHub 100MB 제한에 걸려 push 자체가 거부됩니다.
`.gitignore`에 `*.MP4`/`*.mov`를 추가해 뒀습니다.

같은 내용을 **앱 심사 정보의 메모(Notes)** 란에도 넣어 두라고 애플이 요청했습니다.
회신 후 메모란도 아래 본문으로 교체하세요(다음 제출부터 같은 문의를 안 받습니다).

---

## 회신 본문 (영문, 그대로 복사)

```
Thank you for the review. Please find the requested information below.

1. SCREEN RECORDING
A screen recording captured on a physical iPhone running the latest iOS is
attached to this message. It begins with launching the app and shows the typical
user flow through the core features: the location permission prompt, selecting a
search radius, searching for nearby restaurants, the capsule machine filling with
the real restaurants found around the current location, pulling the lever to draw
a capsule, opening the capsule to reveal the selected restaurant, and the result
card with its details. It then shows the directions link opening the restaurant
in Kakao Map, returning to the app, drawing again, and saving a restaurant to
the favorites list.

The app has no account registration, login, or account deletion flow, no paid
content, subscriptions, or in-app purchases, and no user-generated content.
The only sensitive-data prompt is the location permission prompt, which is
included in the recording. The app does not use App Tracking Transparency
because it does not track users.

2. DEVICES AND OS TESTED
- iPhone [모델명], iOS [버전] (physical device, via TestFlight)
- iPhone Simulator, iOS [버전] (Xcode Cloud / Codemagic build verification)

3. WHAT THE APP DOES AND WHO IT IS FOR
Gachabap ("가챠밥") solves the everyday "what should we eat for lunch?" problem.
Deciding where to eat takes people several minutes every day and usually ends
with the same few restaurants. The app searches for real restaurants around the
user's current location and then randomly picks exactly one of them, presented
as a capsule-toy (gacha) machine: the capsules represent the actual nearby
restaurants, and pulling the lever draws one.

Target audience: office workers and students in South Korea choosing a place for
lunch or dinner, people who recently moved or changed jobs and do not know the
restaurants in their new neighborhood, and friends looking for a meeting point
between two locations.

Additional features: rarity grades (a restaurant type that is uncommon in that
neighborhood appears as a higher-grade capsule), saving favorite restaurants,
excluding restaurants the user does not want to see again, a draw history, a
midpoint search between two locations, sharing the result, and a small retro
trivia quiz to play while the search runs. Saved restaurants and history are
stored only on the device.

4. HOW TO SET UP AND ACCESS THE MAIN FEATURES
No login credentials or sample files are required. There is no account of any
kind and every feature is available immediately on first launch.

  a. Launch the app and allow location access when prompted.
  b. Choose a search radius (500 m to 5 km) and, optionally, a food category
     (Korean, Chinese, Japanese, Western, snack, cafe).
  c. Tap "주변 식당 검색" (Search nearby restaurants). The capsule machine fills
     with the restaurants found around the current location.
  d. Pull the lever to draw a capsule, then tap the capsule to open it. The
     result card shows the selected restaurant with its category, distance,
     phone number, a Kakao Map link, and a directions link.
  e. Other features are reached from the buttons on the result card and the
     main screen: save, exclude, share, draw history, and midpoint search.

IMPORTANT FOR TESTING: restaurant data is available for South Korea only (see
item 6). If the device is located outside South Korea, please simulate a
location in Seoul, South Korea — for example latitude 37.5665, longitude
126.9780 — so that real restaurant data is returned. Without a Korean location
the app still runs, but it displays a notice banner and falls back to built-in
sample restaurants.

5. EXTERNAL SERVICES USED
- Kakao Local API (Kakao Corp., https://developers.kakao.com) — the only
  external service. It is used to search for restaurants and cafes around the
  given coordinates and returns the business name, category, phone number,
  address, coordinates, and a Kakao Map page link. On iOS the app calls the
  Kakao Local REST API directly over HTTPS from native code.
- Kakao Map web pages (https://map.kakao.com) — opened in the system browser
  when the user taps the map or directions link on a result card.

There is no authentication service, no payment processor, no AI service, no
analytics or attribution SDK, and no advertising SDK in this build. The app has
no backend of its own: the user's coordinates are sent only to the Kakao Local
API to perform the search and are never stored on any server we operate. All
other content (the capsule machine, images, and the quiz) is bundled inside the
app and works offline.

6. REGIONAL DIFFERENCES
Yes, there is a regional difference. The restaurant data source, Kakao Local
API, covers South Korea only, so real restaurant results are returned only for
locations inside South Korea. Outside South Korea the app is fully functional
but displays a notice banner and uses built-in sample restaurant data so that
the gacha experience can still be seen. The app's features, UI, and behavior are
otherwise identical in all regions. The app is available in Korean and English.

7. REGULATED INDUSTRY / THIRD-PARTY MATERIAL
The app does not operate in a highly regulated industry. It contains no
gambling, no real-money mechanics, no health or financial content, and no
age-restricted material; the capsule draw is a purely visual randomizer with no
wagering, prizes, or purchases of any kind.

The restaurant information comes from the Kakao Local API, used under the Kakao
Developers terms of service with our registered developer application, and each
result links back to its Kakao Map page. All other assets — app icon, capsule
graphics, illustrations, and quiz questions — were created by us for this app.

Please let us know if any further information would help complete the review.
```

### A안(고친 빌드로 재녹화)으로 갈 경우

재녹화 영상에 중간지점 찾기와 뽑은 기록·퀴즈까지 담았다면, 본문 1번 두 번째 문단 앞에
아래 한 문장을 더하세요. **영상에 없는 기능은 적지 마세요** — 심사자가 대조합니다.

```
The recording also shows the "find a midpoint" feature, which searches for a
place between two locations, the draw history, and the built-in trivia quiz.
```
