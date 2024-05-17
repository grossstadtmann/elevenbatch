# Check if the correct number of arguments is provided
if ($args.Count -ne 2) {
    Write-Host "Usage: .\print_csv.ps1 <csv_file> <columns>"
    Write-Host "Example: .\print_csv.ps1 data.csv 0,1,5,6,9,10"
    exit
}

# Check if the file exists
if (-not (Test-Path $args[0])) {
    Write-Host "File not found!"
    exit
}

# Get the column indices and convert them into an array
$column_indices = $args[1] -split ','

# Define the ElevenLabs API key
$API_KEY = "YOUR_API_KEY"

# Define the ElevenLabs API Voice
# Example: Drew; 29vD33N1CtxCmqQRPOHJ | Clyde; 2EiwWnXFnvU5JabPnv8n | Paul; 5Q0t7uMcjvnagumLfvZi
API_VOICE="YOUR_API_VOICE"
$API_URL = "https://api.elevenlabs.io/v1/text-to-speech/"$API_VOICE

# Define the ElevenLabs API Leanguage Model ID
# Example: eleven_multilingual_v2, eleven_multilingual_v1, eleven_monolingual_v1, eleven_english_sts_v2, eleven_turbo_v2, eleven_multilingual_sts_v2
API_MODEL_ID="YOUR_API_MODEL_ID"

# Read the CSV file, skipping the first line
$csv_content = Get-Content $args[0] | Select-Object -Skip 1

foreach ($line in $csv_content) {
    $lineArray = $line -split ';'
    
    foreach ($index in $column_indices) {
        if ($index -lt $lineArray.Length) {
            $value = $lineArray[$index].Trim('"')  # Remove double quotes
            
            # Ensure the filename is safe by replacing spaces with underscores and removing other problematic characters
            $safe_value = $value -replace ' ', '_' -replace '[^\w]', ''
            
            # Prepare the data for the API request
            $data = @{
                "voice_settings" = @{
                    "stability" = 0.5
                    "similarity_boost" = 0.75
                    "style" = 0
                    "use_speaker_boost" = $true
                }
                "model_id" = $API_MODEL_ID
                "text" = $value
            } | ConvertTo-Json
            
            # Send the value to the ElevenLabs API
            Invoke-RestMethod -Method Post -Uri $API_URL -Headers @{ "Content-Type" = "application/json"; "xi-api-key" = $API_KEY } -Body $data -OutFile "${safe_value}.mp3"
        } else {
            Write-Host "N/A"
        }
    }
}
