# 가챠 점심 — 앱 아이콘 생성기 (캡슐 가챠 컨셉)
# System.Drawing(GDI+)으로 192/512/180 PNG를 그려 저장. 설치 불필요(Windows 내장).
# 재생성: 이 폴더에서  powershell -ExecutionPolicy Bypass -File make-icons.ps1
Add-Type -AssemblyName System.Drawing

function New-Icon {
  param([int]$S, [string]$Path)

  $bmp = New-Object System.Drawing.Bitmap($S, $S)
  $g   = [System.Drawing.Graphics]::FromImage($bmp)
  $g.SmoothingMode     = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
  $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
  $g.PixelOffsetMode   = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality

  # ── 배경: 빨간 세로 그라데이션 (전면 채움 → maskable/apple 모두 안전) ──
  $bgRect = New-Object System.Drawing.Rectangle(0, 0, $S, $S)
  $cTop = [System.Drawing.Color]::FromArgb(255, 255, 138, 126)   # #ff8a7e
  $cBot = [System.Drawing.Color]::FromArgb(255, 232, 80, 63)     # #e8503f
  $bgBrush = New-Object System.Drawing.Drawing2D.LinearGradientBrush($bgRect, $cTop, $cBot, [single]90)
  $g.FillRectangle($bgBrush, $bgRect)
  $bgBrush.Dispose()

  # 상단 코너 부드러운 화이트 글로우
  $glowRect = New-Object System.Drawing.RectangleF([single](-$S*0.2), [single](-$S*0.35), [single]($S*1.4), [single]($S*0.9))
  $glowPath = New-Object System.Drawing.Drawing2D.GraphicsPath
  $glowPath.AddEllipse($glowRect)
  $glowBrush = New-Object System.Drawing.Drawing2D.PathGradientBrush($glowPath)
  $glowBrush.CenterColor = [System.Drawing.Color]::FromArgb(70, 255, 255, 255)
  $glowBrush.SurroundColors = @([System.Drawing.Color]::FromArgb(0, 255, 255, 255))
  $g.FillPath($glowBrush, $glowPath)
  $glowBrush.Dispose(); $glowPath.Dispose()

  $cx = $S / 2.0
  $cy = $S * 0.52
  $r  = $S * 0.29       # 캡슐 반지름

  # ── 캡슐 그림자 (블러 흉내: 반투명 타원 여러 겹) ──
  for ($i = 4; $i -ge 1; $i--) {
    $sw = $r * (2.0 + $i * 0.10)
    $sh = $r * (0.42 + $i * 0.05)
    $a  = [int](16 - $i * 2)
    $shBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb($a, 90, 30, 24))
    $g.FillEllipse($shBrush, [single]($cx - $sw/2), [single]($cy + $r*0.74), [single]$sw, [single]$sh)
    $shBrush.Dispose()
  }

  $capRect = New-Object System.Drawing.RectangleF([single]($cx-$r), [single]($cy-$r), [single]($r*2), [single]($r*2))

  # ── 하단(흰색 베이스) 원 전체 ──
  $whiteBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(255, 255, 250, 242))
  $g.FillEllipse($whiteBrush, $capRect)
  $whiteBrush.Dispose()

  # ── 상단(노란 돔) 반원: FillPie(180,180) = 위쪽 절반 ──
  $domeRect = New-Object System.Drawing.RectangleF([single]($cx-$r), [single]($cy-$r), [single]($r*2), [single]($r*2))
  $domeTop = [System.Drawing.Color]::FromArgb(255, 255, 226, 122)   # #ffe27a
  $domeBot = [System.Drawing.Color]::FromArgb(255, 255, 198, 64)    # #ffc640
  $domeBrush = New-Object System.Drawing.Drawing2D.LinearGradientBrush($domeRect, $domeTop, $domeBot, [single]90)
  $g.FillPie($domeBrush, [single]($cx-$r), [single]($cy-$r), [single]($r*2), [single]($r*2), [single]180, [single]180)
  $domeBrush.Dispose()

  # ── 가운데 이음새(seam): 살짝 어두운 밴드 + 하이라이트 라인 ──
  $seamH = [single]($S * 0.045)
  $seamBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(46, 60, 40, 36))
  $g.FillRectangle($seamBrush, [single]($cx-$r), [single]($cy - $seamH/2), [single]($r*2), [single]$seamH)
  $seamBrush.Dispose()
  $hlPen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(150, 255, 255, 255), [single]([Math]::Max(1, $S*0.006)))
  $g.DrawLine($hlPen, [single]($cx-$r*0.9), [single]($cy - $seamH*0.55), [single]($cx+$r*0.9), [single]($cy - $seamH*0.55))
  $hlPen.Dispose()

  # ── 캡슐 외곽 얇은 테두리 ──
  $edgePen = New-Object System.Drawing.Pen([System.Drawing.Color]::FromArgb(40, 120, 60, 40), [single]([Math]::Max(1, $S*0.004)))
  $g.DrawEllipse($edgePen, $capRect)
  $edgePen.Dispose()

  # ── 광택(gloss): 좌상단 부드러운 흰 타원 ──
  $glossRect = New-Object System.Drawing.RectangleF([single]($cx - $r*0.55), [single]($cy - $r*0.78), [single]($r*0.85), [single]($r*0.5))
  $glossPath = New-Object System.Drawing.Drawing2D.GraphicsPath
  $glossPath.AddEllipse($glossRect)
  $glossBrush = New-Object System.Drawing.Drawing2D.PathGradientBrush($glossPath)
  $glossBrush.CenterColor = [System.Drawing.Color]::FromArgb(200, 255, 255, 255)
  $glossBrush.SurroundColors = @([System.Drawing.Color]::FromArgb(0, 255, 255, 255))
  $g.FillPath($glossBrush, $glossPath)
  $glossBrush.Dispose(); $glossPath.Dispose()

  # ── 반짝임(sparkle): 우상단 4점 별 ──
  $sx = $cx + $r * 0.74
  $sy = $cy - $r * 0.62
  $sl = $S * 0.085
  $sw = $sl * 0.22
  $spBrush = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(235, 255, 255, 255))
  $g.FillEllipse($spBrush, [single]($sx - $sw/2), [single]($sy - $sl/2), [single]$sw, [single]$sl)   # 세로
  $g.FillEllipse($spBrush, [single]($sx - $sl/2), [single]($sy - $sw/2), [single]$sl, [single]$sw)   # 가로
  $spBrush.Dispose()
  # 작은 보조 반짝임
  $sx2 = $cx - $r * 0.86; $sy2 = $cy + $r * 0.18; $sl2 = $S * 0.05; $sw2 = $sl2 * 0.22
  $spBrush2 = New-Object System.Drawing.SolidBrush([System.Drawing.Color]::FromArgb(200, 255, 255, 255))
  $g.FillEllipse($spBrush2, [single]($sx2 - $sw2/2), [single]($sy2 - $sl2/2), [single]$sw2, [single]$sl2)
  $g.FillEllipse($spBrush2, [single]($sx2 - $sl2/2), [single]($sy2 - $sw2/2), [single]$sl2, [single]$sw2)
  $spBrush2.Dispose()

  $g.Dispose()
  $bmp.Save($Path, [System.Drawing.Imaging.ImageFormat]::Png)
  $bmp.Dispose()
  Write-Host "saved $Path ($S x $S)"
}

$dir = Split-Path -Parent $MyInvocation.MyCommand.Path
New-Icon 512 (Join-Path $dir "icon-512.png")
New-Icon 192 (Join-Path $dir "icon-192.png")
New-Icon 180 (Join-Path $dir "apple-touch-icon-180.png")
Write-Host "done."
