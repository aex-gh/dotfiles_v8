# Zsh Configuration Role

Comprehensive Zsh shell configuration using the hybrid approach (Option 3) with XDG Base Directory Specification compliance.

## Features

### Core Configuration
- **XDG Compliance**: Uses proper XDG directories on Linux, Library paths on macOS
- **Cross-platform**: Supports macOS and Linux with OS-specific optimisations
- **Template-based main configs**: Dynamic configuration with Jinja2 variables
- **Static files**: Easily editable aliases, functions, and completions

### Shell Features
- **Modern completions**: Enhanced completion system with custom completions
- **Rich aliases**: 100+ useful aliases for common tasks
- **Powerful functions**: 50+ utility functions for productivity
- **History management**: Optimised history settings with deduplication
- **Plugin support**: Manual plugin management or Oh My Zsh integration

### Tool Integration
- **FZF**: Fuzzy finding for files, git branches, history
- **Development tools**: Integrated support for git, docker, python, node
- **Modern alternatives**: Automatic detection of eza, bat, ripgrep, etc.
- **Version managers**: Support for mise, direnv, and language-specific tools

## Structure

```
roles/zsh/
├── templates/          # Dynamic configuration files
│   ├── zshrc.j2       # Main shell configuration
│   ├── zshenv.j2      # Environment variables
│   └── zprofile.j2    # Login shell profile
├── files/             # Static files
│   ├── aliases        # Command aliases
│   ├── functions      # Shell functions
│   └── completions/   # Custom completions
└── tasks/main.yml     # Installation tasks
```

## Configuration

### Basic Usage
```yaml
roles:
  - zsh
```

### Custom Configuration
```yaml
roles:
  - role: zsh
    vars:
      # Appearance
      prompt_theme: starship
      key_bindings: vi
      
      # Features
      enable_corrections: false
      install_oh_my_zsh: true
      
      # Tools
      enable_mise: true
      enable_direnv: true
```

### Advanced Configuration
```yaml
# Custom plugins
zsh_plugins:
  - name: powerlevel10k
    repo: https://github.com/romkatv/powerlevel10k.git
  - name: zsh-autosuggestions
    repo: https://github.com/zsh-users/zsh-autosuggestions.git

# Custom Oh My Zsh setup
install_oh_my_zsh: true
oh_my_zsh_theme: powerlevel10k/powerlevel10k
oh_my_zsh_plugins:
  - git
  - docker
  - kubectl
  - terraform

# History customisation
zsh_histsize: 100000
zsh_savehist: 100000
```

## Key Features

### Aliases (100+ included)
```bash
# File operations
ll, la, lt          # Enhanced ls with eza/lsd
..., ...., .....   # Quick directory navigation
extract             # Universal archive extraction

# Git shortcuts
g, ga, gc, gp      # Git commands
gaa, gcm, gco      # Common git workflows
gbb, glf           # FZF-integrated git operations

# Development
py, pip, venv      # Python shortcuts
ni, nr, ns         # Node.js/npm shortcuts
d, dc, dps         # Docker shortcuts
k, kgp, kgs        # Kubernetes shortcuts

# System
htop → btop        # Modern alternatives
cat → bat          # Syntax highlighting
grep → rg          # Faster search
find → fd          # Better file finding
```

### Functions (50+ included)
```bash
# File operations
mkcd               # Create and enter directory
extract            # Extract any archive format
backup             # Create timestamped backup

# Git workflows
gclone             # Clone and enter repository
gacp               # Add, commit, and push
gbf, glf, gsf      # FZF-integrated git operations

# Development
venv_create        # Create and activate venv
serve              # Quick HTTP server
docker_cleanup     # Clean Docker resources

# System utilities
sysinfo            # System information
weather            # Weather forecast
qr                 # Generate QR codes
calc               # Calculator function
```

### Completions
- **Enhanced Docker**: Better container and image completion
- **Enhanced Git**: Additional git workflow completions
- **Custom commands**: Template for your own completions

## OS-Specific Features

### macOS
- **Homebrew integration**: Automatic PATH and completion setup
- **macOS functions**: DNS flushing, Finder toggles, system controls
- **Application Support**: Uses macOS-standard Library directories

### Linux
- **Package manager detection**: Works with apt, pacman, dnf, zypper
- **System functions**: Package management, system updates
- **XDG compliance**: Full XDG Base Directory Specification support

## Prompt Options

### Custom Prompt (default)
- Shows username, hostname, current directory
- Git branch information with `vcs_info`
- Customisable colours

### Starship Prompt
```yaml
prompt_theme: starship
```
- Modern, fast prompt with extensive customisation
- Requires starship installation

### Simple Prompt
```yaml
prompt_theme: simple
```
- Minimal `user@host:path$ ` format

## Plugin Management

### Manual Plugins (default)
```yaml
zsh_plugins:
  - name: zsh-syntax-highlighting
    repo: https://github.com/zsh-users/zsh-syntax-highlighting.git
```

### Oh My Zsh
```yaml
install_oh_my_zsh: true
oh_my_zsh_plugins:
  - git
  - docker
  - kubectl
```

## Integration

Works seamlessly with other roles:
```yaml
roles:
  - xdg          # Sets up XDG directories first
  - homebrew     # Installs zsh and tools (macOS)
  - zsh          # Configures shell
```

## Customisation

### Local Configuration
Create `~/.config/zsh/zshrc.local` for personal additions that won't be overwritten.

### Custom Aliases/Functions
Add to the static files or override via variables:
```yaml
# In group_vars or host_vars
zsh_custom_aliases: |
  alias myproject='cd ~/projects/important'
  alias serve='python3 -m http.server 8000'
```

## Dependencies

### Required
- Zsh shell
- Git (for plugin management)

### Optional but Recommended
- fzf (fuzzy finding)
- eza/lsd (better ls)
- bat (syntax highlighting)
- ripgrep (better grep)
- fd (better find)
- starship (modern prompt)

## Troubleshooting

### Completion Issues
```bash
# Rebuild completion cache
rm ~/.cache/zsh/zcompdump*
exec zsh
```

### Plugin Problems
```bash
# Check plugin directories
ls ~/.config/zsh/plugins/
```

### History Issues
```bash
# Check history file
echo $HISTFILE
ls -la ~/.local/share/zsh/history
```

The role provides a complete, modern Zsh configuration that's both powerful and maintainable!
