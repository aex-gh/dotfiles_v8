# Homebrew Role

Comprehensive Homebrew package management role for macOS, converted from Brewfile format.

## Features

- **Homebrew Installation**: Automatically installs Homebrew if not present
- **Tap Management**: Adds third-party repositories
- **Formula Installation**: Installs command-line tools and libraries
- **Cask Installation**: Installs GUI applications
- **Mac App Store**: Installs apps via `mas` CLI
- **Service Management**: Starts and manages Homebrew services
- **Modular Configuration**: Organised by category for easy customisation

## Usage

### Basic Usage
```yaml
roles:
  - homebrew
```

### Custom Package Lists
```yaml
roles:
  - role: homebrew
    vars:
      homebrew_formulas:
        - git
        - vim
        - htop
      homebrew_casks:
        - visual-studio-code
        - firefox
      mas_apps:
        - name: "Keynote"
          id: 361285480
```

### Category-based Customisation
```yaml
# Only install development tools
homebrew_formulas: "{{ homebrew_formulas_dev + homebrew_formulas_core }}"

# Skip optional applications
homebrew_casks: "{{ homebrew_casks_development + homebrew_casks_system }}"
```

## Package Categories

### Formulas (CLI Tools)
- **Core**: `mas`, `zsh`, `bash`, `tmux`
- **Development**: `git`, `neovim`, `gh`, `lazygit`
- **Files**: `stow`, `tree`, `eza`, `fd`, `fzf`
- **Text**: `ripgrep`, `bat`, `jq`, `yq`
- **Monitoring**: `htop`, `btop`, `ncdu`, `dust`
- **Network**: `curl`, `wget`, `httpie`, `nmap`
- **Environment**: `mise`, `uv`, `python`, `node`, `go`, `rust`
- **Database**: `postgresql`, `redis`, `sqlite`, `duckdb`
- **Cloud**: `awscli`, `azure-cli`, `prometheus`
- **Security**: `gnupg`, `openssl`, `mkcert`, `trivy`

### Casks (GUI Applications)
- **Browsers**: Firefox Developer Edition, Zen
- **Communication**: Slack, Zoom, Discord, Teams
- **Development**: VS Code, Zed, Cursor, JetBrains Toolbox
- **Productivity**: Obsidian, Raycast
- **System**: iTerm2, Ghostty, 1Password

### Mac App Store
- **Productivity**: Keynote, Pages, Numbers
- **Utilities**: Jump Desktop

## Configuration Variables

```yaml
# Enable/disable categories
install_development_tools: true
install_optional_apps: false
install_fonts: true

# Custom taps
homebrew_taps:
  - "custom/tap"

# Custom formulas
homebrew_formulas_custom:
  - "my-tool"

# Custom casks  
homebrew_casks_custom:
  - "my-app"

# Services to start
homebrew_services:
  - "postgresql@15"
  - "redis"
```

## Mac App Store Requirements

For MAS apps to install, you must:
1. Sign into the Mac App Store app
2. Previously "purchase" (free apps) or purchase the apps

The role will detect if you're signed in and skip MAS installations if not.

## Service Management

Services defined in `homebrew_services` will be started automatically:
```yaml
homebrew_services:
  - "postgresql@15"  # Starts PostgreSQL
  - "redis"          # Starts Redis
```

## Customisation Examples

### Minimal Developer Setup
```yaml
homebrew_formulas: "{{ homebrew_formulas_core + homebrew_formulas_dev }}"
homebrew_casks: 
  - "visual-studio-code"
  - "iterm2"
mas_apps: []
```

### Data Science Setup
```yaml
homebrew_formulas: >-
  {{
    homebrew_formulas_core +
    homebrew_formulas_dev +
    homebrew_formulas_datascience +
    homebrew_formulas_database
  }}
homebrew_casks:
  - "visual-studio-code"
  - "tableplus"
  - "dbeaver-community"
```

### No GUI Apps
```yaml
homebrew_casks: []
mas_apps: []
```

## Dependencies

- macOS (Apple Silicon supported)
- Internet connection for downloads
- Mac App Store account (for MAS apps)

## Integration

Typically used within the macOS role:
```yaml
# roles/macos/meta/main.yml
dependencies:
  - homebrew
```
