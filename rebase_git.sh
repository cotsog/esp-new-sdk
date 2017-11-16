# remove all but the last commit
git checkout --orphan newBranch
# Add all files and commit them
git add -A
git commit -m "travis"
# Deletes the master branch
git branch -D master
# Rename the current branch to master
git branch -m master
# update remote repository
git push -f origin master
