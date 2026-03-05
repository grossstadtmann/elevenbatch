#!/usr/bin/env bash

set -euo pipefail

usage() {
    cat <<USAGE
Usage: $0 <csv_file> <columns>
Example: $0 data.csv 0,1,5,6,9,10

Configuration via environment variables:
  ELEVENLABS_API_KEY      (required)
  ELEVENLABS_API_VOICE    (required)
  ELEVENLABS_API_MODEL_ID (required)
USAGE
}

if [[ "$#" -ne 2 ]]; then
    usage
    exit 1
fi

csv_file="$1"
if [[ ! -f "$csv_file" ]]; then
    echo "File not found: $csv_file" >&2
    exit 1
fi

if ! command -v curl >/dev/null 2>&1; then
    echo "Missing dependency: curl" >&2
    exit 1
fi

API_KEY="${ELEVENLABS_API_KEY:-YOUR_API_KEY}"
API_VOICE="${ELEVENLABS_API_VOICE:-YOUR_API_VOICE}"
API_MODEL_ID="${ELEVENLABS_API_MODEL_ID:-YOUR_API_MODEL_ID}"

if [[ "$API_KEY" == "YOUR_API_KEY" || "$API_VOICE" == "YOUR_API_VOICE" || "$API_MODEL_ID" == "YOUR_API_MODEL_ID" ]]; then
    echo "Please set ELEVENLABS_API_KEY, ELEVENLABS_API_VOICE and ELEVENLABS_API_MODEL_ID." >&2
    exit 1
fi

IFS=',' read -r -a column_indices <<< "$2"
for index in "${column_indices[@]}"; do
    if [[ ! "$index" =~ ^[0-9]+$ ]]; then
        echo "Invalid column index: $index" >&2
        exit 1
    fi
done

json_escape() {
    local s="$1"
    s=${s//\\/\\\\}
    s=${s//\"/\\\"}
    s=${s//$'\n'/\\n}
    s=${s//$'\r'/\\r}
    s=${s//$'\t'/\\t}
    printf '%s' "$s"
}

safe_filename() {
    local input="$1"
    local output
    output=$(printf '%s' "$input" | tr '[:space:]' '_' | tr -cd '[:alnum:]_-')
    if [[ -z "$output" ]]; then
        output="output"
    fi
    printf '%s' "$output"
}

unique_filename() {
    local base="$1"
    local ext=".mp3"
    local candidate="${base}${ext}"
    local counter=1

    while [[ -e "$candidate" ]]; do
        candidate="${base}_${counter}${ext}"
        ((counter++))
    done

    printf '%s' "$candidate"
}

{
    read -r || true
    while IFS=';' read -r -a line_array; do
        for index in "${column_indices[@]}"; do
            if (( index < ${#line_array[@]} )); then
                value="${line_array[$index]//\"/}"

                if [[ -z "$value" ]]; then
                    continue
                fi

                safe_value=$(safe_filename "$value")
                output_file=$(unique_filename "$safe_value")
                escaped_value=$(json_escape "$value")

                payload=$(cat <<JSON
{
  "voice_settings": {
    "stability": 0.5,
    "similarity_boost": 0.75,
    "style": 0,
    "use_speaker_boost": true
  },
  "model_id": "${API_MODEL_ID}",
  "text": "${escaped_value}"
}
JSON
)

                curl --fail --silent --show-error \
                    --request POST \
                    --url "https://api.elevenlabs.io/v1/text-to-speech/${API_VOICE}" \
                    --header "Content-Type: application/json" \
                    --header "xi-api-key: ${API_KEY}" \
                    --data "$payload" \
                    --output "$output_file"
            else
                echo "N/A"
            fi
        done
    done
} < "$csv_file"
