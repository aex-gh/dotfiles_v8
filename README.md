# Dotfiles v8 - Professional Development Environment

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Ansible](https://img.shields.io/badge/Ansible-2.9%2B-red.svg)](https://www.ansible.com/)
[![Platform](https://img.shields.io/badge/Platform-macOS%20%7C%20Linux-blue.svg)](#supported-platforms)

Modern, XDG-compliant dotfiles managed with Ansible for professional development environments.

## ✨ Features

- **🔧 XDG Base Directory Specification** compliant
- **🌍 Cross-platform** support (macOS Silicon, Linux distributions)
- **🚀 Modern tooling** with Mise, UV, Neovim, Zsh
- **🔐 Security-first** SSH/GPG key management
- **📦 Package management** via Homebrew, native packages, and Flatpak
- **🔄 Backup & rollback** system
- **✅ Validation framework** with pre-flight checks
- **🏷️ Tagged execution** for selective installation
- **📊 Comprehensive logging** and error handling

## 🚀 Quick Start

```bash
# Clone the repository
git clone https://github.com/yourusername/dotfiles_v8.git ~/.dotfiles
cd ~/.dotfiles

# Make scripts executable
chmod +x bootstrap.sh run.sh rollback.sh

# Run initial setup
./bootstrap.sh

# Or run manually
./run.sh
```

## 📋 Requirements

### System Requirements
- **macOS**: 12.0+ (Apple Silicon recommended)
- **Linux**: Ubuntu 20.04+, Debian 11+, Arch Linux, Fedora 35+
- **Disk Space**: 2GB+ free space
- **Network**: Internet connection for package downloads

### Dependencies (automatically installed)
- Ansible 2.9+
- Python 3.8+
- Git 2.30+

## 📁 Project Structure

```
dotfiles_v8/
├── 📜 bootstrap.sh          # Initial setup script
├── 🏃 run.sh               # Main execution script
├── 🔄 rollback.sh          # Configuration rollback
├── 📋 site.yml             # Main Ansible playbook
├── 📦 inventory.yml        # Host configuration
├── ⚙️ ansible.cfg          # Ansible settings
├── 
├── 📂 roles/               # Ansible roles
│   ├── 🗂️ xdg/            # XDG directory setup
│   ├── 🔧 common/         # Base system configuration  
│   ├── 🍺 homebrew/       # macOS package management
│   ├── 🐧 linux/          # Linux package management
│   ├── 🍎 macos/          # macOS system settings
│   ├── 🛠️ mise/           # Development runtime manager
│   ├── 🐍 python/         # Python/UV environment
│   ├── 📝 git/            # Git configuration
│   ├── 📄 editor/         # Neovim setup
│   ├── 🐚 zsh/            # Shell configuration
│   └── 💻 development/    # SSH/GPG keys, dev tools
├── 
├── 📂 group_vars/         # Platform-specific variables
│   ├── 🌐 all.yml         # Cross-platform settings
│   ├── 🍎 macos.yml       # macOS packages & settings
│   └── 🐧 linux.yml       # Linux packages & settings
└── 
└── 📂 files/              # Static configuration files
```

## 🎯 Usage

### 🔧 Basic Operations

```bash
# Full installation
./run.sh

# Dry run (preview changes)
./run.sh --check

# Run with verbose output
./run.sh -vvv

# Validate system only
./run.sh --validate-only
```

### 🏷️ Tagged Execution

```bash
# Install only development tools
./run.sh --tags tools,development

# Skip security setup
./run.sh --skip-tags security

# Foundation setup only
./run.sh --tags foundation

# Package management only
./run.sh --tags packages
```

### 📊 Monitoring & Debugging

```bash
# List available tasks
./run.sh --list-tasks

# Show available tags
./run.sh --list-tags

# Check syntax
./run.sh --syntax-check

# Profile performance
./run.sh --profile
```

### 🔄 Backup & Recovery

```bash
# List available backups
./rollback.sh --list

# Restore latest backup
./rollback.sh --latest

# Restore specific backup
./rollback.sh --restore 20240101_120000

# Preview restore (dry run)
./rollback.sh --dry-run --latest
```

## ⚙️ Configuration

### 🔧 Essential Settings

Edit `group_vars/all.yml` for global settings:

```yaml
# Git configuration (REQUIRED)
git_user_name: "Your Name"
git_user_email: "your.email@example.com"

# Feature toggles
use_uv_python: true
install_nerd_fonts: true
setup_development_environment: true
```

### 📦 Package Customization

**macOS** (`group_vars/macos.yml`):
```yaml
homebrew_formulas:
  - neovim
  - tmux
  - your-tool

homebrew_casks:
  - visual-studio-code
  - your-app

mas_packages:
  - { name: "Xcode", id: 497799835 }
```

**Linux** (`group_vars/linux.yml`):
```yaml
apt_packages:          # Debian/Ubuntu
  - neovim
  - your-package

flatpak_packages:      # Cross-distro apps
  - com.visualstudio.code
  - your.flatpak.App
```

### 🎨 Shell Customization

Modify shell behavior in role defaults:
- `roles/zsh/defaults/main.yml` - Zsh configuration
- `roles/common/templates/shell_aliases.j2` - Custom aliases
- `roles/common/templates/shell_functions.j2` - Custom functions

## 🛠️ What's Installed

### 📋 Core Tools
- **Shell**: Zsh with modern plugins (syntax highlighting, autosuggestions)
- **Editor**: Neovim with LSP, Lazy.nvim, Tree-sitter
- **Version Control**: Git with delta pager, lazygit TUI
- **Development**: Mise runtime manager, UV Python manager
- **Terminal**: Modern CLI tools (eza, bat, ripgrep, fd, fzf, zoxide)

### 📱 Applications

**macOS Applications**:
- Development: VS Code, iTerm2, Docker
- Browsers: Firefox, Chrome  
- Productivity: Raycast, 1Password, Slack
- Media: Spotify, VLC
- Utilities: Rectangle, CleanMyMac, Keka

**Linux Applications** (via Flatpak):
- Development: VS Code, Docker
- Browsers: Firefox, Chrome
- Media: Spotify, VLC, GIMP
- Communication: Slack, Discord

### 🔐 Security Features
- **SSH**: Ed25519 key generation with secure config
- **GPG**: Key generation with Git signing integration
- **Certificates**: System certificate management
- **Permissions**: Proper file/directory permissions

## 🏷️ Available Tags

| Tag | Description | Components |
|-----|-------------|------------|
| `foundation` | Base system setup | XDG, common directories |
| `packages` | Package management | Homebrew, APT, Flatpak |
| `tools` | Development tools | Mise, Python/UV, CLI tools |
| `development` | Dev environment | Git, editor, shell |
| `security` | Security setup | SSH, GPG keys |
| `macos` | macOS specific | System preferences, apps |
| `linux` | Linux specific | Packages, desktop apps |

## 🔍 Validation & Health Checks

The system includes comprehensive validation:

- ✅ **System Requirements**: Ansible version, disk space, permissions
- ✅ **Network Connectivity**: Package download sources
- ✅ **Configuration**: Git settings, Python versions
- ✅ **Tool Installation**: Verify installed tools work correctly
- ✅ **Security**: SSH/GPG key validation

Access validation report: `~/.cache/dotfiles_validation.txt`

## 🚨 Troubleshooting

### Common Issues

**Permission Denied**
```bash
chmod +x bootstrap.sh run.sh rollback.sh
```

**Ansible Not Found**
```bash
./bootstrap.sh  # Installs Ansible automatically
```

**Network Issues**
```bash
./run.sh --validate-only  # Check connectivity
```

**Git Configuration Missing**
```bash
# Set in group_vars/all.yml or run:
git config --global user.name "Your Name"
git config --global user.email "your@email.com"
```

### Debug Mode

```bash
# Maximum verbosity
./run.sh -vvv

# Check specific component
./run.sh --tags git --check -vv

# Validate before running
./run.sh --validate-only
```

### 📊 Logs

- **Current run**: `~/.cache/dotfiles/run_TIMESTAMP.log`
- **All logs**: `~/.cache/dotfiles/`
- **Ansible log**: `~/.cache/ansible.log`
- **Validation**: `~/.cache/dotfiles_validation.txt`

## 🔄 Backup System

Automatic backups are created before modifications:
- **Location**: `~/.dotfiles_backup/TIMESTAMP/`
- **Retention**: Configurable (default: keep last 10)
- **Contents**: All modified configuration files

## 🌟 Advanced Features

### 🔧 Environment Variables

All tools respect XDG Base Directory Specification:
```bash
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share" 
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_STATE_HOME="$HOME/.local/state"
```

### 🚀 Performance Features

- **Parallel execution**: Multiple Ansible forks
- **Fact caching**: Faster subsequent runs
- **SSH multiplexing**: Faster connections
- **Package caching**: Reduced download times
- **Idempotent operations**: Safe to re-run

### 🎨 Shell Enhancements

**Modern Aliases**:
```bash
ls → eza          # Better file listing
cat → bat         # Syntax highlighted cat
find → fd         # Faster find alternative
grep → ripgrep    # Faster grep alternative
cd → zoxide       # Smart directory jumping
```

**Development Functions**:
```bash
newproject python my-app    # Create new project from template
ssh-copy-key               # Copy SSH key to clipboard
weather london             # Get weather info
backup file.txt            # Quick file backup
```

## 🤝 Contributing

1. **Fork** the repository
2. **Create** a feature branch: `git checkout -b feature/amazing-feature`
3. **Test** your changes: `./run.sh --check`
4. **Commit** your changes: `git commit -m 'Add amazing feature'`
5. **Push** to branch: `git push origin feature/amazing-feature`
6. **Submit** a Pull Request

### 🧪 Testing

```bash
# Test on fresh system
./run.sh --check --validate-only

# Test specific components
./run.sh --tags git,editor --check

# Validate configuration
ansible-playbook site.yml --syntax-check
```

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- [XDG Base Directory Specification](https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html)
- [Ansible](https://www.ansible.com/) for automation
- [Mise](https://mise.jdx.dev/) for runtime management
- [UV](https://astral.sh/uv/) for Python package management
- [Neovim](https://neovim.io/) and the plugin ecosystem

## 📞 Support

- 🐛 **Issues**: [GitHub Issues](https://github.com/yourusername/dotfiles_v8/issues)
- 💬 **Discussions**: [GitHub Discussions](https://github.com/yourusername/dotfiles_v8/discussions)
- 📧 **Email**: your.email@example.com

---

<div align="center">

**Made with ❤️ for developers who care about their environment**

*"A professional development environment should be reproducible, secure, and delightful to use."*

</div>
