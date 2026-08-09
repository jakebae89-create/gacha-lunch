# 가챠밥 — iOS 런치스크린(스플래시) 생성기
# Capacitor 기본 스플래시는 캡시터 로고라, 앱을 켜면 남의 로고가 먼저 뜬다. 그걸 교체한다.
# 아이콘(make-icons.ps1)과 같은 색·같은 캡슐을 쓰되 캡슐만 작게 중앙에 놓는다.
# 재생성: powershell -ExecutionPolicy Bypass -File make-ios-splash.ps1
Add-Type -AssemblyName System.Drawing

function New-Splash {
  param([int]$S, [string]$Path)

  # 알파 채널 없이(24bpp) — 런치스크린은 투명할 이유가 없다
  $bmp = New-Object System.Drawing.Bitmap($S, $S, [System.Drawing.Imaging.PixelFormat]::Format24bppRgb)
  $g   = [System.Drawing.Graphics]::FromImage($bmp)
  $g.SmoothingMode     = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
  $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
  $g.PixelOffsetMode   = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality

  # ── 배경: 아이콘과 같은 빨간 세로 그라데이션 ──
  $bgRect  = New-Object System.Drawing.Rectangle(0, 0, $S, $S)
  $cTop    = [System.Drawing.Color]::FromArgb(255, 255, 138, 126)   # #ff8a7e
  $cBot    = [System.Drawing.Color]::FromArgb(255, 232, 80, 63)     # #e8503f
  $bgBrush = New-Object System.Drawing.Drawing2D.LinearGradientBrush($bgRect, $cTop, $cBot, [single]90)
  $g.FillRectangle($bgBrush, $bgRect)
  $bgBrush.Dispose()

  $cx = $S / 2.0
  $cy = $S / 2.0
  $r  = $S * 0.13      # 아이콘(0.29)보다 작게 — 스플래시는 여백이 넓어야 안정적으로 보인다

  # ── 캡슐 그림자 ──
  for ($i = 4; $i -ge 1; $i--) {
    $sw = $r * (2.0 + $i * 0.10)
    $sh = $r * (0.42 + $i * 0.05)
    $a  = [int](16 - $i * 2)
    $shBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb($a, 90, 30, 24))
    $g.FillEllipse($shBrush, [single]($cx - $sw/2), [single]($cy + $r*0.74), [single]$sw, [single]$sh)
    $shBrush.Dispose()
  }

  $capRect = New-Object System.Drawing.RectangleF([single]($cx-$r), [single]($cy-$r), [single]($r*2), [single]($r*2))

  # ── 하단 흰색 베이스 ──
  $whiteBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 255, 250, 242))
  $g.FillEllipse($whiteBrush, $capRect)
  $whiteBrush.Dispose()

  # ── 상단 노란 돔 ──
  $domeTop   = [System.Drawing.Color]::FromArgb(255, 255, 226, 122)
  $domeBot   = [System.Drawing.Color]::FromArgb(255, 255, 198, 64)
  $domeBrush = New-Object System.Drawing.Drawing2D.LinearGradientBrush($capRect, $domeTop, $domeBot, [single]90)
  $g.FillPie($domeBrush, [single]($cx-$r), [single]($cy-$r), [single]($r*2), [single]($r*2), [single]180, [single]180)
  $domeBrush.Dispose()

  # ── 이음새 ──
  $seamH = [single]($r * 0.155)
  $seamBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(46, 60, 40, 36))
  $g.FillRectangle($seamBrush, [single]($cx-$r), [single]($cy - $seamH/2), [single]($r*2), [single]$seamH)
  $seamBrush.Dispose()
  $hlPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(150, 255, 255, 255), [single]([Math]::Max(1, $r*0.02)))
  $g.DrawLine($hlPen, [single]($cx-$r*0.9), [single]($cy - $seamH*0.55), [single]($cx+$r*0.9), [single]($cy - $seamH*0.55))
  $hlPen.Dispose()

  # ── 외곽선 ──
  $edgePen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(40, 120, 60, 40), [single]([Math]::Max(1, $r*0.014)))
  $g.DrawEllipse($edgePen, $capRect)
  $edgePen.Dispose()

  # ── 광택 ──
  $glossRect  = New-Object System.Drawing.RectangleF([single]($cx - $r*0.55), [single]($cy - $r*0.78), [single]($r*0.85), [single]($r*0.5))
  $glossPath  = New-Object System.Drawing.Drawing2D.GraphicsPath
  $glossPath.AddEllipse($glossRect)
  $glossBrush = New-Object System.Drawing.Drawing2D.PathGradientBrush($glossPath)
  $glossBrush.CenterColor    = [System.Drawing.Color]::FromArgb(200, 255, 255, 255)
  $glossBrush.SurroundColors = @([System.Drawing.Color]::FromArgb(0, 255, 255, 255))
  $g.FillPath($glossBrush, $glossPath)
  $glossBrush.Dispose(); $glossPath.Dispose()

  # ── 반짝임 ──
  $sx = $cx + $r * 0.74; $sy = $cy - $r * 0.62; $sl = $r * 0.29; $sw = $sl * 0.22
  $spBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(235, 255, 255, 255))
  $g.FillEllipse($spBrush, [single]($sx - $sw/2), [single]($sy - $sl/2), [single]$sw, [single]$sl)
  $g.FillEllipse($spBrush, [single]($sx - $sl/2), [single]($sy - $sw/2), [single]$sl, [single]$sw)
  $spBrush.Dispose()

  $g.Dispose()
  $bmp.Save($Path, [System.Drawing.Imaging.ImageFormat]::Png)
  $bmp.Dispose()
  Write-Host "saved $Path ($S x $S)"
}

$dir = Split-Path -Parent $MyInvocation.MyCommand.Path
$set = Join-Path $dir "ios\App\App\Assets.xcassets\Splash.imageset"
if (-not (Test-Path $set)) { Write-Host "ios/ 프로젝트가 없습니다. 먼저 npx cap add ios"; exit 1 }

# 세 파일 모두 같은 2732 이미지(1x/2x/3x 슬롯). LaunchScreen.storyboard가 화면에 맞춰 채운다.
foreach ($f in @("splash-2732x2732.png", "splash-2732x2732-1.png", "splash-2732x2732-2.png")) {
  New-Splash 2732 (Join-Path $set $f)
}
Write-Host "done."
