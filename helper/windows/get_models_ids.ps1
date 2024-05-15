# Define the API key. Replace <xi-api-key> with your actual API key.
$API_KEY = "YOUR_API_KEY"

# Define the API endpoint URL.
$url = "https://api.elevenlabs.io/v1/voices"

# Send a GET request to the API endpoint using Invoke-RestMethod.
$response = Invoke-RestMethod -Method Get -Uri $url -Headers @{
    "Accept" = "application/json"
    "xi-api-key" = $API_KEY
    "Content-Type" = "application/json"
}

# Extract and process the name and voice_id from the response.
foreach ($voice in $response.voices) {
    $name = $voice.name
    $voice_id = $voice.voice_id
    if ($name -and $voice_id) {
        Write-Output "$name; $voice_id"
    }
}
