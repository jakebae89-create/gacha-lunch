# 앱스토어 등록정보 (영문) — GachaBab / iOS

App Store Connect의 **영어(미국)** 로케일에 그대로 복사해 넣으세요.
작성: 2026-08-23 (1.0.1 기준)

한국어판은 `store-listing-ios.md`, Play 영문판은 `store-listing-en.md`.

> **Play 영문 등록정보(2026-08-16 등록)와는 별개 작업이다.** 등록정보는 스토어마다 따로
> 관리되므로 Play에 넣었다고 앱스토어에 반영되지 않는다.
>
> **왜 새로 썼나:** iOS는 영문 로케일이 만들어진 적이 없어서 1.0.1 버전을 만들 때
> 기본 언어(한국어) 내용이 그대로 복사돼 들어갔다. 페이지를 새로고침해도 한국어가
> 남아 있는 것으로 확인함(2026-08-23). Play 영문 문구를 그대로 못 쓰는 이유는
> iOS에만 있는 필드(부제목 30자·키워드 100자·프로모션 텍스트 170자)와
> **광고 문구** 때문 — Play 영문 설명에는 "includes a banner ad"가 있는데
> iOS 빌드에는 광고가 없다(`capacitor.config.json`의 `ios.includePlugins: []`).

---

## 앱 이름 (최대 30자)

```
GachaBab - Korea Food Picker
```

28자. Play 영문 이름과 통일(`store-listing-en.md`). `Korea`를 제목에 둔 이유는
ASO와 **오설치 방지**를 한자리에서 해결하기 때문 — 카카오맵 데이터라 한국 밖에서는
검색 결과가 0이다.

## 부제목 (최대 30자)

```
Where to eat? Spin a capsule
```

28자. 이름 다음으로 색인 가중치가 높은 자리라 실제 검색구 `where to eat`를 여기서 잡는다.
`Korea`/`Food`/`Picker`는 이름에 이미 있으므로 반복하지 않는다.

## 키워드 (최대 100자, 쉼표 구분·공백 없이)

```
restaurant,lunch,dinner,random,roulette,nearby,seoul,busan,jeju,travel,hungry,decide,meetup,midpoint
```

정확히 100자. 한 글자도 여유가 없으니 콘솔이 거부하면 `jeju,`를 빼면 95자가 된다.
이름·부제목에 있는 단어(GachaBab/Korea/Food/Picker/where/eat/spin/capsule)는
**일부러 뺐다** — Apple은 이름+부제목+키워드를 합쳐 색인하므로 중복은 자리만 먹는다.
`delivery`, `takeout`처럼 **없는 기능을 암시하는 단어는 넣지 않는다**.

## 프로모션 텍스트 (최대 170자)

```
Not sure where to eat in Korea? GachaBab loads real restaurants around you into a capsule machine. One turn of the knob and lunch is decided. It finds meeting spots too.
```

169자. 심사 없이 언제든 바꿀 수 있는 유일한 필드.

## 설명 (최대 4000자)

```
Where should I eat? Let one capsule decide.

GachaBab pulls up real restaurants around you and drops them into a capsule machine. Turn the knob, pop the capsule open, and today's place is decided. The ten minutes you spend deciding become ten seconds.

■ For South Korea
GachaBab runs on Kakao Map data, so it finds places while you are in Korea. Heading to Seoul, Busan or Jeju? Install it now and it's ready the moment you land. Already living here? It works in your own neighborhood every lunch break. Outside Korea there is nothing nearby to draw from, so save it for the trip.

■ How it works
1. Pick a radius (500m to 5km) and a food type.
2. Tap "Find restaurants nearby" and the machine fills with capsules.
3. Turn the knob, tap the capsule, and today's restaurant pops out.

■ What's inside
· Real places nearby — restaurants pulled live from Kakao Map data
· Radius — 500m / 1km / 2km / 3km / 5km
· Categories — Korean, Chinese, Japanese, Western, Snacks, Cafe and more
· Rarity grades — the rarer a kind of place is around you, the higher the capsule grade. The one-of-a-kind spot outranks the fifth kimbap shop.
· Kakao Map link and directions for every result
· Favorites — keep the ones you liked and open them again anytime
· Not this one — a place you exclude never comes back
· No repeats — a restaurant you already drew won't show up again until you have seen everything nearby
· Meet in the middle — add everyone's location and GachaBab finds a subway station in between, then draws a restaurant near it
· History — every place you drew stacks up like a collection
· Share — send today's pick straight to a friend

■ Who it's for
· Anyone tired of hearing "anywhere is fine"
· Travelers in Korea who don't know what's good on this street
· Residents who keep ending up at the same three places
· Friends coming from different stations who need a fair place to meet

■ Good to know
· Free, with no sign-up and no in-app purchases
· Your location is used only to search for nearby restaurants and is never stored on our servers
· Favorites and history stay on your device
· Available in English and Korean
· Restaurant data comes from Kakao Map, so opening hours and closures may differ from what you find in person
· Restaurant search covers South Korea only

Leave today's meal to the capsule.
```

