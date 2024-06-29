#################
# Automatically adds all the files, commits them and pushes them to github repo. You need to initially configure it once
# Author: Anirudh
# Date: Jun 30 2024
#################

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

    python3 merge_and_delete.py

fi


echo "About to add files, commit, and push to GitHub repo"
read -p "Do you confirm? (Y/n) " confirmation


if [[ "$confirmation" = "Y" || "$confirmation" = "y" || -z "$confirmation" ]]; then
    git checkout -b "$branch"
    read -p "Enter the message for commit: " message
    git add .
    git commit -m "$message"
    git pull origin main --rebase
    git push -u origin "$branch"
    git checkout main
    git branch -d "$branch"
    echo "local branch deleted"

    echo "Pushed successfully"

else
    echo "Not pushing or committing anything. Exit"
fi

echo "Completed program"