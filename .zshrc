# Personal Zsh configuration file. It is strongly recommended to keep all
# shell customization and configuration (including exported environment
# variables such as PATH) in this file or in files sourced from it.
#
# Documentation: https://github.com/romkatv/zsh4humans/blob/v5/README.md.
#
# Periodic auto-update on Zsh startup: 'ask' or 'no'.
# You can manually run `z4h update` to update everything.
zstyle ':z4h:' auto-update      'ask'
# Ask whether to auto-update this often; has no effect if auto-update is 'no'.
zstyle ':z4h:' auto-update-days '7'

# Keyboard type: 'mac' or 'pc'.
zstyle ':z4h:bindkey' keyboard  'pc'

# Whether to move prompt to the bottom when zsh starts and on Ctrl+L.
zstyle ':z4h:' prompt-at-bottom 'no'

# Mark up shell's output with semantic information.
zstyle ':z4h:' term-shell-integration 'yes'

# Right-arrow key accepts one character ('partial-accept') from
# command autosuggestions or the whole thing ('accept')?
zstyle ':z4h:autosuggestions' forward-char 'accept'

# Recursively traverse directories when TAB-completing files.
zstyle ':z4h:fzf-complete' recurse-dirs 'yes'

# Enable direnv to automatically source .envrc files.
zstyle ':z4h:direnv'         enable 'yes'
# Show "loading" and "unloading" notifications from direnv.
zstyle ':z4h:direnv:success' notify 'yes'

# Enable ('yes') or disable ('no') automatic teleportation of z4h over
# SSH when connecting to these hosts.
zstyle ':z4h:ssh:example-hostname1'   enable 'yes'
zstyle ':z4h:ssh:*.example-hostname2' enable 'no'
# The default value if none of the overrides above match the hostname.
zstyle ':z4h:ssh:*'                   enable 'no'
#experimental. press tab twice for autocomplete
zstyle ':completion:*' menu select
# Send these files over to the remote host when connecting over SSH to the
# enabled hosts.
zstyle ':z4h:ssh:*' send-extra-files '~/.nanorc' '~/.env.zsh'

# Start ssh-agent if it's not running yet.
zstyle ':z4h:ssh-agent:' start yes

# Clone additional Git repositories from GitHub.
#
# This doesn't do anything apart from cloning the repository and keeping it
# up-to-date. Cloned files can be used after `z4h init`. This is just an
# example. If you don't plan to use Oh My Zsh, delete this line.
z4h install ohmyzsh/ohmyzsh || return

# Install or update core components (fzf, zsh-autosuggestions, etc.) and
# initialize Zsh. After this point console I/O is unavailable until Zsh
# is fully initialized. Everything that requires user interaction or can
# perform network I/O must be done above. Everything else is best done below.
z4h init || return

# Extend PATH.
path=(~/bin $path)

source ~/zsh-defer/zsh-defer.plugin.zsh
zsh-defer source ~/zsh-autosuggestions/zsh-autosuggestions.zsh
zsh-defer source ~/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
zsh-defer source ~/zsh-completions/zsh-completions.plugin.zsh
# Export environment variables.
export GPG_TTY=$TTY

source ~/.bash_aliases
# Source additional local files if they exist.
[[ -f ~/.localrc ]] && source ~/.localrc
z4h source ~/.env.zsh

# autoloads and navigation:
autoload -Uz zmv
autoload -Uz z4h-cd
autoload -Uz z4h-cd-back
autoload -Uz z4h-cd-forward
autoload -Uz z4h-cd-up
autoload -Uz z4h-cd-down
autoload -Uz z4h-backward-kill-word
autoload -Uz z4h-backward-kill-zword
autoload -Uz z4h-undo
autoload -Uz z4h-redo
autoload -Uz z4h-kill-line
autoload -Uz z4h-kill-whole-line
autoload -Uz z4h-kill-word
autoload -Uz z4h-kill-zword
autoload -Uz z4h-kill-buffer
autoload -Uz z4h-kill-whole-buffer
autoload -Uz z4h-kill-region
autoload -Uz z4h-kill-ring-save
autoload -Uz z4h-kill-backward-word
autoload -Uz z4h-kill-backward-zword
autoload -Uz z4h-kill-backward-line
autoload -Uz z4h-kill-backward-whole-line
autoload -Uz z4h-kill-backward-buffer
autoload -Uz z4h-kill-backward-whole-buffer
autoload -Uz z4h-kill-backward-region
autoload -Uz z4h-kill-backward-ring-save

#install external plugins
z4h install chrissicool/zsh-256color

#Plugin nonarrayzsh
z4h load ohmyzsh/ohmyzsh/plugins/brew
z4h load ohmyzsh/ohmyzsh/colored-man-pages
z4h load ohmyzsh/ohmyzsh/plugins/command-not-found
z4h load ohmyzsh/ohmyzsh/plugins/git
z4h load ohmyzsh/plugins/enhancd
z4h load ohmyzsh/plugins/ripgrep

source ~/.fzf.zsh
source ~/enhancd/enhancd.plugin.zsh
source ~/.cache/zsh4humans/v5/fzf/shell/key-bindings.zsh
source ~/grc/grc.zsh
source ~/path/to/f-sy-h/F-Sy-H.plugin.zsh
source ~/zsh-interactive-cd/zsh-interactive-cd.plugin.zsh

# Define key bindings.
z4h bindkey undo Ctrl+/   Shift+Tab  # undo the last command line change
z4h bindkey redo Option+/            # redo the last undone command line change

z4h bindkey z4h-cd-back    Alt+Left   # cd into the previous directory
z4h bindkey z4h-cd-forward Alt+Right  # cd into the next directory
z4h bindkey z4h-cd-up      Shift+Up     # cd into the parent directory
z4h bindkey z4h-cd-down    Shift+Down   # cd into a child directory

# Autoload functions.
autoload -Uz zmv

# Define functions and completions.
compdef _directories md

# Define named directories: ~w <=> Windows home directory on WSL.
[[ -z $z4h_win_home ]] || hash -d w=$z4h_win_home

# Define aliases.
alias tree='tree -a -I .git'
alias -g ls="lsd -a1 --group-directories-first" # my preferred listing
# Add flags to existing aliases.
alias ls="${aliases[ls]:-ls} -A"
globalias() {
   if [[ $LBUFFER =~ ' [A-Z0-9]+$' ]]; then
     zle _expand_alias
     zle expand-word
   fi
   zle self-insert
}

zle -N globalias

bindkey " " globalias
bindkey "^ " magic-space           # control-space to bypass completion
bindkey -M isearch " " magic-space # normal space during searches

# Set shell options: http://zsh.sourceforge.net/Doc/Release/Options.html.
setopt glob_dots     # no special treatment for file names with a leading dot
setopt no_auto_menu  # require an extra TAB press to open the completion menu
setopt COMPLETE_ALIASES  # expand aliases during completion
setopt HIST_FIND_NO_DUPS  # do not show duplicates in history search

export PATH="~/git-fuzzy/bin:$PATH"