약 2,200자.

> **퀴즈는 영문 설명에 넣지 않는다.** `showQuizBtn()`이 `LANG !== "ko"` 일 때 버튼을 숨겨서
> ([index.html:1239](index.html)) 영어 사용자는 퀴즈에 닿을 수가 없다. 없는 기능을 광고하는 셈이라
> Play 영문판에서도 같은 이유로 뺐다(커밋 `9ac9125`). 스크린샷도 마찬가지 — 아래 참고.

> **"No ads"는 쓰지 않는다**(한국어판과 같은 방침). iOS 빌드에 지금 광고가 없는 건 사실이지만
> AdMob 계정이 풀리면 붙일 계획이라, 등록정보에 없다고 약속하면 나중에 그 약속을 깨게 된다.
> 심사 메모(App Review Information)에 적는 "no ads"는 이 빌드의 사실을 심사자에게 알리는
> 것이라 별개이고 그대로 유지한다.

## 이 버전에서 업그레이드된 사항 (1.0.1)

```
- Tapping the empty area on the result screen now returns you to the start.
- Minor fixes and improvements.
```

## 스크린샷

영문 로케일에는 **4장**을 넣는다 — `ios-screenshot-en-` 의 `1-ready`, `2-result`, `3-dex`, `4-meet`.
1320×2868이라 6.9인치 슬롯이다. 1.0.1 버전을 만들 때 한국어 스크린샷이 그대로 복사돼 들어가므로
**"모두 삭제" 후 영문판으로 교체**해야 한다. `npm run shots`가 한국어·영문을 한 번에 뽑는다.

**`ios-screenshot-en-5-quiz.png`는 올리지 않는다.** 한국어 로케일에는 퀴즈 스크린샷이 들어가
있지만 영어 모드에서는 퀴즈 버튼 자체가 안 뜬다(위 설명 항목의 근거와 동일).
설치한 사람이 화면에서 못 찾는 스크린샷은 별점 손해로 돌아온다.

### 영문 캡션 (이미지에 이미 새겨져 있음)

1. "Where should I eat? Let the capsule decide"
2. "Real restaurants near you, loaded as capsules"
3. "The rarer the place, the higher the grade"
4. "Meeting a friend? It finds a spot in between"

## 로케일별로 나뉘지 않는 항목 (한 번만 입력)

지원 URL·마케팅 URL·개인정보처리방침 URL·카테고리·연령 등급·가격·저작권은
`store-listing-ios.md`의 "그 밖의 입력 항목" 표를 그대로 쓴다. 언어마다 다시 넣지 않아도 된다.

## 배포 국가

영문 등록정보를 만들었다고 전 세계로 열면 안 된다. **한국에 올 일이 없는 사람에게는
작동하지 않는 앱**이라 설치당 별점 손해만 난다. Play와 같은 기준으로 간다 —
1차는 영어권(미국·캐나다·영국·호주·뉴질랜드·싱가포르·필리핀·말레이시아),
일본·대만·홍콩은 현지어 등록정보를 만든 뒤. 자세한 근거는 `store-listing-en.md` 참고.

**iOS는 Play와 달리 `en-US` 하나만 만들면 영어권 전체가 그것을 본다**(Play처럼
en-GB/en-AU를 따로 만들 필요가 없다). 영어 변형 5개를 채우라는
`store-listing-en.md`의 지침은 Play 한정이다.
