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

COMMAND_GIT_BRANCH="$vCommandGit branch"
COMMAND_GIT_CONFIG="$vCommandGit config"
COMMAND_GIT_STATUS="$vCommandGit status"

if [ -f $FILE_GIT_MODULES ]; then
	if [ "$1" = "--update-only-git-hooks" ]; then
		echo "$INFO Checking out and updating submodules (only git-hooks)"
		$vCommandGit submodule -q foreach "
			if [ \$name = git-hooks ]; then
				branchSubmodule=\$($COMMAND_GIT_CONFIG -f \$toplevel/.gitmodules submodule.\$name.branch);

				currentBranch=\$($COMMAND_GIT_BRANCH --show-current);

				if [ \"\$branchSubmodule\" = \".\" ]; then 
					cd \$toplevel;
					branchSuperproject=\$($COMMAND_GIT_BRANCH --show-current);
					cd \$sm_path;

					if [ \"\$branchSuperproject\" != \"\$currentBranch\" ]; then
						$vCommandGit -c core.hooksPath=/dev/null checkout \$branchSuperproject || ( echo $ERROR Nao foi possivel posicionar no branch \$branchSuperproject no submodule \$sm_path! && exit 1 );
					fi;

					$vCommandGit pull origin \$branchSuperproject --rebase || $COMMAND_GIT_STATUS;
				elif [ -n \"\$branchSubmodule\" ]; then
					if [ \"\$branchSubmodule\" != \"\$currentBranch\" ]; then
						$vCommandGit -c core.hooksPath=/dev/null checkout \$branchSubmodule || ( echo $ERROR Nao foi possivel posicionar no branch \$branchSubmodule no submodule \$sm_path! && exit 1 );
					fi;

					$vCommandGit pull origin \$branchSubmodule --rebase || $COMMAND_GIT_STATUS;
				else
					( echo $ERROR Nao foi possivel posicionar no branch correspondente no submodule \$sm_path, pois o branch nao foi especificado no arquivo .gitmodules do superprojeto! && exit 1 );
				fi;
			fi;
		"
	else
		echo "$INFO Checking out and updating submodules"
		$vCommandGit submodule foreach "
			branchSubmodule=\$($COMMAND_GIT_CONFIG -f \$toplevel/.gitmodules submodule.\$name.branch);

			currentBranch=\$($COMMAND_GIT_BRANCH --show-current);

			if [ \"\$branchSubmodule\" = \".\" ]; then 
				cd \$toplevel;
				branchSuperproject=\$($COMMAND_GIT_BRANCH --show-current);
				cd \$sm_path;

				if [ \"\$branchSuperproject\" != \"\$currentBranch\" ]; then
					$vCommandGit -c core.hooksPath=/dev/null checkout \$branchSuperproject || ( echo $ERROR Nao foi possivel posicionar no branch \$branchSuperproject no submodule \$sm_path! && exit 1 );
				fi;

				$vCommandGit pull origin \$branchSuperproject --rebase || $COMMAND_GIT_STATUS;
			elif [ -n \"\$branchSubmodule\" ]; then
				if [ \"\$branchSubmodule\" != \"\$currentBranch\" ]; then
					$vCommandGit -c core.hooksPath=/dev/null checkout \$branchSubmodule || ( echo $ERROR Nao foi possivel posicionar no branch \$branchSubmodule no submodule \$sm_path! && exit 1 );
				fi;

				$vCommandGit pull origin \$branchSubmodule --rebase || $COMMAND_GIT_STATUS;
			else
				( echo $ERROR Nao foi possivel posicionar no branch correspondente no submodule \$sm_path, pois o branch nao foi especificado no arquivo .gitmodules do superprojeto! && exit 1 );
			fi;
		"
	fi
fi