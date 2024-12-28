# Install rosetta
if !(type "rosetta" > /dev/null 2>&1); then
	softwareupdate --install-rosetta --agree-to-license
fi

# Install brew to Mac
if !(type "brew" > /dev/null 2>&1); then
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Path to brew
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"
source ~/.zprofile

# homebrew-bundle
brew bundle --file ./Brewfile

# shell script files
