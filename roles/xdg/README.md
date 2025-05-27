# XDG Base Directory Specification Role

This role implements the [XDG Base Directory Specification](https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html) for proper directory organisation across Linux and macOS systems.

## What is XDG?

The XDG Base Directory Specification defines standard locations for user files:

- **XDG_CONFIG_HOME**: User-specific configuration files (`~/.config`)
- **XDG_DATA_HOME**: User-specific data files (`~/.local/share`)
- **XDG_CACHE_HOME**: User-specific cache files (`~/.cache`)
- **XDG_STATE_HOME**: User-specific state files (`~/.local/state`)
- **XDG_RUNTIME_DIR**: User-specific runtime files (`/run/user/$UID`)

## Cross-Platform Support

| Directory | Linux | macOS |
|-----------|-------|-------|
| CONFIG_HOME | `~/.config` | `~/Library/Application Support` |
| DATA_HOME | `~/.local/share` | `~/Library/Application Support` |
| CACHE_HOME | `~/.cache` | `~/Library/Caches` |
| STATE_HOME | `~/.local/state` | `~/Library/Application Support` |
| RUNTIME_DIR | `/run/user/$UID` | `$TMPDIR` |

## Features

### Directory Creation
- Creates all XDG base directories
- Sets up standard user directories (Desktop, Downloads, etc.)
- Pre-creates common application directories
- Handles proper permissions

### Environment Setup
- Exports XDG variables to shell profile
- Creates systemd environment file (Linux only)
- Configures xdg-user-dirs (Linux only)

### Application Support
Pre-creates directories for common applications:
```
~/.config/{git,vim,nvim,zsh,bash,fontconfig}/
~/.local/share/{bash,zsh,vim,nvim}/
~/.cache/{vim,nvim}/
~/.config/systemd/user/  # Linux only
```

## Configuration

### Variables

```yaml
# Control what gets created
create_user_dirs: true          # Desktop, Downloads, etc.
create_app_dirs: true           # Application-specific dirs
setup_environment: true         # systemd environment file
setup_shell_profile: true      # Add to ~/.profile
setup_user_dirs_config: true   # xdg-user-dirs config

# Customise user directory names
xdg_user_dirs:
  desktop: "Desktop"
  download: "Downloads"
  documents: "Documents"
  music: "Music"
  pictures: "Pictures"
  videos: "Videos"
  templates: "Templates"
  publicshare: "Public"

# Add custom directories
xdg_additional_dirs:
  - "{{ xdg_config_home }}/custom-app"
  - "{{ xdg_data_home }}/custom-data"
```

### Usage Examples

#### Basic usage (default settings):
```yaml
roles:
  - xdg
```

#### Minimal setup (no user dirs):
```yaml
roles:
  - role: xdg
    vars:
      create_user_dirs: false
      setup_user_dirs_config: false
```

#### Custom configuration:
```yaml
roles:
  - role: xdg
    vars:
      xdg_user_dirs:
        download: "Inbox"
        documents: "Docs"
      xdg_additional_dirs:
        - "{{ xdg_config_home }}/my-app"
        - "{{ xdg_data_home }}/scripts"
```

## Benefits

### Clean Home Directory
Instead of cluttering `~` with dotfiles and directories:
```bash
# Before XDG
~/
├── .vimrc
├── .vim/
├── .bashrc
├── .bash_history
├── .gitconfig
├── Downloads/
├── Desktop/
└── ...dozens more dotfiles

# After XDG
~/
├── .config/
│   ├── git/config
│   ├── vim/vimrc
│   └── bash/bashrc
├── .local/
│   ├── share/bash/history
│   └── share/vim/
├── .cache/vim/
├── Downloads/
└── Desktop/
```

### Application Compliance
Many modern applications support XDG:
- Git: `~/.config/git/config`
- Vim/Neovim: `~/.config/vim/vimrc`, `~/.config/nvim/`
- Zsh: `~/.config/zsh/`, `~/.local/share/zsh/`
- Bash: `~/.config/bash/`, `~/.local/share/bash/`

### Backup and Sync
Easy to backup/sync specific data types:
```bash
# Backup all configs
rsync -av ~/.config/ backup/config/

# Backup user data only
rsync -av ~/.local/share/ backup/data/

# Exclude caches from backups
rsync -av --exclude='.cache' ~/ backup/
```

## Dependencies

### Linux
- `xdg-user-dirs` package (automatically installed)
- systemd (for user environment)

### macOS
- No additional dependencies

## Integration

This role is designed to run **first** in your playbook, as other roles may depend on XDG directories existing:

```yaml
roles:
  - xdg          # Creates directory structure
  - common       # May use XDG dirs
  - applications # May need XDG compliance
```

## Troubleshooting

### Variables not set in new sessions
Ensure your shell sources `~/.profile`:
```bash
# Add to ~/.bashrc or ~/.zshrc
source ~/.profile
```

### Applications not using XDG directories
Some applications need explicit configuration:
```bash
# Git
git config --global include.path ~/.config/git/config

# Vim
export VIMINIT='source ~/.config/vim/vimrc'
```

### Runtime directory issues (Linux)
If `XDG_RUNTIME_DIR` isn't automatically set by your system, the role creates a fallback. For proper systemd integration, ensure your login manager sets this correctly.
