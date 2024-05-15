#!/bin/bash

# Define the API key. Replace <xi-api-key> with your actual API key.
API_KEY="YOUR_API_KEY"

# Define the API endpoint URL.
url="https://api.elevenlabs.io/v1/models"

# Send a GET request to the API endpoint using curl.
# The -H flag adds headers to the request.
response=$(curl -s -X GET "$url" \
  -H "Accept: application/json" \
  -H "xi-api-key: $API_KEY" \
  -H "Content-Type: application/json")

# Extract the model_id information and process it line by line.
echo "$response" | tr -d '\n' | sed 's/},{/}\n{/g' | while IFS= read -r line; do
    model_id=$(echo "$line" | grep -o '"model_id":"[^"]*"' | sed 's/"model_id":"\([^"]*\)"/\1/')
    
    if [ -n "$model_id" ]; then
        echo "$model_id"
    fi
done
