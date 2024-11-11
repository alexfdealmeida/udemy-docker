#!/bin/bash

ALERT="[alert]"
INFO="[info]"
ERROR="[ERROR]"
FILE_GIT_MODULES=".gitmodules"
SCRIPT_GIT_SUBMODULES_INIT="git-submodules-init.sh"
SCRIPT_GIT_SUBMODULES_UPDATE="git-submodules-update.sh"
SCRIPT_COPY_GIT_HOOKS="copy-git-hooks.sh"

vCommandGit="git"

vKernelRelease="$(uname -r)"
vKernelRelease=${vKernelRelease,,}

if [[ $vKernelRelease =~ "microsoft" ]] || [[ $vKernelRelease =~ "wsl" ]]; then
	cAliasGitExe="alias $vCommandGit='$vCommandGit.exe'"

	searchReturn="$(cat ~/.bashrc | grep -x -m 1 "$cAliasGitExe")"

	if [ "$searchReturn" == "$cAliasGitExe" ]; then
		vCommandGit+=".exe"
	fi
fi

vScriptName="$(basename "$0")"
vPrefixGettingStarted="[$vScriptName]"

if [ -f $SCRIPT_GIT_SUBMODULES_INIT ]; then
	echo "$vPrefixGettingStarted $SCRIPT_GIT_SUBMODULES_INIT"
	chmod +x $SCRIPT_GIT_SUBMODULES_INIT
	./$SCRIPT_GIT_SUBMODULES_INIT
fi

if [ -f $SCRIPT_GIT_SUBMODULES_UPDATE ]; then
	echo "$vPrefixGettingStarted $SCRIPT_GIT_SUBMODULES_UPDATE"
	chmod +x $SCRIPT_GIT_SUBMODULES_UPDATE
	./$SCRIPT_GIT_SUBMODULES_UPDATE
fi

if [ -f $SCRIPT_COPY_GIT_HOOKS ]; then
	echo "$vPrefixGettingStarted $SCRIPT_COPY_GIT_HOOKS"
	chmod +x $SCRIPT_COPY_GIT_HOOKS
	./$SCRIPT_COPY_GIT_HOOKS --no-update-submodules
fi

if [ -f $FILE_GIT_MODULES ]; then
	echo "$vPrefixGettingStarted Executando o script '$vScriptName' nos submodules do diretorio '$($vCommandGit rev-parse --show-toplevel)'"
	$vCommandGit submodule foreach " 
		[ -f getting-started.sh ] && chmod +x getting-started.sh && ./getting-started.sh || echo O script getting-started.sh nao existe!>/dev/null
	"
fi