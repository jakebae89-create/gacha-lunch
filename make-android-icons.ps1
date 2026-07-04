# 가챠밥 — 안드로이드 런처 아이콘 생성기 (레거시 + 적응형)
# res/mipmap-*/ic_launcher.png, ic_launcher_round.png, ic_launcher_foreground.png 를
# 캡슐 가챠 디자인으로 재생성. 배경색(ic_launcher_background)은 브랜드 레드로 설정.
# 실행: 이 폴더에서  powershell -ExecutionPolicy Bypass -File make-android-icons.ps1
Add-Type -AssemblyName System.Drawing

function Draw-Capsule {
  param($g, [double]$cx, [double]$cy, [double]$r)

  # 캡슐 그림자
  for ($i = 4; $i -ge 1; $i--) {
    $sw = $r * (2.0 + $i * 0.10)
    $sh = $r * (0.42 + $i * 0.05)
    $a  = [int](16 - $i * 2)
    $shBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb($a, 90, 30, 24))
    $g.FillEllipse($shBrush, [single]($cx - $sw/2), [single]($cy + $r*0.74), [single]$sw, [single]$sh)
    $shBrush.Dispose()
  }

  $capRect = New-Object System.Drawing.RectangleF([single]($cx-$r), [single]($cy-$r), [single]($r*2), [single]($r*2))

  # 하단 흰 베이스
  $whiteBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 255, 250, 242))
  $g.FillEllipse($whiteBrush, $capRect)
  $whiteBrush.Dispose()

  # 상단 노란 돔 (위쪽 반원)
  $domeTop = [System.Drawing.Color]::FromArgb(255, 255, 226, 122)
  $domeBot = [System.Drawing.Color]::FromArgb(255, 255, 198, 64)
  $domeBrush = New-Object System.Drawing.Drawing2D.LinearGradientBrush($capRect, $domeTop, $domeBot, [single]90)
  $g.FillPie($domeBrush, [single]($cx-$r), [single]($cy-$r), [single]($r*2), [single]($r*2), [single]180, [single]180)
  $domeBrush.Dispose()

  # 가운데 이음새 + 하이라이트
  $seamH = [single]($r * 0.155)
  $seamBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(46, 60, 40, 36))
  $g.FillRectangle($seamBrush, [single]($cx-$r), [single]($cy - $seamH/2), [single]($r*2), [single]$seamH)
  $seamBrush.Dispose()
  $hlPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(150, 255, 255, 255), [single]([Math]::Max(1, $r*0.02)))
  $g.DrawLine($hlPen, [single]($cx-$r*0.9), [single]($cy - $seamH*0.55), [single]($cx+$r*0.9), [single]($cy - $seamH*0.55))
  $hlPen.Dispose()

  # 외곽 테두리
  $edgePen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(40, 120, 60, 40), [single]([Math]::Max(1, $r*0.014)))
  $g.DrawEllipse($edgePen, $capRect)
  $edgePen.Dispose()

  # 광택
  $glossRect = New-Object System.Drawing.RectangleF([single]($cx - $r*0.55), [single]($cy - $r*0.78), [single]($r*0.85), [single]($r*0.5))
  $glossPath = New-Object System.Drawing.Drawing2D.GraphicsPath
  $glossPath.AddEllipse($glossRect)
  $glossBrush = New-Object System.Drawing.Drawing2D.PathGradientBrush($glossPath)
  $glossBrush.CenterColor = [System.Drawing.Color]::FromArgb(200, 255, 255, 255)
  $glossBrush.SurroundColors = @([System.Drawing.Color]::FromArgb(0, 255, 255, 255))
  $g.FillPath($glossBrush, $glossPath)
  $glossBrush.Dispose(); $glossPath.Dispose()

  # 반짝임 (우상단)
  $sx = $cx + $r * 0.74; $sy = $cy - $r * 0.62
  $sl = $r * 0.29; $sw = $sl * 0.22
  $spBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(235, 255, 255, 255))
  $g.FillEllipse($spBrush, [single]($sx - $sw/2), [single]($sy - $sl/2), [single]$sw, [single]$sl)
  $g.FillEllipse($spBrush, [single]($sx - $sl/2), [single]($sy - $sw/2), [single]$sl, [single]$sw)
  $spBrush.Dispose()
}

