#!/bin/bash
git config --global credential.useHttpPath true
git config --global core.sshCommand 'ssh -o StrictHostKeyChecking=no'

## $1 = Repo name
## $2 = Branch name
## $3 = Origin1|SSH Private Key base 64 encoded (if applicable)
## $4 = Origin2|SSH Private Key base 64 encoded (if applicable)
reponame="$1"
branchname="$2"
origin1="$3"
origin2="$4"

echo "Creating empty folder for $reponame..."
rm -rf $reponame
mkdir $reponame
cd $reponame || { exit 1; }

if [[ "$origin1" == *"|"* ]]; then
    echo "SSH Key for Origin 1" 
    IFS='|'
    read -a strarr <<< "$origin1"
    echo "${strarr[1]}" | base64 -d > ~/.ssh/id_rsa1
    chmod 700 ~/.ssh/id_rsa1
    cat ~/.ssh/id_rsa1
    ssh-add ~/.ssh/id_rsa1
    origin1="${strarr[0]}"
fi

if [[ "$origin2" == *"|"* ]]; then
    echo "SSH Key for Origin 2"
    IFS='|'
    read -a strarr <<< "$origin2"
    echo "${strarr[1]}" | base64 -d > ~/.ssh/id_rsa2
    chmod 700 ~/.ssh/id_rsa2
    cat ~/.ssh/id_rsa2
    ssh-add ~/.ssh/id_rsa1
    origin2="${strarr[0]}"
fi

echo "Cloning $reponame from $origin1..."
git clone $origin1 . || { exit 1; }

echo "Adding second remote as $origin2..."
git remote add origin2 $origin2 || { exit 1; }

echo "Switching to branch $branchname..."
git switch $branchname || { exit 1; }

echo "Pull $branchname from $origin1..."
git pull origin $branchname || { exit 1; }

echo "Pull $branchname from $origin2..."
git pull origin2 $branchname || { exit 1; }

echo "Push $branchname from $origin1..."
git push origin $branchname || { exit 1; }

echo "Push $branchname from $origin2..."
git push origin2 $branchname || { exit 1; }