if status is-interactive
    # Commands to run in interactive sessions can go here
end

# ── Editor ────────────────────────────────────────────────────────────────────
if type -q nvim
    set -gx EDITOR nvim
    alias vim='nvim'
    alias vimrc='nvim ~/.config/nvim'
    alias vimrcp='nvim ~/.config/nvim/lua/plugins.lua'
    alias vimrcl='nvim ~/.config/nvim/lua/lsp.lua'
else
    set -gx EDITOR vim
end

# ── PATH ──────────────────────────────────────────────────────────────────────
fish_add_path ~/.local/bin

# ── Platform-specific ─────────────────────────────────────────────────────────
if test (uname) = Darwin
    fish_add_path /opt/homebrew/opt/openjdk/bin
    alias python='python3'
    alias pip='pip3'
else if set -q WSL_DISTRO_NAME
    # WSL: start ssh agent (wsl2-ssh-agent outputs sh syntax, so parse it manually)
    for line in (/usr/sbin/wsl2-ssh-agent 2>/dev/null)
        set -l match (string match -r '^(\w+)=([^;]+)' $line)
        if test (count $match) -ge 3
            set -gx $match[2] $match[3]
        end
    end

    # Override PATH to avoid Windows path pollution
    set -gx OLD_PATH $PATH
    set -gx PATH \
        /usr/local/sbin /usr/local/bin \
        /usr/sbin /usr/bin \
        /sbin /bin \
        /usr/games /usr/local/games \
        /usr/lib/wsl/lib \
        /mnt/c/Users/allev/.oh-my-posh \
        "/mnt/c/Users/allev/AppData/Local/Programs/Microsoft VS Code/bin" \
        /mnt/c/Windows/System32 \
        /mnt/c/Windows \
        "/mnt/c/Windows/System32/WindowsPowerShell/v1.0"
else
    fish_add_path /usr/local/cuda-12.3/bin
    set -gx LD_LIBRARY_PATH /usr/local/cuda-12.3/lib64 $LD_LIBRARY_PATH
end

# ── eza / ls ──────────────────────────────────────────────────────────────────
set -gx EZA_IGNORE_GLOB ".DS_Store|Thumbs.db|__pycache__|*.pyc|.mypy_cache"
set -gx LS_COLORS "di=1;34:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43"

alias ls='eza --group-directories-first'
alias ll='eza -la --group-directories-first --git'
alias lt='eza --tree --level=2 --group-directories-first -I="node_modules|.git|.idea|.vscode|.next|.cache"'
alias l='ls'

# ── Git ───────────────────────────────────────────────────────────────────────
alias lg='lazygit'

# ── Starship prompt ───────────────────────────────────────────────────────────
starship init fish | source
