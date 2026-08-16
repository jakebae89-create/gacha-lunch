# Play Store listing (English) — GachaBab

플레이 콘솔 "스토어 등록정보"의 **English (United States)** 언어에 그대로 복사해 사용하세요.
작성: 2026-08-16 (프로덕션 1.0.11 / versionCode 12 + 미업로드 1.0.12 기준)

한국어판은 `store-listing-ko.md`. 두 문서는 같은 앱을 **다른 독자**에게 파는 문서다.
한국어판 독자는 "오늘 점심 뭐 먹지"가 고민인 직장인이고,
영문판 독자는 **한국에 있거나 한국에 올 사람**이다. 그래서 구조를 그대로 번역하지 않았다.

---

## ★ 전제: 이 앱은 한국 밖에서 작동하지 않는다

`index.html`의 영문 문구가 그것을 앱 스스로 말하고 있다.

```
geoTitle: "🇰🇷 Works in South Korea only"
geoDesc:  "This app uses Korean restaurant data. Open it once you arrive in Korea…"
```

카카오맵 데이터에 의존하므로 해외에서 열면 검색 결과가 0이다.
따라서 **영문 등록정보는 "한국용 앱"임을 제목 다음 줄에서 바로 밝혀야 한다.**
그러지 않으면 오설치 → 즉시 삭제 → 별점 1점이 쌓이고, Play 정책상 기능 오인 표기에도 걸린다.

이 문서는 그 전제 위에서 **방한 여행자 + 한국 거주 외국인**을 독자로 잡았다.

---

## 앱 이름 (최대 30자)

```
GachaBab - Korea Food Picker
```

28자. 브랜드(GachaBab)를 앞에 두고 검색어 `Korea` `Food` `Picker`를 붙였다.
`Korea`를 제목에 넣은 이유는 ASO와 오설치 방지를 **한 자리에서** 해결하기 때문이다.
검색 결과 목록에서 제목만 보고도 "한국에서 쓰는 앱"임이 읽힌다.

대안: `GachaBab - Korea Food Roulette` (정확히 30자).
`Roulette`가 무작위성은 더 잘 전달하지만 30자를 꽉 채워 기기에 따라 잘릴 수 있어 보류했다.

※ 앱스토어(iOS) 영문 이름을 만들 때 이 이름과 통일할 것.
한국어판에서 두 스토어 이름을 맞춘 것과 같은 이유다.

## 간단한 설명 (최대 80자)

```
Not sure where to eat in Korea? Spin a capsule and let it pick a restaurant.
```

76자. 질문으로 열어 클릭을 만들고, `in Korea`로 대상을 즉시 좁힌다.
한국어판이 "매일 반복되는 점심 고민"을 파는 것과 달리
영문판은 **낯선 동네에서 뭘 먹을지 모르는 상황**을 판다.

## 자세한 설명 (최대 4000자)

```
Where should I eat? Let one capsule decide.

GachaBab pulls up real restaurants around you and drops them into a capsule
machine. Turn the knob, pop the capsule open, and today's place is decided.
The ten minutes you spend deciding become ten seconds.

■ For South Korea
GachaBab runs on Kakao Map data, so it finds places while you are in Korea.
Heading to Seoul, Busan or Jeju? Install it now and it's ready the moment you
land. Already living here? It works in your own neighborhood every lunch break.
Outside Korea there is nothing nearby to draw from, so save it for the trip.

■ How it works
1. Pick a radius (500m to 5km) and a food type.
2. Tap "Find restaurants nearby" and the machine fills with capsules.
3. Turn the knob, tap the capsule, and today's restaurant pops out.

■ What's inside
· Real places nearby — restaurants pulled live from Kakao Map data
· Radius — 500m / 1km / 2km / 3km / 5km
· Categories — Korean, Chinese, Japanese, Western, Snacks, Cafe and more
· Rarity grades — the rarer a kind of place is around you, the higher the
  capsule grade. The one-of-a-kind spot outranks the fifth kimbap shop.
· Kakao Map link and directions for every result
· Favorites — keep the ones you liked and open them again anytime
· Not this one — a place you exclude never comes back
· No repeats — a restaurant you already drew won't show up again until you
  have seen everything nearby
· Meet in the middle — add everyone's location and GachaBab finds a subway
  station in between, then draws a restaurant near it
· History — every place you drew stacks up like a collection
· Share — send today's pick straight to a friend
· A retro trivia quiz to play while the machine loads

■ Who it's for
· Anyone tired of hearing "anywhere is fine"
· Travelers in Korea who don't know what's good on this street
· Residents who keep ending up at the same three places
· Friends coming from different stations who need a fair place to meet

■ Good to know
· Free, no sign-up required (includes a banner ad at the bottom)
· Your location is used only to search for nearby restaurants and is never
  stored on our servers
· Available in English and Korean
· Restaurant data comes from Kakao Map, so opening hours and closures may
  differ from what you find in person
· Restaurant search covers South Korea only

Leave today's meal to the capsule.
```

