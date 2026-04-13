Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$repoRoot = Split-Path -Parent $PSScriptRoot
$pagesDir = Join-Path $repoRoot "pages"
$indexPath = Join-Path $repoRoot "index.md"
$schemaPath = Join-Path $repoRoot "SCHEMA.md"

$errors = New-Object System.Collections.Generic.List[string]
$warnings = New-Object System.Collections.Generic.List[string]

function Add-Error([string]$message) {
  $errors.Add($message)
}

function Add-Warning([string]$message) {
  $warnings.Add($message)
}

function Get-FileLines([string]$path) {
  return Get-Content -LiteralPath $path
}

function Test-RequiredHeadings([string[]]$content, [string[]]$requiredHeadings, [string]$fileName) {
  foreach ($heading in $requiredHeadings) {
    if (-not ($content -match [regex]::Escape($heading))) {
      Add-Error("$fileName is missing required heading: $heading")
    }
  }
}

if (-not (Test-Path $indexPath)) {
  Add-Error("Missing index.md")
}

if (-not (Test-Path $schemaPath)) {
  Add-Error("Missing SCHEMA.md")
}

$pageFiles = Get-ChildItem -LiteralPath $pagesDir -File -Filter *.md | Sort-Object Name
$pageNames = $pageFiles.Name

$indexText = Get-Content -LiteralPath $indexPath -Raw
$indexMatches = [regex]::Matches($indexText, 'pages/([A-Za-z0-9\-]+\.md)')
$indexedPages = $indexMatches | ForEach-Object { $_.Groups[1].Value } | Sort-Object -Unique

foreach ($indexed in $indexedPages) {
  if (-not ($pageNames -contains $indexed)) {
    Add-Error("index.md references missing page: $indexed")
  }
}

foreach ($page in $pageNames) {
  if (-not ($indexedPages -contains $page)) {
    Add-Error("Orphan page not listed in index.md: $page")
  }
}

foreach ($pageFile in $pageFiles) {
  $content = Get-FileLines $pageFile.FullName
  $raw = Get-Content -LiteralPath $pageFile.FullName -Raw
  $fileName = $pageFile.Name

  if ($content.Length -gt 220) {
    Add-Error("$fileName exceeds 220 lines ($($content.Length))")
  }

  if (-not $raw.StartsWith("---")) {
    Add-Error("$fileName is missing YAML frontmatter")
    continue
  }

  $requiredFrontmatter = @("title:", "type:", "status:", "confidence:", "tags:", "last-updated:", "sources:")
  foreach ($field in $requiredFrontmatter) {
    if (-not ($raw -match [regex]::Escape($field))) {
      Add-Error("$fileName is missing frontmatter field $field")
    }
  }

  $typeMatch = [regex]::Match($raw, '(?m)^type:\s*(.+)$')
  $pageType = if ($typeMatch.Success) { $typeMatch.Groups[1].Value.Trim() } else { "" }

  if ($pageType -eq "checklist") {
    Test-RequiredHeadings $content @("## Read This When", "## Default Flow", "## Checklist", "## Related Pages") $fileName
  } elseif ($pageType) {
    Test-RequiredHeadings $content @("## Read This When", "## Default Recommendation", "## Use This Pattern", "## Commands / Config", "## Pitfalls", "## Related Pages") $fileName
  }

  $relatedMatches = [regex]::Matches($raw, '\[[^\]]+\]\(([^)]+\.md)\)')
  foreach ($match in $relatedMatches) {
    $target = $match.Groups[1].Value
    if ($target -like "pages/*") {
      $resolved = Join-Path $repoRoot $target
      if (-not (Test-Path $resolved)) {
        Add-Error("$fileName links to missing page path: $target")
      }
    } elseif ($target -notmatch '^(https?:|/)' ) {
      $resolved = Join-Path $pageFile.DirectoryName $target
      if (-not (Test-Path $resolved)) {
        Add-Error("$fileName links to missing relative page: $target")
      }
    }
  }
}

if ($warnings.Count -gt 0) {
  Write-Host "Warnings:" -ForegroundColor Yellow
  $warnings | ForEach-Object { Write-Host " - $_" -ForegroundColor Yellow }
}

if ($errors.Count -gt 0) {
  Write-Host "Wiki lint failed:" -ForegroundColor Red
  $errors | ForEach-Object { Write-Host " - $_" -ForegroundColor Red }
  exit 1
}

Write-Host "Wiki lint passed." -ForegroundColor Green
