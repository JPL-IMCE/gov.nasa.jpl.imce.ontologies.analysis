#!/usr/bin/env bash

#
# gitBranch <dir>
#
# Returns the GIT branch name of the repo cloned in <dir>, or empty if none.
#
gitBranch() {
    if [ $# -eq 1 ]; then
       if (( $((${BRANCH:+1})) == 1 ));
       then
           echo ${BRANCH}
       else
            echo $(cd "$1"; git symbolic-ref --quiet --short HEAD 2> /dev/null)
       fi
    fi
}

#
# gitTag <dir>
#
# Returns the GIT tag name of the repo cloned in <dir>, or empty if none.
#
gitTag() {
    if [ $# -eq 1 ]; then
        echo $(cd "$1"; git describe --exact-match HEAD 2> /dev/null)
    fi
}

#
# gitCommit <dir>
#
# Returns the GIT commit SHA1 of the repo cloned in <dir>, or empty if none.
#
gitCommit() {
    if [ $# -eq 1 ]; then
        echo $(cd "$1"; git rev-parse --short HEAD 2> /dev/null)
    fi
}

#
# gitRemoteOriginURL <dir> <user> <pwd>
#
# Returns the URL, including credentials, of the remote from which this repo was cloned in <dir>, or empty if none.
# If <user> and <pwd> are empty, return just the URL.
#
gitRemoteOriginURL() {
    if [ $# -gt 0 ]; then
        URL=$(cd "$1"; git config --get remote.origin.url 2> /dev/null)
        if (( $((${GIT_USERNAME:+1})) == 1 && $((${GIT_PASSWORD:+1})) == 1 ));
        then
            echo "${URL/:\/\//://$GIT_USERNAME:$GIT_PASSWORD@}" 2> /dev/null
        else
            echo $URL
        fi
    fi
}

#
# gitRemoteBranchTest <dir> <branch>
#
# Tests whether there is a remote <branch> on the repo cloned at <dir>
#
gitRemoteBranchTest() {
    if [ $# -eq 2 ]; then
        URL=$(gitRemoteOriginURL "$1")
        ( cd "$1"; \
          git ls-remote --heads --exit-code $URL "$2" > /dev/null 2>&1 )
    fi
}

#
# gitCreateOrMergeBranch <dir> <branch>
#
# If the remote <branch> exists on the remote, then checkout <branch> & merge the current branch into it;
# otherwise, create <branch> from the current branch.
#
gitCreateOrMergeBranch() {
    if [ $# -eq 2 ]; then
        if [ -z $(gitRemoteBranchTest "$1" "$2") ]; then
            # branch exists, so merge to update it
            CURRENT_BRANCH=$(gitBranch "$1")
            ( cd "$1"; \
              git checkout "$2"; \
              git merge -m"gitCreateOrMergeBranch: merge $CURRENT_BRANCH into $2" "$CURRENT_BRANCH"; \
              git status )
        else
            # branch does not exist, so create it.
            ( cd "$1"; \
              git checkout -B "$2"; \
              git status )
        fi
    fi
}

#
# gitCaesarClone <url> <branch>
#
# Clones the CAESAR workflow repository from <url> and checkout <branch>.
#
gitCaesarClone() {
    if [ $# -eq 2 ]; then
        git clone \
            --recursive \
            -c core.notesRef=refs/notes/caesar \
            -c diff.zip.textconv='unzip -c -q' \
            -c remote.origin.fetch='+refs/notes/*:refs/notes/*' \
            -c remote.origin.push='+refs/notes/*:refs/notes/*' \
            -b "$2" \
            "$1"
    fi
}

#
# gitCaesarWorkflowAddCommitNoteAndPush <repo.dir> <workflow step name> <date> <metadata absolute path> <branch>
#
# GIT add everything in <repo.dir>, GIT commit, GIT notes add caesar <metadata>, GIT push
#
gitCaesarWorkflowAddCommitNoteAndPush() {
    if [ $# -eq 5 ]; then
        set -e
        set -v
        repo_dir="$1"
        name="$2"
        date="$3"
        metadata="$4"
        branch="$5"
        remoteOriginUrl="$(gitRemoteOriginURL $1)"

        (cd "$repo_dir"; \
        git add -A; \
        echo "# 1/4 added..."; \
        (git diff-index --quiet HEAD || git commit -S -m"Performed $name on $date"); \
        echo "# 2/4 committed..."; \
        git notes add -f -F $metadata; \
        echo "# 3/4 noted..."; \
        git push -u $remoteOriginUrl $branch; \
        echo "# 4/4 pushed."; \
        )
    fi
}