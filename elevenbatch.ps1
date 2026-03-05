param(
    [Parameter(Mandatory = $true, Position = 0)]
    [string]$CsvFile,

    [Parameter(Mandatory = $true, Position = 1)]
    [string]$Columns
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

if (-not (Test-Path -LiteralPath $CsvFile -PathType Leaf)) {
    Write-Error "File not found: $CsvFile"
    exit 1
}

$API_KEY = if ($env:ELEVENLABS_API_KEY) { $env:ELEVENLABS_API_KEY } else { "YOUR_API_KEY" }
$API_VOICE = if ($env:ELEVENLABS_API_VOICE) { $env:ELEVENLABS_API_VOICE } else { "YOUR_API_VOICE" }
$API_MODEL_ID = if ($env:ELEVENLABS_API_MODEL_ID) { $env:ELEVENLABS_API_MODEL_ID } else { "YOUR_API_MODEL_ID" }

if ($API_KEY -eq "YOUR_API_KEY" -or $API_VOICE -eq "YOUR_API_VOICE" -or $API_MODEL_ID -eq "YOUR_API_MODEL_ID") {
    Write-Error "Please set ELEVENLABS_API_KEY, ELEVENLABS_API_VOICE and ELEVENLABS_API_MODEL_ID."
    exit 1
}

$columnIndices = $Columns -split ','
foreach ($index in $columnIndices) {
    if ($index -notmatch '^[0-9]+$') {
        Write-Error "Invalid column index: $index"
        exit 1
    }
}

function Get-SafeFileName {
    param([string]$InputValue)

    $safe = ($InputValue -replace '\s+', '_') -replace '[^\w-]', ''
    if ([string]::IsNullOrWhiteSpace($safe)) {
        return "output"
    }

    return $safe
}

function Get-UniqueFileName {
    param([string]$BaseName)

    $candidate = "$BaseName.mp3"
    $counter = 1

    while (Test-Path -LiteralPath $candidate) {
        $candidate = "${BaseName}_$counter.mp3"
        $counter++
    }

    return $candidate
}

$apiUrl = "https://api.elevenlabs.io/v1/text-to-speech/$API_VOICE"
$csvContent = Get-Content -LiteralPath $CsvFile | Select-Object -Skip 1

foreach ($line in $csvContent) {
    $lineArray = $line -split ';'

    foreach ($index in $columnIndices) {
        $columnIndex = [int]$index
        if ($columnIndex -lt $lineArray.Length) {
            $value = $lineArray[$columnIndex].Trim('"')
            if ([string]::IsNullOrWhiteSpace($value)) {
                continue
            }

            $safeValue = Get-SafeFileName -InputValue $value
            $outputFile = Get-UniqueFileName -BaseName $safeValue

            $data = @{
                voice_settings = @{
                    stability = 0.5
                    similarity_boost = 0.75
                    style = 0
                    use_speaker_boost = $true
                }
                model_id = $API_MODEL_ID
                text = $value
            } | ConvertTo-Json -Depth 4 -Compress

            Invoke-RestMethod -Method Post `
                -Uri $apiUrl `
                -Headers @{ "Content-Type" = "application/json"; "xi-api-key" = $API_KEY } `
                -Body $data `
                -OutFile $outputFile
        }
        else {
            Write-Host "N/A"
        }
    }
}
