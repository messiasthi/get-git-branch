# Is simple application to get branch to print in command line in differnet colors
# to simple identification to humans
RED="\033[0;31m"
YELLOW="\033[0;33m"
PURPLE="\033[0;35m"
GREEN="\033[0;32m"
BLUE="\033[0;34m"
RESET="\033[0m"

MASTER="!"
DEVELOP="@"
ADDED="+"
DELETED="-"
MODIFICATIONS="*"
UNTRACKED="?"
NO_DIFFERENCES="|"

# Change the symbol to show in command line
function getChanges () {

	changes=$(git status 2>/dev/null)
	changes=$(echo $changes)
	added="new file:"
	deleted="deleted:"
	modifieds="modified:"
	untracked="Untracked files:"


	if [[ $changes =~ $added ]]; then
		_changeType=$ADDED
	elif [[ $changes =~ $deleted ]]; then
		_changeType=$DELETED
	elif [[ $changes =~ $modifieds ]]; then
		_changeType=$MODIFICATIONS
	elif [[ $changes =~ $untracked ]]; then
		_changeType=$UNTRACKED
	else 
		_changeType=$NO_DIFFERENCES
	fi
}

function getBranch () {
	# Get branch informations if the repository  has .git
	branch=$(git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ \1/')
	branch=$(echo $branch)
	# Define the show in command line in case of repository not has .git
	___getbranch=''


	getChanges

	if [[ $_changeType == $NO_DIFFERENCES ]]; then
		if [[ $branch == "master" ]]; then
			_changeType=$MASTER
		elif [[ $branch == "develop" ]]; then
			_changeType=$DEVELOP
		fi
	fi
	
	if [[ -n $branch ]]; then
		___getbranch=" [ $branch ] ( $_changeType )"
	fi

	echo "$___getbranch" 2>/dev/null
}

export PS1="\w\$(getBranch) \$ "