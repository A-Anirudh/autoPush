#################
# Automatically adds all the files, commits them and pushes them to github repo. You need to initially configure it once
# Author: Anirudh
# Date: Jun 30 2024
################

set -e
set -o pipefail

confirmation="Y"

read -p "Enter the branch you want to push to: " branch
echo "About to add files, commit, and push to GitHub repo"
read -p "Do you confirm? (Y/n) " confirmation

git checkout "$branch"


if [[ "$confirmation" = "Y" || "$confirmation" = "y" || -z "$confirmation" ]]; then
    read -p "Enter the message for commit: " message
    git add .
    git commit -m "$message"
    git pull origin main --rebase
    git push -u origin "$branch"

    echo "Pushed successfully"
else
    echo "Not pushing or committing anything. Exit"
fi

echo "Completed program"