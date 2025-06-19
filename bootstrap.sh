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

# Create symlinks for dotfiles
ln -sf ~/dotfiles/.zshrc ~/.zshrc
ln -sf ~/dotfiles/.config ~/.config

# Setup GitHub CLI authentication
echo "Setting up GitHub CLI..."
gh auth login

# Create OpenAI key file for LLM usage if it doesn't exist
if [ ! -f ~/.openai_key.zsh ]; then
    cp ~/dotfiles/.openai_key.zsh.template ~/.openai_key.zsh
    echo "Created ~/.openai_key.zsh from template - add your API keys to this file"
fi

# shell script files
