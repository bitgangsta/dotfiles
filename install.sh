#!/bin/sh
for name in *; do
  target="$HOME/.$name"
  if [ -e "$target" ]; then
    if [ ! -L "$target" ]; then
      echo "WARNING: $target exists but is not a symlink."
    fi
  else
    if [ "$name" != 'install.sh' ] && [ "$name" != 'README.md' ]; then
      echo "Creating $target"
      ln -s "$PWD/$name" "$target"
    fi
  fi
done

### Customization

# echo "Enter the name of the computer: "
# read computer_name

git_clone_or_update() {
  local giturl="$1"
  local target="$2"
	
  if [[ ! -d "${target}" ]] ; then
	git clone "${giturl}" "${target}"
  else
	echo "Path already contains git repo, updating: ${target}"
    cd "${target}"
	git pull
  fi
}

remove_and_link(){
  local target="$2"
  local source="$1"

  if [[ -d "${target}" && ! -L "${target}" ]] ; then
    mv "${target}" "${target}.old"
  fi

  ln -snf "${source}" "${target}"
}

brew_install_ifn() {  
  for pkg in $*; do
	if brew list -1 | grep -q "^${pkg}\$"; then
	  echo "Package '$pkg' is already installed (skipping)."
	else
	  brew install "${pkg}"
	fi
  done
}

git_clone_or_update https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle
vim -u ~/.vimrc.bundles +BundleInstall +qa

git_clone_or_update https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh

# Install some shiz
brew_install_ifn tmux reattach-to-user-namespace python

# SSH Config
remove_and_link "$HOME/dotfiles/ssh_config" "$HOME/.ssh/config"

# Powerline
pip install git+git://github.com/Lokaltog/powerline
