# set installed zsh & fish
echo "/usr/local/bin/zsh" >> /etc/shells
echo "/usr/local/bin/fish" >> /etc/shells
chsh -s /usr/local/bin/zsh

# set up antigen
git clone https://github.com/zsh-users/antigen.git ~/.antigen
git clone https://github.com/milkbikis/powerline-shell ~/.powerline-shell
git clone https://github.com/erikw/tmux-powerline.git ~/.tmux-powerline-shell
cd ~/.powerline-shell/;python2.7 install.py

# symlinks
if [ -f ~/.zshrc ]; then
  rm ~/.zshrc
fi
ln -sf ~/git/dotfiles/.zshrc ~/.zshrc
ln -sf ~/git/dotfiles/.zshrc.antigen ~/.zshrc.antigen
ln -sf ~/git/dotfiles/.zprofile ~/.zsh_profile
ln -sf ~/git/dotfiles/.tmux.conf ~/.tmux.conf
ln -sf ~/git/dotfiles/.exports ~/.exports
ln -sf ~/git/dotfiles/.aliases ~/.aliases
ln -sf ~/git/dotfiles/.functions ~/.functions
ln -sf ~/git/dotfiles/.vimrc ~/.vimrc
ln -sf ~/git/dotfiles/.gitconfig ~/.gitconfig
ln -sf ~/git/dotfiles/.editorconfig ~/.editorconfig
