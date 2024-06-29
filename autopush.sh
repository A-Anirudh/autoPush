#!/bin/bash

#################
# Automatically adds all the files, commits them and pushes them to github repo. YOu need to initially configure it once
# Author: Anirudh
# Date: Jun 30 2024
################

set -e
set -o pipefail
confirmation="Y"
echo "About to add files, commit and push to github repo"
read -p "Do you confirm? (Y/n)" confirmation

if [ "$confirmation"="Y" ] || [ "$confirmation"="y" ] || [ -z "$confirmation" ]; then
    read -p "Enter the message for commit" message
    git add .
    git commit -m "$message"
    git push

    echo "Pushed successfully"
else
    echo "Not pushing or commiting anything. Exit"
fi


echo "completed program"
