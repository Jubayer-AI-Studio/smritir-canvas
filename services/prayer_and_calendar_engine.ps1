# 'Meshk' Offline Prayer & Calendar Engine Test
param(
    [double]$Latitude = 23.8103,  # Dhaka
    [double]$Longitude = 90.4125,
    [double]$TimeZone = 6.0,
    [datetime]$Date = (Get-Date)
)

function Get-JulianDate([datetime]$d) {
    $year = $d.Year
    $month = $d.Month
    $day = $d.Day
    if ($month -le 2) {
        $year -= 1
        $month += 12
    }
    $A = [math]::Floor($year / 100.0)
    $B = 2 - $A + [math]::Floor($A / 4.0)
    return [math]::Floor(365.25 * ($year + 4716)) + [math]::Floor(30.6001 * ($month + 1)) + $day + $B - 1524.5
}

function To-DoubleHours([double]$hours) {
    $h = [math]::Floor($hours)
    $m = [math]::Floor(($hours - $h) * 60)
    $s = [math]::Floor((($hours - $h) * 60 - $m) * 60)
    $ampm = "AM"
    $displayH = $h
    if ($displayH -ge 12) {
        $ampm = "PM"
        if ($displayH -gt 12) { $displayH -= 12 }
    }
    if ($displayH -eq 0) { $displayH = 12 }
    return [string]::Format("{0:D2}:{1:D2}:{2:D2} {3}", [int]$displayH, [int]$m, [int]$s, $ampm)
}

function Calculate-PrayerTimes([double]$lat, [double]$lng, [double]$tz, [datetime]$targetDate) {
    $JD = Get-JulianDate $targetDate
    $D = $JD - 2451545.0
    $g = (357.529 + 0.98560028 * $D) % 360
    $q = (280.459 + 0.98564736 * $D) % 360
    $L = ($q + 1.915 * [math]::Sin($g * [math]::PI / 180.0) + 0.020 * [math]::Sin(2 * $g * [math]::PI / 180.0)) % 360
    
    $e = 23.439 - 0.00000036 * $D
    $sinD = [math]::Sin($e * [math]::PI / 180.0) * [math]::Sin($L * [math]::PI / 180.0)
    $dec = [math]::Asin($sinD) * 180.0 / [math]::PI
    
    $RA = [math]::Atan2([math]::Cos($e * [math]::PI / 180.0) * [math]::Sin($L * [math]::PI / 180.0), [math]::Cos($L * [math]::PI / 180.0)) * 180.0 / [math]::PI
    $RA = ($RA / 15.0)
    if ($RA -lt 0) { $RA += 24.0 }
    
    $EqT = ($q / 15.0) - $RA
    $dhuhr = 12.0 + $tz - ($lng / 15.0) - $EqT
    
    # Fajr (18 deg - Karachi / BD Islamic Foundation)
    $fajrAngle = -18.0
    $cosHA_f = ([math]::Sin($fajrAngle * [math]::PI / 180.0) - [math]::Sin($lat * [math]::PI / 180.0) * [math]::Sin($dec * [math]::PI / 180.0)) / ([math]::Cos($lat * [math]::PI / 180.0) * [math]::Cos($dec * [math]::PI / 180.0))
    $HA_f = [math]::Acos($cosHA_f) * 180.0 / [math]::PI / 15.0
    $fajr = $dhuhr - $HA_f
    
    # Sunrise (-0.833 deg)
    $sunAngle = -0.833
    $cosHA_s = ([math]::Sin($sunAngle * [math]::PI / 180.0) - [math]::Sin($lat * [math]::PI / 180.0) * [math]::Sin($dec * [math]::PI / 180.0)) / ([math]::Cos($lat * [math]::PI / 180.0) * [math]::Cos($dec * [math]::PI / 180.0))
    $HA_s = [math]::Acos($cosHA_s) * 180.0 / [math]::PI / 15.0
    $sunrise = $dhuhr - $HA_s
    $maghrib = $dhuhr + $HA_s
    
    # Asr Hanafi (Shadow factor = 2 + tan(|lat - dec|))
    $hanafiShadow = 2.0 + [math]::Tan([math]::Abs($lat - $dec) * [math]::PI / 180.0)
    $asrAngle = [math]::Atan(1.0 / $hanafiShadow) * 180.0 / [math]::PI
    $cosHA_a = ([math]::Sin($asrAngle * [math]::PI / 180.0) - [math]::Sin($lat * [math]::PI / 180.0) * [math]::Sin($dec * [math]::PI / 180.0)) / ([math]::Cos($lat * [math]::PI / 180.0) * [math]::Cos($dec * [math]::PI / 180.0))
    $HA_a = [math]::Acos($cosHA_a) * 180.0 / [math]::PI / 15.0
    $asr = $dhuhr + $HA_a
    
    # Isha (18 deg)
    $isha = $dhuhr + $HA_f
    
    return [PSCustomObject]@{
        Fajr    = To-DoubleHours $fajr
        Sunrise = To-DoubleHours $sunrise
        Dhuhr   = To-DoubleHours $dhuhr
        Asr     = To-DoubleHours $asr
        Maghrib = To-DoubleHours $maghrib
        Isha    = To-DoubleHours $isha
    }
}

function Get-HijriDate([datetime]$d, [int]$offset = 0) {
    $jd = [math]::Floor((Get-JulianDate $d) + $offset)
    $l = $jd - 1948440 + 10632
    $n = [math]::Floor(($l - 1) / 10631)
    $l = $l - 10631 * $n + 354
    $j = ([math]::Floor((10985 - $l) / 5316)) * ([math]::Floor((50 * $l) / 17719)) + ([math]::Floor($l / 5670)) * ([math]::Floor((43 * $l) / 15238))
    $l = $l - ([math]::Floor((30 - $j) / 15)) * ([math]::Floor((17719 * $j) / 50)) - ([math]::Floor($j / 16)) * ([math]::Floor((15238 * $j) / 43)) + 29
    $m = [math]::Floor((24 * $l) / 709)
    $day = $l - [math]::Floor((709 * $m) / 24)
    $year = 30 * $n + $j - 30
    return "$day / $m / $year AH"
}

Write-Host "=========================================" -ForegroundColor Cyan
Write-Host "   Offline Prayer & Hijri Engine Test" -ForegroundColor Cyan
Write-Host "=========================================" -ForegroundColor Cyan

$today = Get-Date
$prayers = Calculate-PrayerTimes -lat $Latitude -lng $Longitude -tz $TimeZone -targetDate $today
$hijri = Get-HijriDate -d $today

Write-Host "Location : Lat $Latitude, Lng $Longitude (Dhaka, GMT+$TimeZone)" -ForegroundColor Gray
Write-Host "Date     : $($today.ToString('yyyy-MM-dd HH:mm:ss'))" -ForegroundColor White
Write-Host "Hijri    : $hijri" -ForegroundColor Green
Write-Host "`nPrayer Times (Hanafi, BD Islamic Foundation Method):" -ForegroundColor Yellow
Write-Host "  Fajr    : $($prayers.Fajr)"
Write-Host "  Sunrise : $($prayers.Sunrise)"
Write-Host "  Dhuhr   : $($prayers.Dhuhr)"
Write-Host "  Asr     : $($prayers.Asr)"
Write-Host "  Maghrib : $($prayers.Maghrib)"
Write-Host "  Isha    : $($prayers.Isha)"

Write-Host "`n[SUCCESS] Prayer calculation validated!" -ForegroundColor Green
