#!/bin/bash

vFilePackageJson="package.json"
vCommandNpmInstall="npm ci"

if [ -f $vFilePackageJson ]; then
	echo "Executando o comando '$vCommandNpmInstall'"
	$vCommandNpmInstall
fi