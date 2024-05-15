#!/bin/bash

# Define the API key. Replace <xi-api-key> with your actual API key.
API_KEY="YOUR_API_KEY"

# Define the API endpoint URL.
url="https://api.elevenlabs.io/v1/voices"

# Send a GET request to the API endpoint using curl.
# The -H flag adds headers to the request.
response=$(curl -s -X GET "$url" \
  -H "Accept: application/json" \
  -H "xi-api-key: $API_KEY" \
  -H "Content-Type: application/json")

# Extract the voices information and process it line by line.
echo "$response" | tr -d '\n' | sed 's/},{/}\n{/g' | while IFS= read -r line; do
    name=$(echo "$line" | grep -o '"name":"[^"]*"' | sed 's/"name":"\([^"]*\)"/\1/')
    voice_id=$(echo "$line" | grep -o '"voice_id":"[^"]*"' | sed 's/"voice_id":"\([^"]*\)"/\1/')
    
    if [ -n "$name" ] && [ -n "$voice_id" ]; then
        echo "$name; $voice_id"
    fi
done
