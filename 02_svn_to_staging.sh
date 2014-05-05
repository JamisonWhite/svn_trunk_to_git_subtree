#!/bin/bash
workingfolder=$1
if [ -z "$workingfolder" ]; then
	workingfolder=$(pwd)
fi
stagingfolder="$workingfolder/staging"
mapfile="$workingfolder/svn.map"
authorsfile="$workingfolder/authors.txt"

printf "
==============================================
= Migrate/update SVN repos to staging Git repos.
= Working: $workingfolder
= Staging: $stagingfolder
= SVN Map: $mapfile
= Authors: $authorsfile
==============================================\n"

#check required files
if [ -z "$stagingfolder" ]; then
	printf "Staging folder is required.\n"
	exit 1	
fi
if [ ! -f "$mapfile" ]; then
	printf "SVN map file is required. $mapfile\n"
	exit 1
fi
if [ ! -f "$authorsfile" ]; then
	printf "Authors map file is required. $authorsfile\n"
	exit 1
fi

#setup working folder
cd $workingfolder
if [ ! -d "$stagingfolder" ]; then
	printf "Creating staging folder. $stagingfolder\n"
	mkdir $stagingfolder
fi
cp -u $authorsfile $stagingfolder/authors.txt

#process SVN map file
while read folder svn; do
	printf "
==================================\n
= Processing: $folder\n
==================================\n"
	if [ -d "$stagingfolder/$folder" ]; then
		printf "Updating Git repo from SVN $svn\n"
		#optional: if you need to reset the authorsfile setting
		#sed -i 's/authorsfile = .*/authorsfile = ..\/authors.txt/g' $stagingfolder/$folder/.git/config
		cd $stagingfolder/$folder
		git svn rebase
		cd $workingfolder
	else
		printf "Creating Git repo from SVN $svn\n"
		git svn clone $svn $stagingfolder/$folder --no-minimize-url -A $authorsfile
		#replace the absolute path with a relative path
		sed -i 's/authorsfile = .*/authorsfile = ..\/authors.txt/g' $stagingfolder/$folder/.git/config
	fi
	printf "\n"
done < "$mapfile"

printf "Finished\n"
