#!/bin/bash
#######################
# Author: Anirudh
# TItle: Password Manager
# DEsc: YOu can add and view passwords
# Date: June 29 2024
#######################

set -e
set -o pipefail

file='passwords.txt'
response="Y"

if [ ! -e "$file" ]; then
    touch "$file"
fi


add_password() {
	read -p "Enter website name: " website
	read -s -p "Enter password: " password
	echo "$website password is $password"
	read -p "You want to continue? (Y/n)" response 
	if [ "$response" = "Y" ] || [ "$response" = "y" ] || [ -z "$response" ]; then
        	echo "$website : $password" >> "$file"
        	echo "Password added successfully!"
    	else
        	echo "Password not added."
    	fi


}

get_password(){
	read -p "Enter website password to fetch: " website
	password=$(awk -v site="$website" -F ' : ' '$1 == site {print $2}' "$file")
	if [ -z "$password" ]; then
		echo "Password for $website not found."
	else
    	echo "Password for $website: $password"
	fi
}



while true; do
    echo "------------------------"
    echo "Password Manager"
    echo "------------------------"
    echo "1. Add Password"
    echo "2. Get Password"
    echo "3. Exit"
    read -p "Choose an option: " choice

    case $choice in
        1)
            add_password
            ;;
        2)
            get_password
            ;;
        3)
            echo "Exiting Password Manager."
            exit 0
            ;;
        *)
            echo "Invalid option. Please choose again."
            ;;
    esac
done
