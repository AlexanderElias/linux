#!/bin/bash
#
#	Usage: sh git-fix-email.sh 'wrong_emai' 'new_email' 'new_name'
#

git filter-branch --env-filter '
WRONG_EMAIL=$1
NEW_NAME=$3
NEW_EMAIL=$2

if [ "$GIT_COMMITTER_EMAIL" = "$WRONG_EMAIL" ]
then
    export GIT_COMMITTER_NAME="$NEW_NAME"
    export GIT_COMMITTER_EMAIL="$NEW_EMAIL"
fi
if [ "$GIT_AUTHOR_EMAIL" = "$WRONG_EMAIL" ]
then
    export GIT_AUTHOR_NAME="$NEW_NAME"
    export GIT_AUTHOR_EMAIL="$NEW_EMAIL"
fi
' --tag-name-filter cat -- --branches --tags
