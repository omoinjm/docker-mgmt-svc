#!/bin/zsh
# Minimal zsh setup with devcontainer-style prompt

ZSHRC="$HOME/.zshrc"

cat >"$ZSHRC" <<'EOF'
# History
HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000
setopt inc_append_history

# Key bindings & completion
bindkey -e
bindkey "\e[A" history-beginning-search-backward
bindkey "\e[B" history-beginning-search-forward
autoload -U compinit && compinit

# Git prompt helper
git_prompt_info() {
    local branch=$(git symbolic-ref --short HEAD 2>/dev/null || git rev-parse --short HEAD 2>/dev/null)
    [[ -z "$branch" ]] && return
    echo "%F{cyan}(%F{red}${branch}%F{cyan})%f "
}

# Dynamic prompt with exit status
setopt prompt_subst
precmd() {
    local exit_code=$?
    local arrow_color=$([[ $exit_code -eq 0 ]] && echo "default" || echo "red")
    local user="%F{green}${GITHUB_USER:-%n}%f"
    local arrow="%F{${arrow_color}}➜%f"
    local dir="%F{blue}%B%~%b%f"
    
    PS1="${user} ${arrow} ${dir} $(git_prompt_info)$ "
    print -Pn "\e]2;%-3~\a"
}

# Aliases
alias ls='ls --color=auto -hv'
alias ll='ls -l'
alias la='ls -lA'
alias grep='grep --color=auto'
alias mv='mv -i'
alias g='git'
EOF
