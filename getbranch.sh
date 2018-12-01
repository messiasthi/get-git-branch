# Is simple application to get branch to print in command line
# to simple identification to humans
MASTER="!"
DEVELOP="@"
ADDED="+"
DELETED="-"
MODIFICATIONS="*"
UNTRACKED="?"
NO_DIFFERENCES="="

# Change the symbol to show in command line
function getChanges () {
	changes=$(git status 2>/dev/null)
	changes=$(echo $changes)
	added="new file:"
	deleted="deleted:"
	modifieds="modified:"
	untracked="Untracked files:"
	_changeType=""

	if [[ $changes =~ $added ]]; then
		_changeType="$_changeType$ADDED"
	fi

	if [[ $changes =~ $deleted ]]; then
		_changeType="$_changeType$DELETED"
	fi

	if [[ $changes =~ $modifieds ]]; then
		_changeType="$_changeType$MODIFICATIONS"
	fi

	if [[ $changes =~ $untracked ]]; then
		_changeType="$_changeType$UNTRACKED"
	fi

	if [[ -z $_changeType ]]; then
		_changeType=$NO_DIFFERENCES
	fi
}

# Return change type to tests
function printChanges () {
	getChanges
	echo "$_changeType" 2>/dev/null
}

# Get get remote information
function getRemote () {
	echo $(git remote 2>/dev/null)
}

# Get branch informations if the repository  has .git
function getBranch () {
	branch=$(git branch 2>/dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ \1/')
	branch=$(echo $branch)
	echo "$branch" 2>/dev/null
}

# Define the show in command line in case of repository not has .git
function printBranch () {
	getChanges
	___getbranch=' '
	branch=$(getBranch)

	if [[ $_changeType == $NO_DIFFERENCES ]]; then
		if [[ $branch == "master" ]]; then
			_changeType=$MASTER
		elif [[ $branch == "develop" ]]; then
			_changeType=$DEVELOP
		fi
	fi

	if [[ -n $branch ]]; then
		___getbranch=" [$branch] ($_changeType) "
	fi

	echo "$___getbranch" 2>/dev/null
}

# Export PS1, WARNING: Just put the \$(printBranch) in this mode on your profile
export PS1="\w\$(printBranch)$ "

function gpull () {
  if [[ $1 == "-all" ]]; then
    gpullAll
  else
    git fetch
    git pull $(getRemote) $(getBranch)
  fi
}

function gpush () {
	git push $(getRemote) $(getBranch)
}

function gpullAll () {
  for dir in *; do
   if [[ -d $dir ]]; then
     echo "git pull in $dir"
     cd $dir; gpull; cd ..
   fi
  done
}
