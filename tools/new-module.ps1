param(
    [Parameter(Mandatory)] [string] $Course,
    [Parameter(Mandatory)] [string] $Module,
    [Parameter(Mandatory)] [string] $Title
)

$repoRoot = Split-Path -Parent $PSScriptRoot
$coursePath = Join-Path $repoRoot $Course
$templatePath = Join-Path $repoRoot '_TEMPLATES\MODULE_TEMPLATE'

if (-not (Test-Path -LiteralPath $coursePath)) { Write-Error "Course path not found: $Course"; exit 1 }
$safeTitle = ($Title -replace '[<>:"/\\|?*]', '_' -replace '\s+', '_').Trim('_')
if ([string]::IsNullOrWhiteSpace($safeTitle)) { Write-Error 'Title must contain valid folder-name characters.'; exit 1 }
$moduleName = "Module_${Module}_${safeTitle}"
$destination = Join-Path $coursePath "Modules\$moduleName"
if (Test-Path -LiteralPath $destination) { Write-Error "Module already exists: $destination"; exit 1 }

Copy-Item -LiteralPath $templatePath -Destination $destination -Recurse
$readme = Join-Path $destination 'README.md'
$content = Get-Content -LiteralPath $readme -Raw
$content = $content.Replace('Module XX', "Module $Module").Replace('Module Title', $Title)
Set-Content -LiteralPath $readme -Value $content -Encoding utf8
Write-Host "Created module: $destination" -ForegroundColor Green
