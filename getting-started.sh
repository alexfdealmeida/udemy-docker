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

cFileGitModules=".gitmodules"

vScriptName="$(basename "$0")"
vPrefixGettingStarted="[$vScriptName]"

vScriptGitSubmodulesInit="git-submodules-init.sh"
vScriptGitSubmodulesUpdate="git-submodules-update.sh"
vScriptCopyGitHooks="copy-git-hooks.sh"

if [ -f $vScriptGitSubmodulesInit ]; then
	echo "$vPrefixGettingStarted $vScriptGitSubmodulesInit"
	chmod +x $vScriptGitSubmodulesInit
	./$vScriptGitSubmodulesInit
	echo ""
fi

if [ -f $vScriptCopyGitHooks ]; then
	echo "$vPrefixGettingStarted $vScriptCopyGitHooks"
	chmod +x $vScriptCopyGitHooks
	./$vScriptCopyGitHooks --no-update-submodules
	echo ""
fi

if [ -f $cFileGitModules ]; then
	echo "$vPrefixGettingStarted Executando o script '$vScriptName' nos submodules do diretorio '$($vCommandGit rev-parse --show-toplevel)'"
	$vCommandGit submodule foreach " 
		[ -f getting-started.sh ] && chmod +x getting-started.sh && ./getting-started.sh || echo O script getting-started.sh nao existe!>/dev/null
	"
	echo ""
fi

vCurrentBranch="$($vCommandGit branch --show-current)"

if [ -n "$vCurrentBranch" ]; then
	echo "$vPrefixGettingStarted Acionando o hook 'post-checkout', para posicionar nos branches correspondentes dos submodules"
	$vCommandGit checkout $vCurrentBranch

	echo "$vPrefixGettingStarted Puxando alteracoes nos submodules"
	chmod +x $vScriptGitSubmodulesUpdate
	./$vScriptGitSubmodulesUpdate
fi