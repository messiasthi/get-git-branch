# Is simple application to get branch to print in command line
# to simple identification to humans

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

# Return change type to tests
function printChanges () {
	getChanges
	echo "$_changeType" 2> /dev/null
}

function getBranch () {
	# Get branch informations if the repository  has .git
	branch=$(git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ \1/')
	branch=$(echo $branch)
	echo "$branch" 2>/dev/null
}

function printBranch () {
	# Define the show in command line in case of repository not has .git
	___getbranch=''

	getChanges
	branch=$(getBranch)

	if [[ $_changeType == $NO_DIFFERENCES ]]; then
		if [[ $branch == "master" ]]; then
			_changeType=$MASTER
		elif [[ $branch == "develop" ]]; then
			_changeType=$DEVELOP
		fi
	fi

	if [[ -n $branch ]]; then
		___getbranch=" [ $branch ] ( $_changeType ) "
	fi

	echo "$___getbranch" 2>/dev/null
}

function exportToPS1 () {
	# Get the PS1 length
	ps1_=$((${#PS1}-2))

	# Get the end character of PS1
	end_ps1=${PS1:ps1_:1}

	# Get the start string of PS1
	start_ps1=${PS1:0:ps1_}

	# return value to export PS1
	$new_ps1="$start_ps1$(printBranch)$end_ps1 "
	echo "$new_ps1" 2> /dev/null
}
