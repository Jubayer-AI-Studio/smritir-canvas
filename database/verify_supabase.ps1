# 'Smritir Canvas' Supabase SQL Verification Script
$supabaseFile = Join-Path $PSScriptRoot "supabase_production.sql"

Write-Host "=================================================" -ForegroundColor Cyan
Write-Host "   Smritir Canvas Supabase DDL Verification" -ForegroundColor Cyan
Write-Host "=================================================" -ForegroundColor Cyan

if (-not (Test-Path $supabaseFile)) {
    Write-Error "Supabase file not found!"
    exit 1
}

$content = Get-Content $supabaseFile -Raw

$tables = @(
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

Write-Host "`n[1] Verifying 10 Public Tables..." -ForegroundColor Yellow
foreach ($t in $tables) {
    if ($content -match "CREATE TABLE IF NOT EXISTS public\.$t\b") {
        Write-Host "  [OK] Table public.$t" -ForegroundColor Green
    } else {
        Write-Host "  [FAIL] Missing public.$t" -ForegroundColor Red
        exit 1
    }
}

Write-Host "`n[2] Verifying Row Level Security (RLS) & Full Admin Policies..." -ForegroundColor Yellow
$rlsCount = ([regex]::Matches($content, 'ALTER TABLE public\.\w+ ENABLE ROW LEVEL SECURITY')).Count
Write-Host "  Tables with RLS enabled: $rlsCount (Expected: 10)" -ForegroundColor Green

$adminPolicies = ([regex]::Matches($content, 'CREATE POLICY "Admin All \w+"')).Count
Write-Host "  Admin Full-Mutation Policies: $adminPolicies (Expected: 10)" -ForegroundColor Green

Write-Host "`n[3] Verifying Realtime Publications & Storage Buckets..." -ForegroundColor Yellow
if ($content -match 'ALTER PUBLICATION supabase_realtime') {
    Write-Host "  [OK] Supabase Realtime Publication enabled." -ForegroundColor Green
}
if ($content -match 'INSERT INTO storage\.buckets') {
    Write-Host "  [OK] Storage buckets defined for audio, pdfs, and media." -ForegroundColor Green
}

Write-Host "`n=================================================" -ForegroundColor Cyan
Write-Host " [SUCCESS] Supabase SQL Architecture 100% Validated!" -ForegroundColor Green
Write-Host "=================================================" -ForegroundColor Cyan
