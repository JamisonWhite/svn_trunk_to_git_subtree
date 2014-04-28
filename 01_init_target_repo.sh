#!/bin/bash
workingfolder=$(pwd)
targetfolder="$workingfolder/target"
gitignorefile="$workingfolder/.gitignore"


printf "
==============================================
= Migrate/update SVN repos to staging Git repos.
= Working: $workingfolder
= Target : $targetfolder
= GitIgnore : $gitignorefile
==============================================\n"

if [ -d "$targetfolder" ]; then
	printf "Target folder already exists. $targetfolder\n"
	exit
fi

#Create folder and init Git
printf "Creating target folder. $targetfolder\n"
mkdir $targetfolder
cd $targetfolder
git init
git checkout -b svn_import
mkdir source
mkdir docs
echo "#Importing SVN Trees" > README.md
cp $gitignorefile $targetfolder/
git add .
git commit -m "Initialized folder"
cd $workingfolder


