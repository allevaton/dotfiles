# sync-from-local.ps1
# Copies tracked config files from the live system into dotfiles/

# --- Neovim ---
$nvimSrc = "$env:LOCALAPPDATA\nvim"
$nvimDst = "$PSScriptRoot\dotfiles\.config\nvim"

$nvimFiles = @(
    "init.lua",
    "init_old.vim",
    "stylua.toml",
    "lua\lsp.lua",
    "lua\plugins.lua"
)

foreach ($file in $nvimFiles) {
    $src = Join-Path $nvimSrc $file
    $dst = Join-Path $nvimDst $file

    if (-not (Test-Path $src)) {
        Write-Warning "Source not found, skipping: $src"
        continue
    }

    $dstDir = Split-Path $dst
    if (-not (Test-Path $dstDir)) {
        New-Item -ItemType Directory -Path $dstDir | Out-Null
    }

    Copy-Item -Path $src -Destination $dst -Force
    Write-Host "Copied: nvim/$file"
}

# --- Claude skills ---
$skillsSrc = "$env:USERPROFILE\.claude\skills"
$skillsDst = "$PSScriptRoot\dotfiles\.claude\skills"

if (Test-Path $skillsSrc) {
    if (-not (Test-Path $skillsDst)) {
        New-Item -ItemType Directory -Path $skillsDst | Out-Null
    }
    Copy-Item -Path "$skillsSrc\*" -Destination $skillsDst -Recurse -Force
    Write-Host "Copied: .claude/skills/"
} else {
    Write-Warning "Source not found, skipping: $skillsSrc"
}

Write-Host "Done."
