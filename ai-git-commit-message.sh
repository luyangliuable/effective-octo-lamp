function generate_git_message() {
    modifiedfiles=$(git status | awk '/modified:/ { print $2 }')

    changes=$(git diff | tr -dc '[:alnum:][]() \n')

    message="Write me a git commit message based on the following:\n\n File change: $modifiedfiles \n$changes"

    python << END
import json
import requests

content = """$message"""

data = {
    "model": "gpt-3.5-turbo",
    "messages": [
        {
            "role": "user", 
            "content": content
        }
    ]
}

print(content);

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