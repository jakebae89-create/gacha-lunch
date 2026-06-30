# 가챠밥 — AdMob 광고 + 플레이스토어 빌드 가이드

이 앱은 이제 **Capacitor**로 감싸져 있고, **AdMob 배너 광고**가 붙어 있습니다.
- 웹(GitHub Pages)으로 열면: 광고 없이 그대로 동작
- 안드로이드 앱(플레이스토어)으로 빌드하면: 화면 하단에 배너 광고 표시

> 지금 상태는 **구글 "테스트 광고"** 로 설정돼 있습니다. 그대로 빌드하면 테스트 배너가 뜨고,
> 실제 수익이 나려면 아래 **3단계(실제 ID 교체)** 를 반드시 해야 합니다.

---

## 0. 한 번만 준비: Android Studio 설치

`.aab`(플레이스토어 업로드 파일)를 만들려면 **Android Studio**가 필요합니다(JDK + 안드로이드 SDK 포함).

1. <https://developer.android.com/studio> 에서 다운로드 → 설치
2. 처음 실행 시 안내(SDK 설치)를 그대로 "다음"으로 진행
3. 설치 후 한 번 닫았다가 다시 켜도 됩니다

> Node.js는 이미 설치돼 있습니다. (확인: 터미널에서 `node -v`)

---

## 1. 평소 개발 흐름 (코드 수정 시)

`index.html` 등 웹 파일을 고치면, 아래 한 줄로 앱에 반영합니다.

```powershell
cd "C:\Users\vegita\Desktop\gacha-lunch"
npm run sync
```

- `npm run sync` = 웹 파일을 `www/`로 복사 + 안드로이드 프로젝트에 동기화
- 그 다음 Android Studio에서 다시 빌드/실행하면 됩니다

---

## 2. Android Studio로 열기 / 실제 기기·에뮬레이터에서 테스트

```powershell
cd "C:\Users\vegita\Desktop\gacha-lunch"
npm run open:android
```

또는 Android Studio에서 **Open** → `C:\Users\vegita\Desktop\gacha-lunch\android` 폴더 선택.

- 처음 열면 Gradle이 자동으로 의존성을 내려받습니다(몇 분 소요).
- 상단 ▶(Run) 버튼으로 에뮬레이터/USB 연결 폰에서 실행해 광고가 뜨는지 확인하세요.
- 이 단계에서는 **테스트 광고**가 떠야 정상입니다. (실제 광고를 미리 클릭하면 계정 정지 위험!)

---

## 3. ⭐ 실제 AdMob ID로 교체 (출시 전 필수)

### 3-1. AdMob 계정 & 광고 단위 만들기
1. <https://admob.google.com> 접속 → 로그인 → **앱 추가**
   - 플랫폼: Android
   - "앱이 스토어에 등록되어 있나요?" → 아직이면 "아니요"로 생성 가능
2. 만든 앱의 **앱 ID** 확인: `ca-app-pub-XXXXXXXXXXXXXXXX~YYYYYYYYYY` (물결표 `~`)
3. **광고 단위 만들기 → 배너** 선택 → **광고 단위 ID** 확인: `ca-app-pub-XXXX/ZZZZ` (슬래시 `/`)

> 앱 ID와 광고 단위 ID는 **다른 값**입니다. (앱 ID엔 `~`, 광고 단위엔 `/`)

### 3-2. 코드에서 3곳 교체

**① 앱 ID** — `android\app\src\main\AndroidManifest.xml`
```xml
<meta-data
    android:name="com.google.android.gms.ads.APPLICATION_ID"
    android:value="여기에_실제_앱_ID(ca-app-pub-...~...)" />
```

**② 배너 광고 단위 ID + ③ 테스트 끄기** — `index.html` (파일 위쪽 검색: `BANNER_AD_ID`)
```js
const BANNER_AD_ID = "여기에_실제_배너_광고단위_ID(ca-app-pub-.../...)";
const USE_TEST_ADS = false;   // 출시 시 반드시 false
```

교체 후 다시:
```powershell
npm run sync
```

> ⚠️ `USE_TEST_ADS = false`로 바꾼 뒤에는 **본인이 실제 광고를 클릭하지 마세요.** 무효 트래픽으로 계정이 정지될 수 있습니다.

---

## 4. 서명 키(keystore) 만들기 — 최초 1회

플레이스토어 앱은 서명이 필요합니다. **키와 비밀번호는 분실하면 앱 업데이트가 불가능**하니 꼭 백업하세요.

Android Studio에서:
1. 상단 메뉴 **Build → Generate Signed App Bundle / APK**
2. **Android App Bundle** 선택 → Next
3. **Create new...** 로 키스토어 생성
   - Key store path: 안전한 위치(예: `C:\Users\vegita\Desktop\gacha-lunch\release.keystore`)
   - 비밀번호, 별칭(alias), 별칭 비밀번호 입력 → **메모해서 보관**
4. 생성한 키 선택 → Next

> 키스토어 파일(`*.keystore`)과 비밀번호는 `.gitignore`에 의해 git에 올라가지 않습니다. 별도로 안전하게 보관하세요.

---

## 5. .aab 빌드

1. (4단계에 이어) build variant: **release** 선택 → **Create / Finish**
2. 완료되면 알림의 **locate** 클릭, 또는:
   `android\app\release\app-release.aab`
3. 이 `.aab` 파일을 플레이 콘솔에 업로드합니다.

> 명령줄 선호 시(키 설정 후): `cd android` 후 `.\gradlew bundleRelease`

---

## 6. 플레이 콘솔 설정 (광고 관련 변경점)

기존 출시 자료(`PUBLISH-GUIDE.md`, `store-listing-ko.md`)와 함께 진행하되, **광고 때문에 달라지는 부분**:

- **앱에 광고 포함**: **"예"** 로 설정 (이전 가이드엔 "없음"으로 적혀 있음 — 변경 필요)
- **데이터 보안(Data safety)**: AdMob이 광고 식별자를 사용하므로
  - "기기 또는 기타 ID **수집**" → 예
  - 목적: "광고 또는 마케팅"
  - 암호화 전송: 예
- **타겟 광고/동의**: 유럽 사용자 대상이면 AdMob의 **UMP 동의 메시지** 설정 권장
  (AdMob 콘솔 → 개인정보 보호 및 메시지 → GDPR 메시지 생성)
- **콘텐츠 등급**: 광고 포함 여부 질문에 "예"로 응답

> TWA(이전 방식)에서 쓰던 `.well-known/assetlinks.json`은 **Capacitor 앱에는 필요 없습니다.** (TWA 도메인 검증용이었음)

---

## 요약 체크리스트

- [ ] Android Studio 설치 완료
- [ ] `npm run sync` 로 www/ 동기화
- [ ] 에뮬레이터/폰에서 **테스트 광고** 표시 확인
- [ ] AdMob 앱 ID → AndroidManifest.xml 교체
- [ ] 배너 광고 단위 ID → index.html 교체 + `USE_TEST_ADS = false`
- [ ] `npm run sync` 다시 실행
- [ ] 서명 키 생성 + 비밀번호 백업
- [ ] release `.aab` 빌드
- [ ] 플레이 콘솔: 광고 "있음" + 데이터 보안(광고 ID) 갱신
