---
# Mise Role

This role installs and configures Mise (formerly rtx), a polyglot runtime manager for managing development tool versions.

## Features

- Installs Mise via multiple methods (curl, Homebrew, system package manager)
- Manages multiple runtime versions (Node.js, Python, Go, Rust, etc.)
- XDG Base Directory compliant configuration
- Shell integration for automatic version switching
- Global tool installation and management
- Custom aliases and completion
- Task runner integration

## Requirements

- Ansible 2.9+
- Internet connection for downloading Mise and runtimes
- Build tools for compiling some runtimes (automatically handled by Mise)

## Role Variables

### Installation
- `mise_install_method`: Installation method - curl, homebrew, or package_manager (default: "curl")
- `mise_version`: Mise version to install (default: "latest")

### Tools Configuration
- `mise_global_tools`: List of tools to install globally with their versions

### Directories
Mise respects XDG Base Directory specification on Linux and uses appropriate macOS directories.

### Configuration
- `mise_config`: Mise configuration settings
- `mise_env_vars`: Environment variables for Mise

## Example Playbook

```yaml
- hosts: all
  roles:
    - role: mise
      vars:
        mise_install_method: "curl"
        mise_global_tools:
          - name: node
            version: "20"
          - name: python
            version: "3.12"
          - name: go
            version: "latest"
          - name: rust
            version: "stable"
```

## Global Tools

The role installs common development tools by default:
- Node.js (LTS)
- Python (3.12)
- Go (latest)
- Rust (latest)
- Terraform (latest)
- kubectl (latest)
- Various CLI tools (jq, yq, fzf, ripgrep, etc.)

## Shell Integration

The role sets up shell integration for:
- Automatic version switching based on `.tool-versions` files
- Tab completion
- Useful aliases (mls, mi, mg, etc.)
- Environment variable management

## Tasks

Global tasks are available via `mise run`:
- `versions`: Show installed tool versions
- `outdated`: Show outdated tools
- `doctor`: Run mise doctor
- `sync`: Install missing tools
- `upgrade-all`: Upgrade all tools

## Dependencies

None

## License

MIT
