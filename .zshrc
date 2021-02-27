# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Use powerline
USE_POWERLINE="true"

# Source zsh-configuration
if [[ -e /usr/share/zsh/manjaro-zsh-config ]]; then
  source /usr/share/zsh/manjaro-zsh-config
fi

# Use zsh prompt
if [[ -e /usr/share/zsh/manjaro-zsh-prompt ]]; then
  source /usr/share/zsh/manjaro-zsh-prompt
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# manpager
export MANPAGER="nvim -c 'set ft=man' -"

# Neovim aliases
alias vi="nvim"
alias vim="nvim"

# Sudo alias
alias sudo="sudo "

# If not running interactively, do not do anything
#[[ $- != *i* ]] && return
# Otherwise start tmux
#[[ -z "$TMUX" ]] && exec tmux

# Julia
export PATH="$HOME/.julia-1.5.3/bin:$PATH"

# node
export PATH="$HOME/.node/bin:$PATH"

# GO
export PATH="$PATH:/usr/local/go/bin"
export GOPATH="$HOME/.go:$PATH"
export PATH="$HOME/.go/bin:$PATH"

# Pyenv
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv virtualenv-init -)"
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi
export PYTHON_CONFIGURE_OPTS="--enable-shared"

# ADD local to path
export PATH="$HOME/.local/bin:$PATH"

# Filezilla
#export PATH="$HOME/.FileZilla3/bin:$PATH"

# Nsight
#export PATH="$PATH:/usr/local/NVIDIA-Nsight-Compute"
#export PATH="$PATH:/usr/local/cuda-11.1/bin"
#export PATH="$PATH:/opt/nvidia/nsight-compute/2020.3.1"

# Emacs
#alias emacs="XLIB_SKIP_ARGB_VISUALS=1 emacs"

# Full pyenv macos
#export PYTHON_CONFIGURE_OPTS="--enable-framework"

# Haskell path
#export PATH="$HOME/.ghcup/bin:$PATH"
[ -f "/home/sys-adm-eddie/.ghcup/env" ] && source "/home/sys-adm-eddie/.ghcup/env" # ghcup-env

# pyls
#export PATH="/home/sys-adm-eddie/.local/bin:$PATH"
