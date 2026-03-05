# elevenbatch
[![ElevenLabs Partner](https://img.shields.io/badge/elevenlabs-.io-blue?style=flat)](https://try.elevenlabs.io/mj0wgsabw9tn)
[![Buy Me a Coffee at ko-fi.com](https://img.shields.io/badge/Buy_Me_a_Coffee_at-ko--fi.com-blue?style=flat&logo=kofi)](https://ko-fi.com/grossstadtmann)

elevenbatch is a shell and powershell script collection for batch processing text-to-speech conversions using the ElevenLabs Text-to-Speech API. The script reads a CSV file, extracts specified columns, and converts each value into an MP3 file using the API.

If you like, you can support my work by buying me a coffee via [ko-fi.com](https://ko-fi.com/grossstadtmann).

## Features

- Reads CSV files with semicolon-separated values.
- Allows selection of specific columns for text-to-speech conversion.
- Skips the header row of the CSV file.
- Removes double quotes from the values.
- Sends each value to the ElevenLabs Text-to-Speech API.
- Saves the resulting audio files as MP3 files named according to the value.

## Prerequisites

- Bash shell
- `curl` command-line tool
- ElevenLabs Subscription to create an API key -> support me via that [Link](https://try.elevenlabs.io/mj0wgsabw9tn)
- ElevenLabs Voice ID
- ElevenLabs Modle ID

## Installation

1. Clone the repository:
    ```sh
    git clone https://github.com/yourusername/elevenbatch.git
    cd elevenbatch
    ```

2. Make the script executable:
    ```sh
    chmod +x elevenbatch.sh
    ```

3. Set the required environment variables before running the script:

   ```sh
   export ELEVENLABS_API_KEY="your_api_key"
   export ELEVENLABS_API_VOICE="your_voice_id"
   export ELEVENLABS_API_MODEL_ID="your_model_id"
   ```

## Usage MacOS / Linux

```sh
./elevenbatch.sh <csv_file> <columns>
```

- `<csv_file>`: Path to the CSV file to be processed.  
- `<columns>`: Comma-separated list of column indices to be processed (0-based).

## Usage Windows

1. Save the script as elevenbatch.ps1.
2. Open PowerShell and navigate to the directory where the script is saved.
3. Set required environment variables in PowerShell:

```powershell
$env:ELEVENLABS_API_KEY="your_api_key"
$env:ELEVENLABS_API_VOICE="your_voice_id"
$env:ELEVENLABS_API_MODEL_ID="your_model_id"
```

4. Run the script:

```powershell
./elevenbatch.ps1 <csv_file> <columns>
```

## Example

1. Create a CSV file data.csv with the following content:

```csv
"Name";"Age";"Gender";"Occupation";"Country";"State";"City";"Zip";"Phone";"Email";"Notes"
"Alice";"30";"Female";"Engineer";"USA";"NY";"New York";"10001";"123-4567";"alice@example.com";"Likes hiking"
"Bob";"25";"Male";"Designer";"USA";"CA";"Los Angeles";"90001";"765-4321";"bob@example.com";"Plays guitar"
"Charlie";"35";"Male";"Doctor";"USA";"IL";"Chicago";"60001";"987-6543";"charlie@example.com";"Enjoys cooking"
```

2. Run the script to convert specific columns to speech:

```sh
./elevenbatch.sh data.csv 0,1,5,6,9,10
```
3. The script will generate MP3 files for the specified columns, e.g., Alice.mp3, 30.mp3, NY.mp3, New_York.mp3, alice@example.com.mp3, and Likes_hiking.mp3.

## Configuration

Set these required environment variables before execution.

Linux / macOS:

```sh
export ELEVENLABS_API_KEY="your_api_key"
export ELEVENLABS_API_VOICE="your_voice_id"
export ELEVENLABS_API_MODEL_ID="your_model_id"
```

Windows PowerShell:

```powershell
$env:ELEVENLABS_API_KEY="your_api_key"
$env:ELEVENLABS_API_VOICE="your_voice_id"
$env:ELEVENLABS_API_MODEL_ID="your_model_id"
```

## License

Apache License 2.0 

## Contributing

Contributions are welcome! Please open an issue or submit a pull request.

