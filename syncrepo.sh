#!/bin/bash
git config --global credential.useHttpPath true

echo "Creating empty folder for $1..."
rm -rf $1
mkdir $1
cd $1 || { exit 1; }

echo "Cloning $1 from $3..."
git clone $3 . || { exit 1; }

echo "Adding second remote as $4..."
git remote add origin2 $4 || { exit 1; }

echo "Switching to branch $2..."
git switch $2 || { exit 1; }

echo "Pull $2 from $3..."
git pull origin $2 || { exit 1; }

echo "Pull $2 from $4..."
git pull origin2 $2 || { exit 1; }

echo "Push $2 from $3..."
git push origin $2 || { exit 1; }

echo "Push $2 from $4..."
git push origin2 $2 || { exit 1; }