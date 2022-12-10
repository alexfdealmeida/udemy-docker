#!/bin/bash
vFileGitModules=".gitmodules"

if [ -f $vFileGitModules ]; then
	if [ "$1" = "--update-only-git-hooks" ]; then
		echo "Puxando alteracoes no submodule 'git-hooks'"
		#git submodule foreach --recursive 'repositoryName="$(basename -s .git `git config --local --get remote.origin.url`)"; [ "$repositoryName" = "git-hooks" ] && git pull --rebase || echo "Not updated."'
		#git submodule foreach --recursive 'repositoryName="$(basename $name)"; [ "$repositoryName" = "git-hooks" ] && git pull --rebase || echo "Not updated."'
		#git submodule foreach 'repositoryName="$name"; [ "$repositoryName" = "git-hooks" ] && git pull --rebase || echo "Not updated."'
		git submodule -q foreach "
			[ \$name = git-hooks ] && git pull --rebase || echo Skipped.>/dev/null
		"
	else
		echo "Puxando alteracoes nos submodules"
		git submodule foreach --recursive "
			git pull --rebase
		"
	fi
fi