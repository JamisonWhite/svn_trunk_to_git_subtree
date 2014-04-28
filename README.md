svn\_trunk\_to\_git\_subtree
========================

Migrate multiple SVN repo trunks to a single Git repo using subtrees.

These bash scripts are intended to migrate multiple SVN trunk folders into a single Git repo. 
They support one-way creation and update operations. 

##Environment

For my testing I used Git-Bash on a Windows 8 machine. 

##Inputs
By default the scripts will create a *working* folder in the current folder. 
This folder is ignored in our .gitignore file. All SVN repos will be impored 
to a *svn\_import* branch.

###svn.map
Tab separated file containing the target folder name and the SVN trunk URL.

###authors.txt
Git authors file formatted as:
svn\_author\_username = git\_author\_name <git\_email>

###.gitignore
Git ignore to initialize the target with

##Scripts

###01\_init\_target\_repo.sh [working folder]
Create the target folder and initialize the Git repo.

###02\_svn\_to\_staging.sh [working folder]
Use "git svn clone" to create a new Git repo for each SVN trunk. 
Use "git svn rebase" to update an already created Git repo.

###03\_staging\_to\_target.sh [working folder]
Use "git subtree add" to add the folder to the target Git repo.
Use "git subtree pull" to update an already created Git repo folder.

##Example
A sample working folder has been included that will migrate the Apache log4j, log4net,
 and log4php SVN trunks into a single Git repo.

##Future
- Add push to Git remote
- Add two-way updates
