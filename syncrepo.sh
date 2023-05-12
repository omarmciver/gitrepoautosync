#!/bin/bash


for ARGUMENT in "$@"
do
   KEY=$(echo $ARGUMENT | cut -f1 -d=)
   KEY_LENGTH=${#KEY}
   VALUE="${ARGUMENT:$KEY_LENGTH+1}"
   export "$KEY"="$VALUE"
done

echo "===== Syncing $reponame ($branchname) between $origin1 and $origin2 ====="
# echo $sshkeybase64

git config --global credential.useHttpPath true
git config --global core.sshCommand 'ssh  -o StrictHostKeyChecking=no -oHostKeyAlgorithms=+ssh-rsa -oPubkeyAcceptedKeyTypes=+rsa-sha2-256,rsa-sha2-512'

if ! [ -z "${sshkeybase64}" ]; then
    eval `ssh-agent -s`
    echo "SSH Key provided..."
    mkdir ~/.ssh
    echo "${sshkeybase64}" | base64 -d > ~/.ssh/id_rsa || { exit 1; }
    echo "Setting SSH Key file permissions..."
    chmod 700 ~/.ssh/id_rsa || { exit 1; }
    echo "End of cert:"
    cat ~/.ssh/id_rsa | tr -d '\n' | rev | cut -c-100 | rev
    echo "Registering SSH Key..."
    ssh-add ~/.ssh/id_rsa || { exit 1; }
fi

echo "Creating empty folder for $reponame..."
rm -rf $reponame
mkdir $reponame
cd $reponame || { exit 1; }

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

echo "===== Completed sync of $reponame ($branchname) between $origin1 and $origin2 ====="