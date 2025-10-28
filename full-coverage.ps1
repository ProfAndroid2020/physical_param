# full-coverage.ps1 - Run tests and show summary with smooth RGB gradient

function Get-CoverageColor {
    param([double]$Percent)
    
    # Нормализуем проценты от 0 до 1
    $normalized = [math]::Min([math]::Max($Percent / 100, 0), 1)
    
    # Зеленый (0,255,0) для 100%, Красный (255,0,0) для 0%
    $red = [int]((1 - $normalized) * 255)
    $green = [int]($normalized * 255)
    
    return @{Red = $red; Green = $green; Blue = 0 }
}

function Write-ColoredText {
    param([string]$Text, [int]$Red, [int]$Green, [int]$Blue)
    
    # Используем escape-последовательности для RGB цвета
    $esc = [char]27
    Write-Host "$esc[38;2;${Red};${Green};${Blue}m$Text$esc[0m"
}

Write-Host "Running tests..." -ForegroundColor Green
dart test --coverage=./coverage

if ($LASTEXITCODE -eq 0) {
    Write-Host "Generating coverage data..." -ForegroundColor Green
    dart run coverage:format_coverage --lcov --in=coverage --out=coverage/lcov.info --report-on=lib

    $padNumber = 35
    
    Write-Host "`nCoverage Summary:" -ForegroundColor Cyan
    Write-Host ("File".PadRight($padNumber) + "Coverage %") -ForegroundColor Yellow
    Write-Host ("----".PadRight($padNumber) + "----------") -ForegroundColor Yellow
    
    $content = Get-Content "coverage/lcov.info" -Raw
    $records = $content -split "end_of_record"
    
    foreach ($record in $records) {
        if ($record -match "SF:(.+?)\n") {
            $fileName = $matches[1].Trim()
            $linesFound = 0
            $linesHit = 0
            
            if ($record -match "LF:(\d+)") { $linesFound = [int]$matches[1] }
            if ($record -match "LH:(\d+)") { $linesHit = [int]$matches[1] }
            
            if ($linesFound -gt 0) {
                $coveragePercent = [math]::Round(($linesHit / $linesFound) * 100, 1)
                $shortName = [System.IO.Path]::GetFileName($fileName)
                
                $output = ($shortName.PadRight($padNumber) + "$coveragePercent%")
                
                if ($Host.UI.RawUI.SupportsVirtualTerminal) {
                    # Используем RGB градиент если терминал поддерживает
                    $rgb = Get-CoverageColor -Percent $coveragePercent
                    Write-ColoredText -Text $output -Red $rgb.Red -Green $rgb.Green -Blue $rgb.Blue
                } else {
                    # Fallback на простые цвета
                    $color = if ($coveragePercent -eq 100) { "Green" }
                            elseif ($coveragePercent -ge 80) { "Green" }
                            elseif ($coveragePercent -ge 60) { "Yellow" }
                            elseif ($coveragePercent -ge 40) { "DarkYellow" }
                            else { "Red" }
                    Write-Host $output -ForegroundColor $color
                }
            }
        }
    }
}