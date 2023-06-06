#!/bin/bash

vFilePackageJson="package.json"

if [ -f $vFilePackageJson ]; then
	vCommandNpmInstall="npm ci"

	vKernelRelease="$(uname -r)"
	vKernelRelease=${vKernelRelease,,}

	if [[ $vKernelRelease =~ "microsoft" ]] || [[ $vKernelRelease =~ "wsl" ]]; then
		cAliasGitExe="alias git='git.exe'"

		searchReturn="$(gsk_bashrc_list | grep -x -m 1 "$cAliasGitExe")"

		if [ "$searchReturn" == "$cAliasGitExe" ]; then
			vCommandNpmInstall="cmd.exe /c $vCommandNpmInstall"
		fi
	fi

	searchNpm="$(type npm 2>&1)"

	if [ $? -eq 0 ]; then
		echo "Executando o comando '$vCommandNpmInstall'"
		$vCommandNpmInstall
	else
		echo "NAO foi possivel executar o comando: '$vCommandNpmInstall'!"
		echo "Pois, o comando 'npm' NAO foi localizado na variavel de ambiente 'PATH'."
	fi
fi