#!/bin/bash

ALERT="[alert]"
INFO="[info]"
ERROR="[ERROR]"
FILE_GIT_MODULES=".gitmodules"

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

vCommandGitSubmoduleInit="$vCommandGit submodule init"
vCommandGitSubmoduleUpdate="$vCommandGit submodule update --remote"

changedGitmodules=false

pPAT="$1"

resetarGitmodules () {
	if [ "$changedGitmodules" = true ]; then
		echo "$INFO Resetando alteracoes no arquivo '$FILE_GIT_MODULES'"
		$vCommandGit -c core.hooksPath=/dev/null checkout $FILE_GIT_MODULES
	fi
}

if [ -f $FILE_GIT_MODULES ]; then
	urlSuperproject="$($vCommandGit config --local --get remote.origin.url)"

	if [[ "$urlSuperproject" =~ "git@" ]]; then
		# Nao foi possivel utilizar URL relativas (dinamicas em relacao ao protocolo utilizado no superprojeto). 
		# Pois, na Azure, ha uma quantidade diferente de niveis entre as URLs:
		# https: https://dev.azure.com/siagri-teste/simer/_git/simer
		# ssh: git@ssh.dev.azure.com:v3/siagri-teste/simer/simer
		echo "$INFO Substituindo o protocolo 'https' por 'ssh' nas URLs dos submodules"
		#sed -i 's/https:\/\//git@ssh./' $FILE_GIT_MODULES
		#sed -i 's/.com/.com:v3/' $FILE_GIT_MODULES
		sed -i 's/https:\/\/dev.azure.com/git@ssh.dev.azure.com:v3/' $FILE_GIT_MODULES
		sed -i 's/_git\///' $FILE_GIT_MODULES

		changedGitmodules=true

		$vCommandGit status --short
	elif [ -n "$pPAT" ]; then
		echo "$INFO Adicionando o PAT nas URLs dos submodules"
		sed -i -e "s/\(dev.azure.com\)/$pPAT@\1/" $FILE_GIT_MODULES

		changedGitmodules=true

		$vCommandGit status --short
	fi

	echo "$INFO Inicializando submodules: $vCommandGitSubmoduleInit"
	$vCommandGitSubmoduleInit

	if [ $? -ne 0 ]; then
		echo "$ALERT Nao foi possivel inicializar o(s) submodule(s)!"
	fi

	if [[ "$(cat $FILE_GIT_MODULES)" =~ "branch = ." ]]; then
		currentBranch="$($vCommandGit branch | grep ^* | sed "s/*//" | sed "s/ //")"

		if [[ "$currentBranch" =~ "(" ]]; then
			# Em se tratando de um submodule que eh filho de outro submodule, ao tentar fazer um
			# 'git submodule update' com o parametro '--remote', resulta no seguinte erro:
			# fatal: Submodule (frontVue/componentes-vuejs) branch configured to inherit branch from superproject, but the superproject is not on any branch
			# fatal: Needed a single revision
			# Ou seja, o intuito eh fazer o clone/update considerando o branch default, ao inves do branch corrente do superprojeto.
			# Obs.: Se remover o parametro '--remote', nao ocorreria o erro, porem, o update seria feito para o commit registrado no superprojeto (gitlink).
			echo "$INFO Branch corrente: $currentBranch"

			defaultBranch="$($vCommandGit remote show origin | grep "HEAD branch" | cut -d ':' -f 2 | sed 's/ //g')"

			if [ -n "$defaultBranch" ]; then
				echo "$INFO Substituindo a configuracao para rastrear o branch corrente do superprojeto 'branch = .' pelo branch default 'branch = $defaultBranch'"
				sed -i "s/branch = \./branch = $defaultBranch/g" $FILE_GIT_MODULES
			else
				echo "$INFO Removendo as linhas que contenham a configuracao para rastrear o branch do superprojeto: 'branch = .'"
				sed -i "/branch = \./d" $FILE_GIT_MODULES

				echo "$INFO Removendo as linhas que contenham a configuracao para atualizar com rebase: 'update = rebase'"
				sed -i "/update = rebase/d" $FILE_GIT_MODULES
			fi

			changedGitmodules=true

			$vCommandGit status --short
		fi
	fi

	echo "$INFO Clonando/Atualizando o(s) submodule(s): $vCommandGitSubmoduleUpdate"
	$vCommandGitSubmoduleUpdate

	if [ $? -ne 0 ]; then
		echo "$ERROR NAO foi possivel clonar/atualizar o(s) submodule(s)!"

		$vCommandGit submodule -q foreach "
			$vCommandGit rebase --abort > /dev/null 2>&1 || echo Nao ha um rebase em andamento! > /dev/null
		"
		$vCommandGit submodule -q foreach "
			$vCommandGit merge --abort > /dev/null 2>&1 || echo Nao ha um merge em andamento! > /dev/null
		"
	fi

	resetarGitmodules
fi