function Draw-Background {
  param($g, [int]$S)
  $bgRect = New-Object System.Drawing.Rectangle(0, 0, $S, $S)
  $cTop = [System.Drawing.Color]::FromArgb(255, 255, 138, 126)
  $cBot = [System.Drawing.Color]::FromArgb(255, 232, 80, 63)
  $bgBrush = New-Object System.Drawing.Drawing2D.LinearGradientBrush($bgRect, $cTop, $cBot, [single]90)
  $g.FillRectangle($bgBrush, $bgRect); $bgBrush.Dispose()
  $glowRect = New-Object System.Drawing.RectangleF([single](-$S*0.2), [single](-$S*0.35), [single]($S*1.4), [single]($S*0.9))
  $glowPath = New-Object System.Drawing.Drawing2D.GraphicsPath
  $glowPath.AddEllipse($glowRect)
  $glowBrush = New-Object System.Drawing.Drawing2D.PathGradientBrush($glowPath)
  $glowBrush.CenterColor = [System.Drawing.Color]::FromArgb(70, 255, 255, 255)
  $glowBrush.SurroundColors = @([System.Drawing.Color]::FromArgb(0, 255, 255, 255))
  $g.FillPath($glowBrush, $glowPath); $glowBrush.Dispose(); $glowPath.Dispose()
}

function New-Graphics($bmp) {
  $g = [System.Drawing.Graphics]::FromImage($bmp)
  $g.SmoothingMode     = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
  $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
  $g.PixelOffsetMode   = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
  return $g
}

# 레거시 아이콘 (전면 채움 사각 또는 원형)
function New-Legacy {
  param([int]$S, [string]$Path, [bool]$Round)
  $bmp = New-Object System.Drawing.Bitmap($S, $S)
  $g = New-Graphics $bmp
  if ($Round) {
    $clip = New-Object System.Drawing.Drawing2D.GraphicsPath
    $clip.AddEllipse(0, 0, $S, $S)
    $g.SetClip($clip)
    $clip.Dispose()
  }
  Draw-Background $g $S
  Draw-Capsule $g ($S/2.0) ($S*0.52) ($S*0.29)
  $g.Dispose()
  $bmp.Save($Path, [System.Drawing.Imaging.ImageFormat]::Png)
  $bmp.Dispose()
}

# 적응형 포그라운드 (투명 배경 + 캡슐만, 안전영역 안에)
function New-Foreground {
  param([int]$S, [string]$Path)
  $bmp = New-Object System.Drawing.Bitmap($S, $S)
  $g = New-Graphics $bmp
  Draw-Capsule $g ($S/2.0) ($S*0.5) ($S*0.24)
  $g.Dispose()
  $bmp.Save($Path, [System.Drawing.Imaging.ImageFormat]::Png)
  $bmp.Dispose()
}

$res = Join-Path $PSScriptRoot "android\app\src\main\res"
$legacy = @{ "mdpi"=48; "hdpi"=72; "xhdpi"=96; "xxhdpi"=144; "xxxhdpi"=192 }
$fg     = @{ "mdpi"=108; "hdpi"=162; "xhdpi"=216; "xxhdpi"=324; "xxxhdpi"=432 }

foreach ($d in $legacy.Keys) {
  $dir = Join-Path $res ("mipmap-" + $d)
  New-Legacy $legacy[$d] (Join-Path $dir "ic_launcher.png") $false
  New-Legacy $legacy[$d] (Join-Path $dir "ic_launcher_round.png") $true
  New-Foreground $fg[$d] (Join-Path $dir "ic_launcher_foreground.png")
  Write-Output ("done " + $d)
}

# 적응형 배경색을 브랜드 레드로
$bgXml = Join-Path $res "values\ic_launcher_background.xml"
@'
<?xml version="1.0" encoding="utf-8"?>
<resources>
    <color name="ic_launcher_background">#E8503F</color>
</resources>
'@ | Set-Content -Path $bgXml -Encoding UTF8
Write-Output "background color -> #E8503F"
Write-Output "ALL DONE"

