#!/usr/bin/env bash
#
# Bootstrap script for setting up a new OSX machine
#
# This should be idempotent so it can be run multiple times.
#
# Some apps don't have a cask and so still need to be installed by hand. These
# include:
#
# - Twitter (app store)
# - Postgres.app (http://postgresapp.com/)
#
# Notes:
#
# - If installing full Xcode, it's better to install that first from the app
#   store before running the bootstrap script. Otherwise, Homebrew can't access
#   the Xcode libraries as the agreement hasn't been accepted yet.
#
# Reading:
#
# - http://lapwinglabs.com/blog/hacker-guide-to-setting-up-your-mac
# - https://gist.github.com/MatthewMueller/e22d9840f9ea2fee4716
# - https://news.ycombinator.com/item?id=8402079
# - http://notes.jerzygangi.com/the-best-pgp-tutorial-for-mac-os-x-ever/

echo "Starting bootstrapping"

# Check for Homebrew, install if we don't have it
if test ! $(which brew); then
    echo "Installing homebrew..."
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Update homebrew recipes
brew update

# Install GNU core utilities (those that come with OS X are outdated)
brew tap homebrew/dupes
brew install coreutils
brew install gnu-sed --with-default-names
brew install gnu-tar --with-default-names
brew install gnu-indent --with-default-names
brew install gnu-which --with-default-names
brew install gnu-grep --with-default-names

# Install GNU `find`, `locate`, `updatedb`, and `xargs`, g-prefixed
brew install findutils

# Install Bash 4
brew install bash

PACKAGES=(
    ack
    autoconf
    automake
    boot2docker
    ctags
    ffmpeg
    gettext
    gifsicle
    git
    graphviz
    hub
    imagemagick
    jq
    libjpeg
    libmemcached
    lynx
    markdown
    memcached
    mercurial
    npm
    pkg-config
    postgresql
    python
    python3
    pypy
    rabbitmq
    rename
    ssh-copy-id
    terminal-notifier
    the_silver_searcher
    tmux
    tree
    vim
    wget
    zsh
    zsh-completions
    md5sha1sum
    gcsfuse
)

echo "Installing packages..."
brew install --appdir="/Applications" ${PACKAGES[@]}

echo "Cleaning up..."
brew cleanup

# install oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

echo "Installing cask..."
#brew install caskroom/cask/brew-cask

CASKS=(
#    dropbox
    firefox
#    flux
    google-chrome
    iterm2
#    macvim
    skype
    slack
    spectacle
    vagrant
    virtualbox
    vlc
    deluge
    spotify
    spotify-notifications
    google-backup-and-sync
    pycharm
    calibre # ebooks library
    osxfuse
    alfred
    telegram
    visual-studio-code
)

echo "Installing cask apps..."
brew cask install --appdir="/Applications" ${CASKS[@]}

#echo "Installing fonts..."
brew tap caskroom/fonts
FONTS=(
    font-inconsolata
    font-hack-nerd-font
#    font-roboto
#    font-clear-sans
)
brew cask install ${FONTS[@]}

echo "Installing Python packages..."
PYTHON_PACKAGES=(
    ipython
    virtualenv
    virtualenvwrapper
)
sudo pip install ${PYTHON_PACKAGES[@]}

echo "Installing Ruby gems"
RUBY_GEMS=(
    bundler
    filewatcher
    cocoapods
    colorls
)
sudo gem install ${RUBY_GEMS[@]}

echo "Installing global npm packages..."
npm install marked -g

echo "Configuring OSX..."

# Set fast key repeat rate
defaults write NSGlobalDomain KeyRepeat -int 0

# Require password as soon as screensaver or sleep mode starts
defaults write com.apple.screensaver askForPassword -int 1
defaults write com.apple.screensaver askForPasswordDelay -int 0

# Show filename extensions by default
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Enable tap-to-click
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# Disable "natural" scroll
defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false

echo "Creating folder structure..."
[[ ! -d ~/Documents/workspace ]] && mkdir ~/Documents/workspace
[[ ! -d ~/Documents/apps]] && mkdir ~/Documents/apps
[[ ! -d ~/Documents/library]] && mkdir ~/Documents/library

echo "Bootstrapping complete"
#echo "Anaconda"
#wget https://repo.continuum.io/archive/Anaconda2-5.0.1-MacOSX-x86_64.sh -O ~/Downloads/anaconda.sh
#bash ~/Downloads/anaconda.sh -b -p $HOME/anaconda
#mkdir -p ~/Library/LaunchAgents
#cp /Users/bqm/anaconda/org.freedesktop.dbus-session.plist ~/Library/LaunchAgents/
#launchctl load -w ~/Library/LaunchAgents/org.freedesktop.dbus-session.plist
#export PATH="$HOME/anaconda/bin:$PATH"
