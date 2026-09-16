source "${${(%):-%N}:A:h}/.zsh_base.zsh"
export PATH="$HOME/.local/bin:$PATH"
if [[ -d "$HOME/github/monorepo/bin" ]]; then
  export PATH="$HOME/github/monorepo/bin:$PATH"
fi
if [[ -d /opt/homebrew/opt/mysql@8.4/bin ]]; then
  export PATH="/opt/homebrew/opt/mysql@8.4/bin:$PATH"
fi
if (( $+commands[rbenv] )); then
  eval "$(rbenv init -)"
fi
