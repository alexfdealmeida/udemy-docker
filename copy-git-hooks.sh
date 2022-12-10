#!/bin/bash

vRepositoryGitHooks="git-hooks"
vOrganizationName="alexfdealmeida"
vRepositoryName="$(basename -s .git `git config --local --get remote.origin.url`)"
vScriptSubmodulesUpdate="git-submodules-update.sh"
vScriptCopyGitHooksOrganization="$vRepositoryGitHooks/scripts/shell/github/$vOrganizationName/copy-git-hooks.sh"

if [ -d $vRepositoryGitHooks/ ]; then
	if [ "$1" != "--no-update-submodules" ]; then
		if [ "$1" == "--update-only-git-hooks" ]; then
			./$vScriptSubmodulesUpdate --update-only-git-hooks
		else
			./$vScriptSubmodulesUpdate
		fi
	fi

	if [ -f ".git" ]; then
		vGitdirSubmodule="$(cat .git | sed "s/gitdir://g" | sed "s/ //g")"
	else
		vGitdirSubmodule=""
	fi

	if [ -f $vScriptCopyGitHooksOrganization ]; then
		./$vScriptCopyGitHooksOrganization "$vGitdirSubmodule"
	else
		echo "Nao foi possivel localizar o script $vScriptCopyGitHooksOrganization"
	fi
fi