#! /bin/sh
#
# Run the command line to run all functions and view result

source getbranch.sh
echo "The result of getbranch is: $(getBranch)"
echo "The result of printBranch is: $(printBranch)"
echo "The result of getChanges is: $(printChanges)"
# echo "The result of exportToPS1 is: $(exportToPS1)"

exit 0