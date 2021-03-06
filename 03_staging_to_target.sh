#!/bin/bash
workingfolder=$1
if [ -z "$workingfolder" ]; then
	workingfolder=$(pwd)
fi
targetfolder="$workingfolder/target"
stagingfolder="$workingfolder/staging"
mapfile="$workingfolder/svn.map"
authorsfile="$workingfolder/authors.txt"

printf "
==============================================
= Create/update Git subtrees from staging Git repos.
= Working: $workingfolder
= Target : $targetfolder
= Staging: $stagingfolder
= SCM Map: $mapfile
= Authors: $authorsfile
==============================================\n"


if [ -z "$stagingfolder"]; then
	printf "Staging folder is required.\n"
	exit 1	
fi
if [ -z "$targetfolder"]; then
	printf "Target folder is required.\n"
	exit 1	
fi
if [ ! -f "$mapfile" ]; then
	printf "SVN/Mercurial map file is required. $mapfile\n"
	exit 1
fi

initial_import=true
while read folder svn; do
	printf "
==================================\n
= Processing: $folder\n
==================================\n"
	if [ -d "$targetfolder/source/$folder" ]; then
		printf "Pulling subtree changes from original repo.\n"
		initial_import=false
		cd $targetfolder
		git subtree pull --prefix=source/$folder $workingfolder/$stagingfolder/$folder/ master
		cd $workingfolder
	else
		printf "Adding subtree from original repo.\n"
		cd $targetfolder
		git subtree add --prefix=source/$folder $workingfolder/$stagingfolder/$folder/ master
		cd $workingfolder
	fi
done < "$mapfile"

if [ "$initial_import" = true ] ; then
	sleep 2
	cd $targetfolder
	git status
	git tag -m 'Original SVN/Mercurial Import' svn-import
	cd $workingfolder
fi


printf "Finished\n"

