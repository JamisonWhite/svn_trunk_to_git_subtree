#!/bin/bash
workingfolder=$1
if [ -z "$workingfolder" ]; then
	workingfolder=$(pwd)
fi
stagingfolder="$workingfolder/staging"
mapfile="$workingfolder/scm.map"
authorsfile="$workingfolder/authors.txt"

printf "
==============================================
= Migrate/update Mercurial repos to staging Git repos.
- (Requires fast-export installed in home directory!)
= Working: $workingfolder
= Staging: $stagingfolder
= Hg Map : $mapfile
= Authors: $authorsfile
==============================================\n"

#check required files
if [ -z "$stagingfolder" ]; then
	printf "Staging folder is required.\n"
	exit 1	
fi
if [ ! -f "$mapfile" ]; then
	printf "Hg map file is required. $mapfile\n"
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

#process scm map file
while read folder scm; do
	printf "
==================================\n
= Processing: $folder\n
==================================\n"
	cd $stagingfolder/$folder
	if [ -d "$stagingfolder/$folder" ]; then
		printf "Updating Git repo from SCM $scm\n"
		~/fast-export/hg-reset.sh -r -1
	else
		prinf "Creating Git repo from SCM $scm\n"
		git init
		~/fast-export/hg-fast-export.sh -r -A $authorsfile $stagingfolder/$folder
		#replace the absolute path with a relative path
		sed -i 's/authorsfile = .*/authorsfile = ..\/authors.txt/g' $stagingfolder/$folder/.git/config		
	fi
	cd $workingfolder
	printf "\n"
done < "$mapfile"

printf "Finished\n"
