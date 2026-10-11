# =====================================================================
# 'স্মৃতির ক্যানভাস' (Smritir Canvas) — Localhost Production Server
# Port: 3000 (http://localhost:3000)
# =====================================================================

param (
    [int]$Port = 3000,
    [string]$RootFolder = "$PSScriptRoot\public"
)

if (-not (Test-Path $RootFolder)) {
    $RootFolder = "$PSScriptRoot\web_preview"
}

$listener = New-Object System.Net.HttpListener
$prefix = "http://localhost:$Port/"
$listener.Prefixes.Add($prefix)

try {
    $listener.Start()
    Write-Host "==========================================================" -ForegroundColor Green
    Write-Host " 'স্মৃতির ক্যানভাস' (Smritir Canvas) Live Server Running!" -ForegroundColor Cyan
    Write-Host " Localhost URL: http://localhost:$Port" -ForegroundColor Yellow
    Write-Host " Serving Files From: $RootFolder" -ForegroundColor Gray
    Write-Host "==========================================================" -ForegroundColor Green
} catch {
    Write-Error "Failed to start listener on port $($Port): $_"
    exit 1
}

$mimeMap = @{
    ".html" = "text/html; charset=utf-8"
    ".htm"  = "text/html; charset=utf-8"
    ".css"  = "text/css; charset=utf-8"
    ".js"   = "application/javascript; charset=utf-8"
    ".json" = "application/json; charset=utf-8"
    ".png"  = "image/png"
    ".jpg"  = "image/jpeg"
    ".jpeg" = "image/jpeg"
    ".gif"  = "image/gif"
    ".svg"  = "image/svg+xml"
    ".ico"  = "image/x-icon"
    ".txt"  = "text/plain; charset=utf-8"
}

while ($listener.IsListening) {
    try {
        $context = $listener.GetContext()
        $request = $context.Request
        $response = $context.Response

        $urlPath = $request.Url.LocalPath.TrimStart('/')
        if ([string]::IsNullOrWhiteSpace($urlPath)) {
            $urlPath = "index.html"
        }

        # Security check - prevent path traversal
        $safePath = [System.IO.Path]::GetFullPath((Join-Path $RootFolder $urlPath))
        $rootFullPath = [System.IO.Path]::GetFullPath($RootFolder)

        if (-not $safePath.StartsWith($rootFullPath, [System.StringComparison]::OrdinalIgnoreCase)) {
            $response.StatusCode = 403
            $bytes = [System.Text.Encoding]::UTF8.GetBytes("403 Forbidden")
            $response.OutputStream.Write($bytes, 0, $bytes.Length)
            $response.Close()
            continue
        }

        if (Test-Path $safePath -PathType Leaf) {
            $ext = [System.IO.Path]::GetExtension($safePath).ToLower()
            $mime = if ($mimeMap.ContainsKey($ext)) { $mimeMap[$ext] } else { "application/octet-stream" }
            
            $fileBytes = [System.IO.File]::ReadAllBytes($safePath)
            $response.ContentType = $mime
            $response.ContentLength64 = $fileBytes.Length
            $response.StatusCode = 200
            $response.AddHeader("Access-Control-Allow-Origin", "*")
            $response.AddHeader("Cache-Control", "no-cache, no-store, must-revalidate")
            $response.OutputStream.Write($fileBytes, 0, $fileBytes.Length)
        } else {
            # Single page app fallback to index.html if file doesn't exist
            $indexPath = Join-Path $RootFolder "index.html"
            if (Test-Path $indexPath) {
                $fileBytes = [System.IO.File]::ReadAllBytes($indexPath)
                $response.ContentType = "text/html; charset=utf-8"
                $response.ContentLength64 = $fileBytes.Length
                $response.StatusCode = 200
                $response.AddHeader("Access-Control-Allow-Origin", "*")
                $response.OutputStream.Write($fileBytes, 0, $fileBytes.Length)
            } else {
                $response.StatusCode = 404
                $bytes = [System.Text.Encoding]::UTF8.GetBytes("404 Not Found")
                $response.OutputStream.Write($bytes, 0, $bytes.Length)
            }
        }
        $response.Close()
    } catch {
        # continue loop on client abort
    }
}
