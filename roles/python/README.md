---
# Python Role

This role installs and configures Python using UV as the package manager and Python version manager.

## Features

- Installs UV package manager via multiple methods (curl, Homebrew, system package manager)
- Manages multiple Python versions
- Installs global development tools
- Configures XDG-compliant directory structure
- Sets up shell integration and aliases
- Creates project templates

## Requirements

- Ansible 2.9+
- Internet connection for downloading UV and Python versions

## Role Variables

### Python Configuration
- `python_versions`: List of Python versions to install (default: ["3.12", "3.11"])
- `python_default_version`: Default Python version (default: "3.12")

### UV Configuration
- `uv_install_method`: Installation method - curl, homebrew, or package_manager (default: "curl")
- `uv_version`: UV version to install (default: "latest")

### Global Tools
- `uv_global_tools`: List of tools to install globally with UV

### Directories
UV respects XDG Base Directory specification on Linux and uses appropriate macOS directories.

## Example Playbook

```yaml
- hosts: all
  roles:
    - role: python
      vars:
        python_versions:
          - "3.12"
          - "3.11"
          - "3.10"
        python_default_version: "3.12"
        uv_install_method: "curl"
        uv_global_tools:
          - name: ruff
            version: "latest"
          - name: black
            version: "latest"
```

## Dependencies

None

## License

MIT
