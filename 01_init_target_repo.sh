#!/bin/bash
workingfolder=$1
if [ -z "$workingfolder" ]; then
	workingfolder=$(pwd)
fi
targetfolder="$workingfolder/target"
gitignorefile="$workingfolder/.gitignore"


printf "
==============================================
= Migrate/update SVN/Mercurial repos to staging Git repos.
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
git checkout -b scm_import
mkdir source
mkdir docs
echo "#Importing SVN/Mercurial Trees" > README.md
if [ -f "$gitignorefile" ]; then
	cp $gitignorefile $targetfolder/
fi
git add .
git commit -m "Initialized folder"
cd $workingfolder


