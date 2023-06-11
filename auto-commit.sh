#!/bin/bash

# TODO Added following line to cron -e
# */30 * * * * cd $PATH_TO_FOLDER && $PATH_TO_FOLDER/auto-commit/auto-commit.sh

# Get the directory of the current script
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

source "$DIR/ai-git-commit-message.sh"

# You can call the script with a directory path as an argument like this:
# ./auto-commit.sh /path/to/your/directory
cd "$1"

function commit() {
    modified=$1
    untracked=$2

    untracked=$(git ls-files --others --exclude-standard)
    modified=$(git diff --name-only)

    if gitmessage=$(generate_git_message $untracked $modified); then
        echo "Commit message generated successfully."
    else

        echo "Generating commit message failed. Using alternative approach."
        exit 1

        if [ -n "$untracked" ] && [ -n "$modified" ]; then
            gitmessage="Autocommit: Added notes on $untracked. Modified notes $modified."
        elif [ -z "$untracked" ] && [ -n "$modified" ]; then
            gitmessage="Autocommit: Modified $modified."
        elif [ -n "$untracked" ] && [ -z "$modified" ]; then
            gitmessage="Autocommit: Added notes on $untracked."
        fi
    fi

    # Add all changes
    git add .
    # Commit with the generated message
    git commit -m "$gitmessage"
    # Push to remote repository
    git push
}


# Function to automatically commit changes to a git repository
function auto_commit() {
    # Print the received argument
    echo "Received argument $1"

    LINES_TRIGGER=0

    # Get the list of modified files
    modified=$(git status | awk '/modified:/ { print $2 }')

    # Get the list of untracked files
    untracked=$(git status --porcelain | awk '/^\?\?/ { print $2 }')

    # Get the number of changed lines
    insertions=$(git diff --stat | tail | grep -o "[0-9]* insertion" | grep -o "[0-9]*")
    deletions=$(git diff --stat | tail | grep -o "[0-9]* deletions" | grep -o "[0-9]*")

    if [ -z "$deletions" ]; then
        deletions=0
    fi

    if [ -z "$insertions" ]; then
        deletions=0
    fi

    total=$(($insertions + $deletions))

    if [ $total -ge $LINES_TRIGGER ]; then
        commit $modified $untracked
    else
        echo "No commit necessary since only $total lines of code changed"
    fi 

    echo $gitmessage
}

# Call the function with no arguments
auto_commit
