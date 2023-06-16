#!/bin/bash

function generate_git_message() {
    new_files_output=$(git ls-files --others --exclude-standard)

    new_files=()

    while IFS= read -r line; do
        new_files+=("$line")
    done <<< "$new_files_output"
    
    # Now loop over the array:
    new_file_contents=$(for file in "${new_files[@]}"; do
        if [[ -f $file ]]; then
            # Print the contents of the file
            echo "Content of ./$file:"
            cat "$file"
            echo "\n"
        fi
    done)

    modified_files=$(git status | awk '/modified:/ { print $2 }')

    modified_file_changes=$(git diff --unified=0 | tr -dc '[:alnum:][]()+-. \n')

    removed_files=$(git status | awk '/deleted:/ { print $2 }')

    message="
Write me a one line git commit message based on the following:

Removed files:
$removed_files

New file changes: 
$new_file_contents

File changes: 
$modified_files
$modified_file_changes"

    PYTHON_CMD=python3
    if ! command -v $PYTHON_CMD &> /dev/null; then
        PYTHON_CMD=python
        if ! command -v $PYTHON_CMD &> /dev/null && [ "$OS" == "Windows_NT" ]; then
            PYTHON_CMD="py -3"
            if ! command -v $PYTHON_CMD &> /dev/null; then
                PYTHON_CMD="py -2"
            fi
        fi
    fi

    $PYTHON_CMD << END
import json
import requests

content = """$message"""

data = {
    "model": "gpt-3.5-turbo-16k",
    "messages": [
        {
            "role": "user", 
            "content": content
        }
    ]
}

headers = {
    "Content-Type": "application/json",
    "Authorization": "Bearer $OPENAI_API_KEY"
}

response = requests.post('https://api.openai.com/v1/chat/completions', headers=headers, data=json.dumps(data))

# print(response.json())
print(response.json()['choices'][0]['message'][ 'content' ])
END
}

generate_git_message
