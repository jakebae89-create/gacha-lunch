# Add project specific ProGuard rules here.
# You can control the set of applied configuration files using the
# proguardFiles setting in build.gradle.
#
# For more details, see
#   http://developer.android.com/guide/developing/tools/proguard.html

# If your project uses WebView with JS, uncomment the following
# and specify the fully qualified class name to the JavaScript interface
# class:
#-keepclassmembers class fqcn.of.javascript.interface.for.webview {
#   public *;
#}

# Uncomment this to preserve the line number information for
# debugging stack traces.
#-keepattributes SourceFile,LineNumberTable

# If you keep the line number information, uncomment this to
# hide the original source file name.
#-renamesourcefileattribute SourceFile

# ============================================================
# 가챠밥 — minifyEnabled true 로 켠 뒤 필요한 유지 규칙
# Capacitor는 플러그인을 애노테이션·리플렉션으로 찾기 때문에
# 이름이 바뀌거나 제거되면 런타임에 플러그인이 통째로 사라진다.
# ============================================================
-keepattributes *Annotation*, JavascriptInterface
-keepattributes Signature, InnerClasses, EnclosingMethod

# Capacitor 코어와 플러그인
-keep class com.getcapacitor.** { *; }
-keep @com.getcapacitor.annotation.CapacitorPlugin class * { *; }
-keep class * extends com.getcapacitor.Plugin { *; }
-keepclassmembers class * {
    @com.getcapacitor.PluginMethod public *;
}

# WebView ↔ 네이티브 브리지
-keepclassmembers class * {
    @android.webkit.JavascriptInterface <methods>;
}

# AdMob 플러그인과 Google Mobile Ads SDK
-keep class com.getcapacitor.community.admob.** { *; }
-keep class com.google.android.gms.ads.** { *; }
-dontwarn com.google.android.gms.**

# Cordova 플러그인 브리지(capacitor-cordova-android-plugins)
-keep class org.apache.cordova.** { *; }

# 크래시 스택을 읽을 수 있게 줄 번호는 남기고 원본 파일명만 감춘다
-keepattributes SourceFile,LineNumberTable
-renamesourcefileattribute SourceFile

