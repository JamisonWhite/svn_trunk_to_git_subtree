svn\_trunk\_to\_git\_subtree
========================

Migrate multiple SVN repo trunks to a single Git repo using subtrees.

These bash scripts are intended to migrate multiple SVN trunk folders into a single Git repo. 
They support one-way creation and update operations. Because SVN branch and tag folders are ignored these scripts can be used on SVN servers that contain multiple projects with each containing its own trunk, branch, and tag folders.

##Environment

For my testing I used Git-Bash on a Windows 8 machine. 

##Inputs
By default the scripts will create a *working* folder in the current folder. 
This folder is ignored in our .gitignore file. All SVN repos will be impored 
to a *svn\_import* branch.

###working folder
Optional command line argument for all the scripts. If not specified then the current folder will be used.

###svn.map
Required tab separated file containing the target folder name and the SVN trunk URL.

###authors.txt
Required git authors file formatted as:
svn\_author\_username = git\_author\_name <git\_email>

###.gitignore
Optional .gitignore file to be copied to the target repo.


##Scripts
Each script has an example using the included sample working folder. The working folder has the inputs to migrate the Apache log4j, log4net, and log4php SVN trunks into a single Git repo. __Beware these SVN repos are huge and require XXX hours to process. I do not recommend executing the examples.__

###01\_init\_target\_repo.sh [working folder]
- Create the target folder 
- Initialize the Git repo

Example:

    $ 01_init_target_repo.sh ~/Documents/GitHub/svn_trunk_to_git_subtree/sample_working


###02\_svn\_to\_staging.sh [working folder]
- Use "git svn clone" to create a new Git repo for each SVN trunk. __This step is very slow especially for the sample.__ 
- Use "git svn rebase" to update an already created Git repo.

Example:

    $ 02_svn_to_staging.sh ~/Documents/GitHub/svn_trunk_to_git_subtree/sample_working


###03\_staging\_to\_target.sh [working folder]
- Use "git subtree add" to add the folder to the target Git repo.
- Use "git subtree pull" to update an already created Git repo folder.

Example:

    $ 03_staging_to_target.sh ~/Documents/GitHub/svn_trunk_to_git_subtree/sample_working


##Future
- Find smaller, public SVN repos to use for the examples.
- Add push to Git remote
- Add two-way updates
