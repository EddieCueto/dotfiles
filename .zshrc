# Use powerline
USE_POWERLINE="true"
# Source manjaro-zsh-configuration
if [[ -e /usr/share/zsh/manjaro-zsh-config ]]; then
  source /usr/share/zsh/manjaro-zsh-config
fi
# Use manjaro zsh prompt
if [[ -e /usr/share/zsh/manjaro-zsh-prompt ]]; then
  source /usr/share/zsh/manjaro-zsh-prompt
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Neovim aliases
alias vi="vimx"
alias vim="vimx"

# Sudo alias
alias sudo="sudo "

# If not running interactively, do not do anything
#[[ $- != *i* ]] && return
# Otherwise start tmux
#[[ -z "$TMUX" ]] && exec tmux

# Julia
export PATH="$HOME/.julia-1.5.3/bin:$PATH"

# node
#export PATH="$HOME/.node-v12.18.0/bin:$PATH"

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

# Filezilla
export PATH="$HOME/.FileZilla3/bin:$PATH"

# Nsight
#export PATH="$PATH:/usr/local/NVIDIA-Nsight-Compute"
#export PATH="$PATH:/usr/local/cuda-11.1/bin"
export PATH="$PATH:/opt/nvidia/nsight-compute/2020.3.1"

# Emacs
#alias emacs="XLIB_SKIP_ARGB_VISUALS=1 emacs"

# Full pyenv
#export PYTHON_CONFIGURE_OPTS="--enable-framework"

# Haskell path
export PATH="$HOME/.ghcup/bin:$PATH"

# pyls
export PATH="/home/sys-adm-eddie/.local/bin:$PATH"
