# Is simple application to get branch to print in command line in differnet colors
# to simple identification to humans
RED="\033[0;31m"
YELLOW="\033[0;33m"
PURPLE="\033[0;35m"
GREEN="\033[0;32m"
BLUE="\033[0;34m"
RESET="\033[0m"

MASTER=$PURPLE
DEVELOP=$GREEN
BRANCH=$BLUE

MODIFICATIONS=$RED
UNTRACKED=$YELLOW

# return is the element to set color, 
# 1 = is modifications
# 2 = is only untracked files
# 3 = is not differences 
function getChanges () {

	changes=$(git status 2>/dev/null)
	changes=$(echo $changes)
	modifieds="modified:"
	added="modified:"
	deleted="modified:"
	untracked="Untracked files:"
	if [[ $changes =~ $modifieds ]]; then
		_branchType=1
	elif [[ $changes =~ $added ]]; then
		_branchType=1
	elif [[ $changes =~ $deleted ]]; then
		_branchType=1
	elif [[ $changes =~ $untracked ]]; then
		_branchType=2
	else 
		_branchType=3
	fi
}

function getBranch () {
	# Get branch informations if the repository  has .git
	branch=$(git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ \1/')
	# Clear the new line and other unused informations in line 
	branch=$(echo $branch)
	# Define the show in command line in case of repository not has .git
	___getbranch=''

	if [[ $branch == "master" ]]; then
		color=$MASTER
	elif [[ $branch == "develop" ]]; then
		color=$DEVELOP
	else
		color=$BRANCH
	fi
	getChanges

	# Overwrite the colors in case of modifications in files or files untracked in project
	if [[ $_branchType == 1 ]]; then
		branchColor=$MODIFICATIONS
	elif [[ $_branchType == 2 ]]; then
		branchColor=$UNTRACKED
	else
		branchColor=$color
	fi
	
	if [[ -n $branch ]]; then
		___getbranch=" [ $branch ]"
	fi

	echo "$___getbranch" 2>/dev/null
}

export PS1="\w\$(getBranch) \$ "