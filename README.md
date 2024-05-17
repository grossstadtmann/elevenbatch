# elevenbatch
![GitHub last commit](https://img.shields.io/github/last-commit/grossstadtmann/elevenbatch?style=flat)
![Static Badge](https://img.shields.io/badge/elevenlabs-.io-blue?style=flat&link=https%3A%2F%2Felevenlabs.io%2F%3Ffrom%3Dpartnerkhan1060)
![Static Badge](https://img.shields.io/badge/Buy_Me_a_Coffee_at-ko--fi.com-blue?style=flat&logo=kofi&link=https%3A%2F%2Fko-fi.com%2Fgrossstadtmann)

elevenbatch is a shell and powershell script collection for batch processing text-to-speech conversions using the ElevenLabs Text-to-Speech API. The script reads a CSV file, extracts specified columns, and converts each value into an MP3 file using the API.

If you like you can support my work by buying me a Coffee via ko-fi.com

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
- ElevenLabs Subscription to create an API key -> support me via that [Link](elevenlabs.io/?from=partnerkhan1060)
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

## Usage

```sh
./elevenbatch.sh <csv_file> <columns>
```

- `<csv_file>`: Path to the CSV file to be processed.  
- `<columns>`: Comma-separated list of column indices to be processed (0-based).

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
./print_csv.sh data.csv 0,1,5,6,9,10
```
3. The script will generate MP3 files for the specified columns, e.g., Alice.mp3, 30.mp3, NY.mp3, New_York.mp3, alice@example.com.mp3, and Likes_hiking.mp3.

## Configuration

Replace YOUR_API_* Values in the script with your actual ElevenLabs API key:

```sh
API_KEY="YOUR_API_KEY"
API_VOICE="YOUR_API_VOICE"
API_MODEL_ID="YOUR_API_MODEL_ID"
```

## License

Apache License 2.0 

## Contributing

Contributions are welcome! Please open an issue or submit a pull request.

