import requests
import os
import json

# Check if data.json exists
if os.path.exists('data.json'):
    with open('data.json', 'r') as f:
        data = json.load(f)
    repo_name = data['repo_name']
    repo_owner = data['repo_owner']
else:
    repo_name = input("Enter repository name: ")
    repo_owner = input("Enter repository owner: ")

    data = {
        'repo_name': repo_name,
        'repo_owner': repo_owner
    }
    with open('data.json', 'w') as f:
        json.dump(data, f)


base_url = "https://api.github.com"
pr_number = input('PR number (enter correct number for this to work.. or else whole github repo will get deleted.. hahahaha): ')

github_token = os.environ.get('GITHUB_SECRET_KEY')

headers = {
    "Authorization": f"token {github_token}",
    "Accept": "application/vnd.github.v3+json"
}

def delete_branch(branch_name):
    url = f"https://api.github.com/repos/{repo_owner}/{repo_name}/branches/{branch_name}"
    response = requests.get(url, auth=HTTPBasicAuth(repo_owner, github_token))

    if response.status_code == 200:
        print(f"Branch '{branch}' exists in the repository '{repo_owner}/{repo_name}'.")
    elif response.status_code == 404:
        print(f"Branch '{branch}' does not exist in the repository '{repo_owner}/{repo_name}'.")
        return False

    # Delete branch on GitHub
    url = f"{base_url}/repos/{repo_owner}/{repo_name}/git/refs/heads/{branch_name}"
    response = requests.delete(url, headers=headers)
    if response.status_code == 204:
        print(f"Branch '{branch_name}' deleted successfully on GitHub.")
    else:
        print(f"Failed to delete branch '{branch_name}' on GitHub. Status code: {response.status_code} Possiblem branch could have already been deleted!")

def check_and_delete_branch(pr_number):
    # Get pull request details
    url = f"{base_url}/repos/{repo_owner}/{repo_name}/pull/{pr_number}"
    response = requests.get(url, headers=headers)
    if response.status_code == 200:
        pr_data = response.json()
        if pr_data["merged"]:
            branch_name = pr_data["head"]["ref"]
            delete_branch(branch_name)
        else:
            print(f"Pull request #{pr_number} is not merged yet. No action taken.")
    else:
        print(f"Failed to retrieve pull request #{pr_number}. Status code: {response.status_code}")

if __name__ == "__main__":
    check_and_delete_branch(pr_number)


