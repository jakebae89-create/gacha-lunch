# 가챠밥 — 플레이스토어 피처 그래픽 생성기 (1024x500 PNG)
# System.Drawing(GDI+)으로 렌더. 설치 불필요(Windows 내장).
# 실행: 이 폴더에서  powershell -ExecutionPolicy Bypass -File make-feature-graphic.ps1
Add-Type -AssemblyName System.Drawing

$W = 1024; $H = 500
$bmp = New-Object System.Drawing.Bitmap($W, $H)
$g   = [System.Drawing.Graphics]::FromImage($bmp)
$g.SmoothingMode     = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
$g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
$g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::AntiAliasGridFit
$g.PixelOffsetMode   = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality

# ── 배경: 빨간 대각선 그라데이션 ──
$bgRect = New-Object System.Drawing.Rectangle(0, 0, $W, $H)
$cTop = [System.Drawing.Color]::FromArgb(255, 255, 122, 100)   # #ff7a64
$cBot = [System.Drawing.Color]::FromArgb(255, 214, 64, 48)     # #d64030
$bgBrush = New-Object System.Drawing.Drawing2D.LinearGradientBrush($bgRect, $cTop, $cBot, [single]60)
$g.FillRectangle($bgBrush, $bgRect); $bgBrush.Dispose()

# 은은한 도트 패턴(반투명 흰 원)
$rand = New-Object System.Random(7)
for ($i=0; $i -lt 40; $i++) {
  $dx = $rand.Next(0,$W); $dy = $rand.Next(0,$H); $ds = $rand.Next(4,14)
  $dotB = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(18,255,255,255))
  $g.FillEllipse($dotB, [single]$dx,[single]$dy,[single]$ds,[single]$ds); $dotB.Dispose()
}

# 상단 좌측 글로우
$glowPath = New-Object System.Drawing.Drawing2D.GraphicsPath
$glowPath.AddEllipse((New-Object System.Drawing.RectangleF([single](-200),[single](-260),[single]900,[single]640)))
$glowBrush = New-Object System.Drawing.Drawing2D.PathGradientBrush($glowPath)
$glowBrush.CenterColor = [System.Drawing.Color]::FromArgb(60,255,255,255)
$glowBrush.SurroundColors = @([System.Drawing.Color]::FromArgb(0,255,255,255))
$g.FillPath($glowBrush, $glowPath); $glowBrush.Dispose(); $glowPath.Dispose()

# ============ 오른쪽: 가챠 머신 ============
$mx = 800.0   # 머신 중심 X
$capColors = @(
  ([System.Drawing.Color]::FromArgb(255,255,209,102)),  # 노랑
  ([System.Drawing.Color]::FromArgb(255,120,200,255)),  # 파랑
  ([System.Drawing.Color]::FromArgb(255,150,230,160)),  # 초록
  ([System.Drawing.Color]::FromArgb(255,255,255,255)),  # 흰
  ([System.Drawing.Color]::FromArgb(255,255,150,200))   # 분홍
)

# 머신 그림자
$shB = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(50,120,20,10))
$g.FillEllipse($shB, [single]($mx-150),[single]445,[single]300,[single]46); $shB.Dispose()

# 머신 몸체 (둥근 사각형, 진빨강)
function Add-RoundRect($path,$x,$y,$w,$h,$r){
  $d=$r*2
  $path.AddArc([single]$x,[single]$y,[single]$d,[single]$d,180,90)
  $path.AddArc([single]($x+$w-$d),[single]$y,[single]$d,[single]$d,270,90)
  $path.AddArc([single]($x+$w-$d),[single]($y+$h-$d),[single]$d,[single]$d,0,90)
  $path.AddArc([single]$x,[single]($y+$h-$d),[single]$d,[single]$d,90,90)
  $path.CloseFigure()
}
$bodyPath = New-Object System.Drawing.Drawing2D.GraphicsPath
Add-RoundRect $bodyPath ($mx-115) 250 230 210 26
$bodyBrush = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
  (New-Object System.Drawing.Rectangle([int]($mx-115),250,230,210)),
  [System.Drawing.Color]::FromArgb(255,225,70,55),
  [System.Drawing.Color]::FromArgb(255,175,40,30),[single]90)
$g.FillPath($bodyBrush, $bodyPath); $bodyBrush.Dispose(); $bodyPath.Dispose()

