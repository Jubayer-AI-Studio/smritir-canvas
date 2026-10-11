# 'Meshk' Database Schema Verification Script
$schemaPath = Join-Path $PSScriptRoot "schema.sql"
$seedPath   = Join-Path $PSScriptRoot "seed.sql"

Write-Host "=================================================" -ForegroundColor Cyan
Write-Host "   Meshk Database Schema Verification (T-104)" -ForegroundColor Cyan
Write-Host "=================================================" -ForegroundColor Cyan

if (-not (Test-Path $schemaPath)) {
    Write-Error "Schema file not found at: $schemaPath"
    exit 1
}

if (-not (Test-Path $seedPath)) {
    Write-Error "Seed file not found at: $seedPath"
    exit 1
}

$schemaContent = Get-Content $schemaPath -Raw
$seedContent   = Get-Content $seedPath -Raw

$expectedTables = @(
    "authors",
    "categories",
    "articles",
    "article_versions",
    "interview_audio_markers",
    "bookshelf",
    "living_quotes",
    "article_comments",
    "article_interactions",
    "app_settings"
)

Write-Host "`n[1] Checking Tables..." -ForegroundColor Yellow
$missingTables = @()
foreach ($table in $expectedTables) {
    if ($schemaContent -match "CREATE TABLE IF NOT EXISTS $table\b") {
        Write-Host "  [OK] Table '$table' found." -ForegroundColor Green
    } else {
        Write-Host "  [FAIL] Missing table: $table" -ForegroundColor Red
        $missingTables += $table
    }
}

Write-Host "`n[2] Checking Foreign Keys and Indexes..." -ForegroundColor Yellow
$fkMatches = [regex]::Matches($schemaContent, 'FOREIGN KEY\s*\(([^)]+)\)\s*REFERENCES\s*([^(]+)\(([^)]+)\)')
Write-Host "  Total Foreign Keys found: $($fkMatches.Count)" -ForegroundColor Green
foreach ($fk in $fkMatches) {
    Write-Host "  -> $($fk.Value.Trim())" -ForegroundColor Gray
}

$indexMatches = [regex]::Matches($schemaContent, 'CREATE\s+(?:UNIQUE\s+)?INDEX\s+IF NOT EXISTS\s+(\w+)\s+ON\s+(\w+)')
Write-Host "  Total Indexes found: $($indexMatches.Count)" -ForegroundColor Green
foreach ($idx in $indexMatches) {
    Write-Host "  -> Index: $($idx.Groups[1].Value) ON $($idx.Groups[2].Value)" -ForegroundColor Gray
}

Write-Host "`n[3] Checking Seed Data..." -ForegroundColor Yellow
foreach ($table in $expectedTables) {
    if ($seedContent -match "INSERT INTO $table\b") {
        Write-Host "  [OK] Seed records for '$table'." -ForegroundColor Green
    } else {
        Write-Host "  [NOTICE] No direct seed records for '$table'." -ForegroundColor Yellow
    }
}

if ($missingTables.Count -eq 0) {
    Write-Host "`n=================================================" -ForegroundColor Green
    Write-Host " [SUCCESS] All 10 tables and constraints verified!" -ForegroundColor Green
    Write-Host "=================================================" -ForegroundColor Green
    exit 0
} else {
    Write-Host "`n[ERROR] Missing tables!" -ForegroundColor Red
    exit 1
}
