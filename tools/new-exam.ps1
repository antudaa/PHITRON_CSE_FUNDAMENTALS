param(
    [Parameter(Mandatory)] [string] $Semester,
    [Parameter(Mandatory)] [string] $Course,
    [Parameter(Mandatory)] [string] $ExamType,
    [Parameter(Mandatory)] [string] $ExamName
)

$repoRoot = Split-Path -Parent $PSScriptRoot
$semesterName = $Semester -replace '^Semester_', ''
if ($semesterName -notin '1', '2', '3') { Write-Error 'Semester must be 1, 2, or 3.'; exit 1 }
$examRoot = Join-Path $repoRoot "06_EXAMS\Semester_$semesterName\$ExamType"
$templatePath = Join-Path $repoRoot '_TEMPLATES\EXAM_TEMPLATE'
if (-not (Test-Path -LiteralPath $examRoot)) { Write-Error "Exam type path not found: $examRoot"; exit 1 }
$safeName = ($ExamName -replace '[<>:"/\\|?*]', '_' -replace '\s+', '_').Trim('_')
if ([string]::IsNullOrWhiteSpace($safeName)) { Write-Error 'Exam name must contain valid folder-name characters.'; exit 1 }
$destination = Join-Path $examRoot $safeName
if (Test-Path -LiteralPath $destination) { Write-Error "Exam already exists: $destination"; exit 1 }

Copy-Item -LiteralPath $templatePath -Destination $destination -Recurse
$readme = Join-Path $destination 'README.md'
$content = Get-Content -LiteralPath $readme -Raw
$content = $content.Replace('- Exam:', "- Exam: $ExamName").Replace('- Semester:', "- Semester: $semesterName").Replace('- Course:', "- Course: $Course")
Set-Content -LiteralPath $readme -Value $content -Encoding utf8
Write-Host "Created exam: $destination" -ForegroundColor Green
