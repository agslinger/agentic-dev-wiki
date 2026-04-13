$ErrorActionPreference = "Stop"

$inputJson = ""
try {
  $inputJson = [Console]::In.ReadToEnd()
} catch {
  exit 0
}

$repoRoot = $env:CLAUDE_PROJECT_DIR
if (-not $repoRoot) {
  exit 0
}

$transcriptPath = $null
try {
  if ($inputJson) {
    $payload = $inputJson | ConvertFrom-Json -ErrorAction Stop
    $transcriptPath = $payload.transcript_path
  }
} catch {
}

$sawLint = $false
if ($transcriptPath -and (Test-Path $transcriptPath)) {
  try {
    $transcript = Get-Content -LiteralPath $transcriptPath -Raw
    if ($transcript -match 'wiki-lint\.ps1' -or $transcript -match 'Wiki lint passed') {
      $sawLint = $true
    }
  } catch {
  }
}

if (-not $sawLint) {
  Write-Output '{"continue":true,"suppressOutput":false,"systemMessage":"If you changed wiki pages or index/log structure, run `pwsh ./scripts/wiki-lint.ps1` before finishing."}'
}

exit 0