약 2,000자. 4000자 한도에 여유가 많으므로 나중에 지역명(Hongdae, Gangnam 등)을
자연스럽게 섞어 색인을 넓힐 여지가 있다. 단 키워드 나열식은 피할 것.

한국어판의 `· 대표 메뉴와 가격` 항목은 **영문판에서 뺐다.**
메뉴·가격은 `DUMMY_POOL`(데모 데이터)에만 있고 카카오 실검색 결과에는 없어서
`hasMenu` 조건에 걸려 화면에 뜨지 않는다(`index.html:1961`).
실제 사용자가 못 보는 기능이므로 광고 문구에 넣을 수 없다.
→ **한국어판에서도 이 줄을 빼는 것이 맞다.** 별건으로 처리 필요.

## 카테고리

```
Food & Drink
```

## 태그/키워드 후보

```
korea food, what to eat, restaurant picker, random restaurant, korea travel,
seoul food, korean food near me, lunch decider, gacha, capsule toy,
meeting point, halfway point
```

## 개인정보처리방침 URL

```
https://jakebae89-create.github.io/gacha-lunch/privacy.html
```

한국어판과 동일한 URL을 쓴다. 방침 문서 자체는 한국어지만
Play는 언어별 방침 URL을 요구하지 않는다.

---

## 배포 국가 (같이 결정해야 하는 항목)

등록정보만 영문으로 만들고 국가를 전 세계로 열면 안 된다.
**한국에 올 일이 없는 사람에게는 작동하지 않는 앱**이라 설치당 별점 손해만 난다.

방한 관광객 상위국 + 영어권 위주로 좁히는 것을 권한다.

```
일본, 대만, 홍콩, 싱가포르, 태국, 베트남, 필리핀, 말레이시아,
미국, 캐나다, 영국, 호주, 뉴질랜드
```

중국 본토는 Play 스토어가 없어 제외. 유럽 본토는 방한 수요 대비 영문 노출 경쟁이
심해 후순위로 둔다.

## 스크린샷 (2026-08-16 촬영 완료)

`store-assets/screenshot-en-{1-ready,2-result,3-dex,4-meet,5-quiz}.png` 5장.
앱스토어용은 `ios-screenshot-en-*`.

`npm run shots` 가 한국어·영문을 한 번에 뽑는다. 언어 토글을 누르는 게 아니라
Playwright 컨텍스트의 `locale`을 `en-US`로 주는 방식이다
(앱이 localStorage에 값이 없으면 `navigator.language`로 언어를 정하기 때문).

한계는 한국어판과 동일하다 — 더미 데이터로 찍혀 카카오맵·길찾기 버튼이 빠지고
메뉴는 일부러 숨긴다. `store-listing-ko.md`의 "남은 한계" 항목 참고.

### 영문 캡션

1. "Where should I eat? Let the capsule decide"
2. "Real restaurants near you, loaded as capsules"
3. "Turn the knob to release a capsule"
4. "Tap it open — today's restaurant"
5. "The rarer the place, the higher the grade"
6. "Meeting a friend? It finds a spot in between"
