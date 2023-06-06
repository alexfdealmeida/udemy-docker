#!/bin/bash

vCommandGit="git"

vKernelRelease="$(uname -r)"
vKernelRelease=${vKernelRelease,,}

if [[ $vKernelRelease =~ "microsoft" ]] || [[ $vKernelRelease =~ "wsl" ]]; then
	cAliasGitExe="alias $vCommandGit='$vCommandGit.exe'"

	searchReturn="$(gsk_bashrc_list | grep -x -m 1 "$cAliasGitExe")"

	if [ "$searchReturn" == "$cAliasGitExe" ]; then
		vCommandGit+=".exe"
	fi
fi

vFileGitModules=".gitmodules"

if [ -f $vFileGitModules ]; then
	if [ "$1" = "--update-only-git-hooks" ]; then
		echo "Puxando alteracoes no submodule 'git-hooks'"
		#$vCommandGit submodule foreach --recursive 'repositoryName="$(basename -s .git `$vCommandGit config --local --get remote.origin.url`)"; [ "$repositoryName" = "git-hooks" ] && git pull --rebase || echo "Not updated."'
		#$vCommandGit submodule foreach --recursive 'repositoryName="$(basename $name)"; [ "$repositoryName" = "git-hooks" ] && $vCommandGit pull --rebase || echo "Not updated."'
		#$vCommandGit submodule foreach 'repositoryName="$name"; [ "$repositoryName" = "git-hooks" ] && $vCommandGit pull --rebase || echo "Not updated."'
		$vCommandGit submodule -q foreach "
			[ \$name = git-hooks ] && $vCommandGit pull --rebase || echo Skipped.>/dev/null
		"
	else
		echo "Puxando alteracoes nos submodules"
		$vCommandGit submodule foreach --recursive "
			$vCommandGit pull --rebase
		"
	fi
fi