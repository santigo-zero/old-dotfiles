#zmodload zsh/zprof # Uncomment to enable stats for Zsh with zprof command
autoload -Uz colors && colors
HISTFILE=~/.config/zsh/.zshHistory
HISTSIZE=600000
SAVEHIST=600000

zstyle ':compinstall:filename' '/home/st/.config/zsh/.zshrc'
zstyle ':completion:*:*:*:*:*' menu select=3 # If there's less than 6 items it will use normal tabs
zstyle ':completion:*:matches' group 'yes'
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:options' auto-description '%d'
zstyle ':completion:*:corrections' format ' %F{green}-- %d (errors: %e) --%f'
zstyle ':completion:*:descriptions' format ' %F{yellow}-- %d --%f'
zstyle ':completion:*:messages' format ' %F{purple} -- %d --%f'
zstyle ':completion:*:warnings' format ' %F{red}-- no matches found --%f'
zstyle ':completion:*:default' list-prompt '%S%M matches%s'
zstyle ':completion:*' format ' %F{yellow}-- %d --%f'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' verbose yes
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*:functions' ignored-patterns '(_*|pre(cmd|exec))' # Ignore patterns
zstyle ':autocomplete:*' min-delay 0.0  # float
zstyle ':completion:*' matcher-list '' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' '+l:|?=** r:|?=**'
zstyle ':vcs_info:*' enable git # Enable only git
zstyle ':vcs_info:git*+set-message:*' hooks git-untracked
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:git:*' formats "%{$fg[blue]%}❰%{$fg[red]%}%m%u%c%{$fg[yellow]%}%{$fg[magenta]%} %b%{$fg[blue]%}❱ "

setopt PROMPT_SUBST # Let the prompt substite variables, without this the prompt will not work
setopt BRACE_CCL # Allow brace character class list expansion
setopt COMPLETE_IN_WORD # Complete from both ends of a word.
setopt ALWAYS_TO_END # Move cursor to the end of a completed word.
setopt CORRECT # Turn on corrections
setopt EXTENDEDGLOB NOMATCH MENUCOMPLETE
setopt INTERACTIVE_COMMENTS # Enable comments in interactive shell

# History
setopt INC_APPEND_HISTORY # Ensure that commands are added to the history immediately
setopt HIST_SAVE_NO_DUPS # Do not write a duplicate event to the history file.

# Directories
setopt AUTO_CD # Automatically cd into typed directory.
setopt AUTO_PUSHD # Push the current directory visited on the stack.
setopt PUSHD_IGNORE_DUPS # Do not store duplicates in the stack.
setopt PUSHD_SILENT # Do not print the directory stack after pushd or popd.

# Unset the annoying bell
unsetopt BEEP # No soud on error

# Jobs
setopt AUTO_RESUME # Attempt to resume existing job before creating a new process.
setopt NOTIFY # Report status of background jobs immediately.
setopt NO_HUP # Don't kill jobs on shell exit.
unsetopt BG_NICE # Don't run all background jobs at a lower priority.

autoload -Uz compinit # Basic auto/tab complete:
for dump in $ZDOTDIR/.zcompdump(N.mh+24); do # Twice a day it's updated
    autoload compinit
done
autoload -Uz compinit -C

zmodload zsh/mathfunc
zmodload zsh/complist
_comp_options+=(globdots) # Include hidden files.

# Load aliases, functions and vi-mode
source "${XDG_CONFIG_HOME:-$HOME/.config}/zsh/.zshAliasFunrc"
autoload -Uz last-command
autoload -Uz ex

# Vi mode
source "${XDG_CONFIG_HOME:-$HOME/.config}/zsh/.zshvi"
autoload -Uz cursor_shape; cursor_shape

autoload -Uz vcs_info # Vcs and colors

autoload -Uz precmd_vcs_info
autoload -Uz precmd_functions
precmd_vcs_info() { vcs_info } # Setup a hook that runs before every ptompt.
precmd_functions+=( precmd_vcs_info )

+vi-git-untracked(){
    if [[ $(git rev-parse --is-inside-work-tree 2> /dev/null) == 'true' ]] && \
        git status --porcelain | grep '??' &> /dev/null ; then
        hook_com[staged]+='N!' # Signify new files with a upper case N and a bang
    fi
}
autoload -Uz function +vi-git-untracked

# Exit code of the last command
function check_last_exit_code() {
    local LAST_EXIT_CODE=$?
    if [[ $LAST_EXIT_CODE -ne 0 ]]; then
        local EXIT_CODE_PROMPT=' '
        EXIT_CODE_PROMPT+="%{$fg[red]%}❰%{$reset_color%}"
        EXIT_CODE_PROMPT+="%{$fg_bold[red]%}$LAST_EXIT_CODE%{$reset_color%}"
        EXIT_CODE_PROMPT+="%{$fg[red]%}❱%{$reset_color%}"
        echo "$EXIT_CODE_PROMPT"
    fi
}
autoload -Uz check_last_exit_code

# " "
# "視"
# " "
# " "
actualSymbol=" "
PROMPT="╭─%n@%m%F{white} %1~%f%{$reset_color%} \$vcs_info_msg_0_%f%{$reset_color%}
╰─%(?:%{$fg_bold[white]%}$actualSymbol:%{$fg_bold[red]%}ﮀ )%${vi_mode}%{$reset_color%}"

RPROMPT='$(check_last_exit_code) ${vi_mode}'

# fzf
source /usr/share/fzf/completion.zsh 2>/dev/null
source /usr/share/fzf/key-bindings.zsh 2>/dev/null

# zsh-autosuggestions
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh 2>/dev/null

# Fast-syntax-highlighting
source /usr/share/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh 2>/dev/null

#zprof # To time up the zsh load time
