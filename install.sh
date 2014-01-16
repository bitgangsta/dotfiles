#!/bin/sh
rm -rf $HOME/.vim/bundle/vundle

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

git clone https://github.com/gmarik/vundle.git ~/.vim/bundle/vundle
vim -u ~/.vimrc.bundles +BundleInstall +qa

### Customization

# echo "Enter the name of the computer: "
# read computer_name

remove_and_link(){
  local target="$2"
  local source="$1"

  if [[ -d "${target}" && ! -L "${target}" ]] ; then
    mv "${target}" "${target}.old"
  fi

  ln -snf "${source}" "${target}"
}

# SSH Config
remove_and_link "$HOME/dotfiles/ssh_config" "$HOME/.ssh/config"
