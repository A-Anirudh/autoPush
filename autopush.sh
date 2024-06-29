#################
# Automatically adds all the files, commits them and pushes them to github repo. You need to initially configure it once
# Author: Anirudh
# Date: Jun 30 2024
################

set -e
set -o pipefail

confirmation="Y"

read -p "Enter the branch you want to push to: " branch
if [ "$branch" = "main" ]; then
    echo "Cannot directly push to main branch. Please create a new branch to push"
    exit 1
fi

if git ls-remote --exit-code --heads origin "$branch" >/dev/null 2>&1; then
    git fetch origin

    if git branch --merged main | grep "$branch"; then
        git push origin --delete "$branch"
        echo "Branch '$branch' deleted successfully from remote repository."
    else
        echo "Branch '$branch' is not yet merged into main. No action taken. Cannot proceed without deleting that branch. Please merge it with main branch!"
        exit 1
    fi

fi


echo "About to add files, commit, and push to GitHub repo"
read -p "Do you confirm? (Y/n) " confirmation

git checkout -b "$branch"


if [[ "$confirmation" = "Y" || "$confirmation" = "y" || -z "$confirmation" ]]; then
    read -p "Enter the message for commit: " message
    git add .
    git commit -m "$message"
    git pull origin main --rebase
    git push -u origin "$branch"
    git branch -d "$branch"

    echo "Pushed successfully"
else
    echo "Not pushing or committing anything. Exit"
fi

echo "Completed program"