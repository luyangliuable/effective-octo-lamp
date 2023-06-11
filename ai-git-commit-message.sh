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

    modifiedfiles=$(git status | awk '/modified:/ { print $2 }')

    modifiedfilechanges=$(git diff --unified=0 | tr -dc '[:alnum:][]()+-. \n')

    removedfiles=$(git status | awk '/deleted:/ { print $2 }')

    message="Write me a git commit message based on the following:\n\n\
Removed files:\n$removedfiles\n\n\
Newfilechanges: $new_file_contents\n\n\
File changes: $modifiedfiles \n\
$modifiedfilechanges"

    echo "$message"

#     python3 << END
# import json
# import requests

# content = """$message"""

# data = {
#     "model": "gpt-3.5-turbo",
#     "messages": [
#         {
#             "role": "user", 
#             "content": content
#         }
#     ]
# }

# headers = {
#     "Content-Type": "application/json",
#     "Authorization": "Bearer $OPENAI_API_KEY"
# }

# response = requests.post('https://api.openai.com/v1/chat/completions', headers=headers, data=json.dumps(data))

# # print(response.json())
# print(response.json()['choices'][0]['message'][ 'content' ])
# END
}

generate_git_message