# 유리 돔 (반투명 반원 + 캡슐들)
$domeRect = New-Object System.Drawing.Rectangle([int]($mx-120),110,240,240)
# 돔 배경(연한 하늘 유리)
$domeB = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(235,225,245,255))
$g.FillPie($domeB, $domeRect, 180, 180); $domeB.Dispose()
# 돔 안 캡슐들
$capData = @(@(-60,270),@(-8,255),@(48,272),@(-34,225),@(22,222),@(-2,196))
foreach($c in $capData){
  $ccx = $mx + $c[0]; $ccy = $c[1]; $cr = 30
  $col = $capColors[$rand.Next(0,$capColors.Length)]
  # 캡슐 하단(반투명 흰) + 상단(색)
  $capB = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255,245,245,245))
  $g.FillEllipse($capB,[single]($ccx-$cr/2),[single]($ccy-$cr/2),[single]$cr,[single]$cr); $capB.Dispose()
  $topB = New-Object System.Drawing.SolidBrush($col)
  $g.FillPie($topB,[int]($ccx-$cr/2),[int]($ccy-$cr/2),$cr,$cr,180,180); $topB.Dispose()
  $hl = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(150,255,255,255))
  $g.FillEllipse($hl,[single]($ccx-$cr/2+5),[single]($ccy-$cr/2+4),[single]7,[single]7); $hl.Dispose()
}
# 돔 테두리
$domePen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(255,255,255,255),[single]5)
$g.DrawArc($domePen,$domeRect,180,180); $domePen.Dispose()
# 돔 유리 반사광
$refl = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(90,255,255,255))
$g.FillEllipse($refl,[single]($mx-80),[single]140,[single]55,[single]90); $refl.Dispose()

# 배출구 (검은 슬롯)
$slotB = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255,60,20,15))
$g.FillRectangle($slotB,[single]($mx-45),[single]395,[single]90,[single]40); $slotB.Dispose()
# 손잡이 knob
$knobB = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255,255,209,102))
$g.FillEllipse($knobB,[single]($mx+55),[single]330,[single]46,[single]46); $knobB.Dispose()
$knobP = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(255,180,120,20),[single]5)
$g.DrawEllipse($knobP,[single]($mx+55),[single]330,[single]46,[single]46); $knobP.Dispose()

# 떨어진 당첨 캡슐(트레이 앞) — 노랑
$wc = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255,250,250,250))
$g.FillEllipse($wc,[single]($mx-30),[single]428,[single]52,[single]52); $wc.Dispose()
$wct = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255,255,200,90))
$g.FillPie($wct,[int]($mx-30),[int]428,52,52,180,180); $wct.Dispose()

# ============ 왼쪽: 타이틀 ============
$fontTitle = New-Object System.Drawing.Font("Malgun Gothic", 78, [System.Drawing.FontStyle]::Bold, [System.Drawing.GraphicsUnit]::Pixel)
$fontSub   = New-Object System.Drawing.Font("Malgun Gothic", 30, [System.Drawing.FontStyle]::Regular, [System.Drawing.GraphicsUnit]::Pixel)
$fontBadge = New-Object System.Drawing.Font("Malgun Gothic", 24, [System.Drawing.FontStyle]::Bold, [System.Drawing.GraphicsUnit]::Pixel)

# 타이틀 그림자
$shadowBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(70,80,0,0))
$g.DrawString("가챠밥", $fontTitle, $shadowBrush, [single]74, [single]154)
$whiteBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::White)
$g.DrawString("가챠밥", $fontTitle, $whiteBrush, [single]70, [single]150)

# 서브 타이틀
$g.DrawString("오늘 점심, 뽑아서 정하자!", $fontSub, $whiteBrush, [single]74, [single]256)

# 뱃지 "주변 맛집 랜덤 추첨"
$badgePath = New-Object System.Drawing.Drawing2D.GraphicsPath
Add-RoundRect $badgePath 74 312 330 52 26
$badgeBg = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255,255,209,102))
$g.FillPath($badgeBg, $badgePath); $badgeBg.Dispose(); $badgePath.Dispose()
$badgeText = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255,140,50,0))
$g.DrawString("주변 맛집 랜덤 추첨 · 무료", $fontBadge, $badgeText, [single]92, [single]324)
$badgeText.Dispose()

$shadowBrush.Dispose(); $whiteBrush.Dispose()
$fontTitle.Dispose(); $fontSub.Dispose(); $fontBadge.Dispose()

# 저장
$outPath = Join-Path $PSScriptRoot "store-assets\feature-graphic.png"
$null = New-Item -ItemType Directory -Force -Path (Split-Path $outPath)
$bmp.Save($outPath, [System.Drawing.Imaging.ImageFormat]::Png)
$g.Dispose(); $bmp.Dispose()
Write-Output "생성됨: $outPath ($W x $H)"

