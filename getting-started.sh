#!/bin/bash

cFileGitModules=".gitmodules"

vScriptName="$(basename "$0")"
vPrefixGettingStarted="[$vScriptName]"

vScriptGitSubmodulesInit="git-submodules-init.sh"
vScriptGitSubmodulesUpdate="git-submodules-update.sh"
vScriptNodeNpmInstall="node-npm-install.sh"
vScriptCopyGitHooks="copy-git-hooks.sh"

if [ -f $vScriptGitSubmodulesInit ]; then
	echo "$vPrefixGettingStarted $vScriptGitSubmodulesInit"
	./$vScriptGitSubmodulesInit
	echo ""
fi

if [ -f $vScriptNodeNpmInstall ]; then
	echo "$vPrefixGettingStarted $vScriptNodeNpmInstall"
	./$vScriptNodeNpmInstall
	echo ""
fi

if [ -f $vScriptCopyGitHooks ]; then
	echo "$vPrefixGettingStarted $vScriptCopyGitHooks"
	./$vScriptCopyGitHooks --no-update-submodules
	echo ""
fi

if [ -f $cFileGitModules ]; then
	echo "$vPrefixGettingStarted Executando o script '$vScriptName' nos submodules do diretorio '$(git rev-parse --show-toplevel)'"
	git submodule foreach " 
		[ -f getting-started.sh ] && ./getting-started.sh || echo O script getting-started.sh nao existe!>/dev/null
	"
	echo ""
fi

vCurrentBranch="$(git branch --show-current)"

if [ -n "$vCurrentBranch" ]; then
	echo "$vPrefixGettingStarted Acionando o hook 'post-checkout', para posicionar nos branches correspondentes dos submodules"
	git checkout $vCurrentBranch

	echo "$vPrefixGettingStarted Puxando alteracoes nos submodules"
	./$vScriptGitSubmodulesUpdate
fi