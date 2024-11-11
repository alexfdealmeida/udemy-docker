#!/bin/bash

ALERT="[alert]"
INFO="[info]"
ERROR="[ERROR]"
REPOSITORY_GIT_HOOKS="git-hooks"
SCRIPT_GIT_SUBMODULES_UPDATE="git-submodules-update.sh"
SCRIPT_COPY_GIT_HOOKS="$REPOSITORY_GIT_HOOKS/scripts/shell/github/alexfdealmeida/copy-git-hooks.sh"

if [ -d $REPOSITORY_GIT_HOOKS/ ]; then
	if [ "$1" != "--no-update-submodules" ]; then
		chmod +x $SCRIPT_GIT_SUBMODULES_UPDATE

		if [ "$1" == "--update-only-git-hooks" ]; then
			./$SCRIPT_GIT_SUBMODULES_UPDATE --update-only-git-hooks
		else
			./$SCRIPT_GIT_SUBMODULES_UPDATE
		fi
	fi

	if [ -f ".git" ]; then
		vGitdirSubmodule="$(cat .git | sed "s/gitdir://g" | sed "s/ //g")"
	else
		vGitdirSubmodule=""
	fi

	if [ -f $SCRIPT_COPY_GIT_HOOKS ]; then
		chmod +x $SCRIPT_COPY_GIT_HOOKS

		./$SCRIPT_COPY_GIT_HOOKS "$vGitdirSubmodule"
	else
		echo "$ALERT Nao foi possivel localizar o script $SCRIPT_COPY_GIT_HOOKS"
	fi
fi