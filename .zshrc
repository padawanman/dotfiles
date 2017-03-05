source ~/.zshrc.antigen

autoload -U compinit
compinit

alias ls="/usr/local/bin/gls -aF --color=auto"
alias ll="/usr/local/bin/gls -alF --color=auto"
#eval $(/usr/local/bin/gdircolors ~/git/dotfiles/dircolors-solarized/dircolors.ansi-universal)
#eval $(/usr/local/bin/gdircolors ~/git/dotfiles/dircolors-solarized/dircolors.256dark)
eval $(/usr/local/bin/gdircolors ~/git/dotfiles/dircolors-solarized/dircolors.ansi-dark)
#eval $(/usr/local/bin/gdircolors ~/git/dotfiles/dircolors-solarized/dircolors.ansi-light)

#export LSCOLORS=exfxcxdxbxegedabagacad
#export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
#if [ -n "$LS_COLORS" ]; then
#    zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
#fi

PATH=/usr/local/bin:$PATH:$HOME/bin
export PATH

#zstyle ':completion:*' list-colors 'di=34' 'ln=35' 'so=32' 'ex=31' 'bd=46;34' 'cd=43;34'
PS1="$PS1"'$([ -n "$TMUX" ] && tmux setenv TMUXPWD_$(tmux display -p "#D" | tr -d %) "$PWD")'

