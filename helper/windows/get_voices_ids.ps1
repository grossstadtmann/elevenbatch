# Define the API key. Replace <xi-api-key> with your actual API key.
$API_KEY = "YOUR_API_KEY"

# Define the API endpoint URL.
$url = "https://api.elevenlabs.io/v1/models"

# Send a GET request to the API endpoint using Invoke-RestMethod.
$response = Invoke-RestMethod -Method Get -Uri $url -Headers @{
    "Accept" = "application/json"
    "xi-api-key" = $API_KEY
    "Content-Type" = "application/json"
}

# Extract and process the model_id from the response.
foreach ($voice in $response.voices) {
    $model_id = $voice.model_id
    if ($model_id) {
        Write-Output $model_id
    }
}
