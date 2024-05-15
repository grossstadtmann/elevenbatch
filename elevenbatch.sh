#!/bin/bash

# Check if the correct number of arguments is provided
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <csv_file> <columns>"
    echo "Example: $0 data.csv 0,1,5,6,9,10"
    exit 1
fi

# Check if the file exists
if [ ! -f "$1" ]; then
    echo "File not found!"
    exit 1
fi

# Get the column indices and convert them into an array
IFS=',' read -r -a column_indices <<< "$2"

# Define the ElevenLabs API key
API_KEY="YOUR_API_KEY"

# Define the ElevenLabs API Voice
API_VOICE="YOUR_API_VOICE"

# Define the ElevenLabs API Leanguage Model ID
API_MODEL_ID="YOUR_API_MODEL_ID"

# Read the CSV file, skipping the first line
{
    read
    while IFS=';' read -r -a lineArray; do
        for index in "${column_indices[@]}"; do
            if [ "$index" -lt "${#lineArray[@]}" ]; then
                value="${lineArray[$index]}"
                value="${value//\"/}"  # Remove double quotes
                
                # Ensure the filename is safe by replacing spaces with underscores and removing other problematic characters
                safe_value=$(echo "$value" | tr ' ' '_' | tr -d '[:punct:]')
                
                # Send the value to the ElevenLabs API
                curl --request POST \
                     --url "https://api.elevenlabs.io/v1/text-to-speech/$API_VOICE" \
                     --header "Content-Type: application/json" \
                     --header "xi-api-key: $API_KEY" \
                     --data '{
                         "voice_settings": {
                             "stability": 0.5,
                             "similarity_boost": 0.75,
                             "style": 0,
                             "use_speaker_boost": true
                         },
                         "model_id": "'$API_MODEL_ID'",
                         "text": "'"$value"'"
                     }' \
                     --output "${safe_value}.mp3"
            else
                echo "N/A"
            fi
        done
    done
} < "$1"
