#!/usr/bin/env bash

UPSTREAM=origin

# This script is executed from the GIT_DIR in a bare repository or a 

# Stop the script if something goes wrong instead of continuing past an error.
set -e

# head_commit is the most recent commit.
head_commit=$( git rev-parse HEAD )

full_branch=$( git symbolic-ref HEAD 2> /dev/null || echo "" )

# This would be the full branch if HEAD was not detached.
if [[ -z ${full_branch} ]]; then
  exit 0
fi

git_dir=$(git rev-parse --git-dir)
if [[ -d ${git_dir}/rebase-apply || -d ${git_dir}/rebase-merge ]]; then
  # We are in the middle of a merge or rebase
  exit 0
fi

branch_name=$(basename ${full_branch})

# Push. Add a `--force-with-lease` if you are prone to rewriting your history.
git push --repo=${UPSTREAM} ${branch_name}
