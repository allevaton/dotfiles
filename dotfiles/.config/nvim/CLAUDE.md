# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

This is a personal Neovim configuration using Lua and lazy.nvim as the plugin manager.

## File Structure

- `init.lua` - Main entry point: leader key, lazy.nvim bootstrap, editor settings, keymaps, autocommands, nvim-cmp setup
- `lua/plugins.lua` - Plugin definitions with lazy-loading configurations
- `lua/lsp.lua` - LSP, Mason, formatters (prettier, black, stylua), and language server configurations
- `stylua.toml` - StyLua formatter settings (2-space indent, single quotes)

## Architecture

**Plugin Manager**: lazy.nvim (auto-bootstrapped on first run)

**LSP Stack**:
- Mason for automatic LSP/formatter/linter installation
- mason-lspconfig for LSP server setup
- none-ls (null-ls) for formatters: prettier (JS/TS/CSS/JSON/HTML/YAML/MD), black (Python), stylua (Lua)
- Format-on-save enabled via LspAttach autocommand

**Key Integrations**:
- Telescope for fuzzy finding (files, grep, LSP symbols, references)
- nvim-treesitter with textobjects, refactor, autotag
- nvim-cmp for completion (LSP + buffer sources)
- GitHub Copilot and Copilot Chat
- nvim-ufo for code folding (treesitter + indent providers)

## Conventions

**Leader key**: `,` (comma)

**Indentation**: 2 spaces (expandtab)

**Key mappings of note**:
- `<leader>f*` - Telescope commands (ff=files, fg=grep, fb=buffers, fs/fS=symbols)
- `<leader>n` - Toggle file tree
- `<leader>c` - Copilot Chat toggle
- `gh` - Hover (with ufo fold preview support)
- `gr/gd/gi/gt` - Go to references/definitions/implementations/type definition
- `gR` - Treesitter smart rename
- `[d/]d` - Navigate diagnostics
- Treesitter textobjects: `af/if` (function), `ac/ic` (class), `]m/[m` (next/prev function)

## Working with This Config

When modifying plugins, add them to `lua/plugins.lua` following lazy.nvim spec format with appropriate lazy-loading events (`InsertEnter`, `VeryLazy`, `cmd`, `ft`, etc.).

LSP server configurations go in `lua/lsp.lua` within the mason-lspconfig setup handler. Formatters are configured via none-ls with fallback to project-local configs when present.

Lua code is formatted with stylua using settings from `stylua.toml`.
