# overwrite-local.ps1
# Backs up live config, then copies dotfiles/ onto the live system.

# --- Neovim ---
$nvimSrc = "$PSScriptRoot\dotfiles\.config\nvim"
$nvimDst = "$env:LOCALAPPDATA\nvim"
$nvimBackup = "$PSScriptRoot\_local-backup\.config\nvim"

$nvimFiles = @(
    "init.lua",
    "init_old.vim",
    "stylua.toml",
    "lua\lsp.lua",
    "lua\plugins.lua"
)

# Backup live nvim files
foreach ($file in $nvimFiles) {
    $live = Join-Path $nvimDst $file
    $backup = Join-Path $nvimBackup $file

    if (Test-Path $live) {
        $backupDir = Split-Path $backup
        if (-not (Test-Path $backupDir)) {
            New-Item -ItemType Directory -Path $backupDir | Out-Null
        }
        Copy-Item -Path $live -Destination $backup -Force
        Write-Host "Backed up: nvim/$file"
    }
}

# Copy nvim dotfiles onto live system
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
$skillsSrc = "$PSScriptRoot\dotfiles\.claude\skills"
$skillsDst = "$env:USERPROFILE\.claude\skills"
$skillsBackup = "$PSScriptRoot\_local-backup\.claude\skills"

if (Test-Path $skillsDst) {
    if (-not (Test-Path $skillsBackup)) {
        New-Item -ItemType Directory -Path $skillsBackup | Out-Null
    }
    Copy-Item -Path "$skillsDst\*" -Destination $skillsBackup -Recurse -Force
    Write-Host "Backed up: .claude/skills/"
}

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
