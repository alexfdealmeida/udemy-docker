#!/bin/bash

vFileGitModules=".gitmodules"
vCommandGitSubmoduleInit="git submodule init"
vCommandGitSubmoduleUpdate="git submodule update --remote"

changedGitmodules=false

pPAT="$1"

function resetarGitmodules () {
	if [ "$changedGitmodules" = true ]; then
		echo "Resetando alteracoes no arquivo '$vFileGitModules'"
		git -c core.hooksPath=/dev/null checkout $vFileGitModules
	fi
}

if [ -f $vFileGitModules ]; then
	urlSuperproject="$(git config --local --get remote.origin.url)"

	if [[ "$urlSuperproject" =~ "git@" ]]; then
		# Nao foi possivel utilizar URL relativas (dinamicas em relacao ao protocolo utilizado no superprojeto). 
		# Pois, na Azure, ha uma quantidade diferente de niveis entre as URLs:
		# https: https://dev.azure.com/siagri-teste/simer/_git/simer
		# ssh: git@ssh.dev.azure.com:v3/siagri-teste/simer/simer
		echo "Substituindo o protocolo 'https' por 'ssh' nas URLs dos submodules"
		#sed -i 's/https:\/\//git@ssh./' $vFileGitModules
		#sed -i 's/.com/.com:v3/' $vFileGitModules
		sed -i 's/https:\/\/dev.azure.com/git@ssh.dev.azure.com:v3/' $vFileGitModules
		sed -i 's/_git\///' $vFileGitModules

		changedGitmodules=true

		git status --short
	elif [ -n "$pPAT" ]; then
		echo "Adicionando o PAT nas URLs dos submodules"
		sed -i -e "s/\(dev.azure.com\)/$pPAT@\1/" $vFileGitModules

		changedGitmodules=true

		git status --short
	fi

	echo "Inicializando submodules: $vCommandGitSubmoduleInit"
	$vCommandGitSubmoduleInit

	if [ "$?" -ne "0" ]; then
		echo "Nao foi possivel inicializar o(s) submodule(s)!"
	fi

	if [[ "$(cat $vFileGitModules)" =~ "branch = ." ]]; then
		currentBranch="$(git branch | grep ^* | sed "s/*//" | sed "s/ //")"

		if [[ "$currentBranch" =~ "(" ]]; then
			# Em se tratando de um submodule que eh filho de outro submodule, ao tentar fazer um
			# 'git submodule update' com o parametro '--remote', resulta no seguinte erro:
			# fatal: Submodule (frontVue/componentes-vuejs) branch configured to inherit branch from superproject, but the superproject is not on any branch
			# fatal: Needed a single revision
			# Ou seja, o intuito eh fazer o clone/update considerando o branch default, ao inves do branch corrente do superprojeto.
			# Obs.: Se remover o parametro '--remote', nao ocorreria o erro, porem, o update seria feito para o commit registrado no superprojeto (gitlink).
			echo "Branch corrente: $currentBranch"

			defaultBranch="$(git remote show origin | grep "HEAD branch" | cut -d ':' -f 2 | sed 's/ //g')"

			if [ -n "$defaultBranch" ]; then
				echo "Substituindo a configuracao para rastrear o branch corrente do superprojeto 'branch = .' pelo branch default 'branch = $defaultBranch'"
				sed -i "s/branch = \./branch = $defaultBranch/g" $vFileGitModules
			else
				echo "Removendo as linhas que contenham a configuracao para rastrear o branch do superprojeto: 'branch = .'"
				sed -i "/branch = \./d" $vFileGitModules

				echo "Removendo as linhas que contenham a configuracao para atualizar com rebase: 'update = rebase'"
				sed -i "/update = rebase/d" $vFileGitModules
			fi

			changedGitmodules=true

			git status --short
		fi
	fi

	echo "Clonando/Atualizando o(s) submodule(s): $vCommandGitSubmoduleUpdate"
	$vCommandGitSubmoduleUpdate

	if [ "$?" -ne "0" ]; then
		#resetarGitmodules

		echo "NAO foi possivel clonar/atualizar o(s) submodule(s)!"

		git submodule -q foreach "
			git rebase --abort > /dev/null 2>&1 || echo Nao ha um rebase em andamento! > /dev/null
		"
		git submodule -q foreach "
			git merge --abort > /dev/null 2>&1 || echo Nao ha um merge em andamento! > /dev/null
		"
	fi

	resetarGitmodules
fi