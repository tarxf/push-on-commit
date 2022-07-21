#!/usr/bin/env bash

# From: https://gist.github.com/asankah/a6263bbd6081bffd031ca066e5177df2

# This script is executed from the GIT_DIR in a bare repository or at the root
# of the work tree.

git_dir=$( git rev-parse --git-dir )
if [[ -d "${git_dir}/rebase-apply" || -d "${git_dir}/rebase-merge" ]]; then
  # We are in the middle of a merge or rebase. Wait until that's done. The final
  # commit -- if any -- would re-invoke this script.
  exit 0
fi

# Stop the script if something goes wrong instead of continuing past an error.
set -e

# head_commit is the most recent commit.
head_commit=$( git rev-parse HEAD )

full_branch=$( git symbolic-ref HEAD 2> /dev/null || echo "" )

# Detached head.
if [[ -z ${full_branch} ]]; then
  exit 0
fi

branch_name=$( basename ${full_branch} )

# If there is no upstream remote specified, then skip autopush. There are other
# kinds of upstreams that a branch can push to (see git-push(1)), but those are
# not supported for the moment.
upstream=$( git config branch.${branch_name}.remote 2> /dev/null || echo "" )
if [[ -z ${upstream} ]]; then
  exit 0
fi

# Push. Add a `--force-with-lease` if you are prone to rewriting your history.
# We've already verified that the branch has an upstream remote. git-push will
# pick that up by default along with the default refspec. No need to override
# either of those.
git push --force-with-lease