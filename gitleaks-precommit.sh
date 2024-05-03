#!/usr/bin/env bash

if [ ! -f .git/hooks/pre-commit ]; then
	echo "Downloading pre-commit script."
	curl -sL https://raw.githubusercontent.com/cr1m3s/precommit/main/gitleaks-precommit.sh > gitleaks-precommit.sh
	mv gitleaks-precommit.sh .git/hooks/pre-commit
fi

if [ ! $( git config --local hooks.enabled ) ]; then
	echo "Enabling git hooks."
	git config --local hooks.enabled true
fi


echo "Check gitleaks installation."
if ! command -v gitleaks &> /dev/null
then
	OSTYPE=$(uname | cut -d "-" -f 1)
    echo "Installing gitleaks"
		echo $OSTYPE
		case "${OSTYPE}" in
			"linux-gnu" | "freebsd")
				git clone https://github.com/gitleaks/gitleaks.git
				cd gitleaks
				make build
				cp  gitleaks "${HOME}/.local/bin/"
				;;
			"MINGW64_NT" | "CYGWIN_NT")
				version=$(curl -s https://github.com/gitleaks/gitleaks/releases | grep _checksums.txt | cut -d "_" -f 2 | head -1)
				link="https://github.com/gitleaks/gitleaks/releases/download/v${version}/gitleaks_${version}_windows_x64.zip"
				echo ${link}
				curl -L ${link} > gitleaks.zip
				mkdir gitleaks
				unzip gitleaks.zip -d 'gitleaks'
				mv 'gitleaks\gitleaks.exe' 'C:\MinGW\bin\'
				#rm -rf gitleaks/
				#rm -rf gitleaks.zip
				;;
			"darwin")
				brew install gitleaks
				;;
			*)
				echo "Unsupported OS version"
				exit 1
				;;
		esac
else
	echo "gitleaks already installed"
fi

echo "Running gitleaks..."
if gitleaks detect --no-git -v; then
    exit 0
else
    echo "Gitleaks found secrets in your code. Please remove them before committing."
    exit 1
fi