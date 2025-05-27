#!/bin/bash
set -e

# Colours for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Colour

echo -e "${BLUE}🚀 Bootstrapping dotfiles...${NC}"

# Detect OS
if [[ "$OSTYPE" == "darwin"* ]]; then
    OS="macos"
elif [[ -f /etc/arch-release ]]; then
    OS="arch"
elif [[ -f /etc/debian_version ]]; then
    OS="debian"
elif [[ -f /etc/fedora-release ]]; then
    OS="fedora"
else
    echo -e "${RED}❌ Unsupported OS. Please install Ansible manually.${NC}"
    exit 1
fi

echo -e "${YELLOW}📋 Detected OS: ${OS}${NC}"

# Install Ansible if not present
if ! command -v ansible &> /dev/null; then
    echo -e "${YELLOW}📦 Installing Ansible...${NC}"
    
    case $OS in
        macos)
            if ! command -v brew &> /dev/null; then
                echo -e "${YELLOW}🍺 Installing Homebrew...${NC}"
                /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
                eval "$(/opt/homebrew/bin/brew shellenv)"
            fi
            brew install ansible
            ;;
        arch)
            sudo pacman -S --noconfirm ansible
            ;;
        debian)
            sudo apt update && sudo apt install -y ansible
            ;;
        fedora)
            sudo dnf install -y ansible
            ;;
    esac
else
    echo -e "${GREEN}✅ Ansible already installed${NC}"
fi

# Install Ansible collections
echo -e "${YELLOW}📚 Installing Ansible collections...${NC}"
ansible-galaxy collection install community.general community.crypto

# Verify inventory
if [[ ! -f inventory.yml ]]; then
    echo -e "${YELLOW}📝 Creating inventory file...${NC}"
    cat > inventory.yml << EOF
---
all:
  hosts:
    localhost:
      ansible_connection: local
      ansible_python_interpreter: "{{ ansible_playbook_python }}"
  children:
    macos:
      hosts: {}
    linux:
      hosts: {}
EOF
    
    # Add localhost to appropriate group
    case $OS in
        macos)
            sed -i '' 's/macos:/macos:\
      hosts:\
        localhost:/' inventory.yml
            ;;
        *)
            sed -i 's/linux:/linux:\
      hosts:\
        localhost:/' inventory.yml
            ;;
    esac
fi

# Run syntax check
echo -e "${YELLOW}🔍 Checking Ansible syntax...${NC}"
ansible-playbook site.yml --syntax-check

# Run dry run
echo -e "${YELLOW}🧪 Running dry run...${NC}"
if ansible-playbook site.yml --check --diff; then
    echo -e "${GREEN}✅ Dry run successful${NC}"
else
    echo -e "${RED}❌ Dry run failed${NC}"
    exit 1
fi

# Confirm before running
echo -e "${YELLOW}❓ Ready to apply changes. Continue? (y/N)${NC}"
read -r response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
    echo -e "${BLUE}🎯 Running Ansible playbook...${NC}"
    ansible-playbook site.yml
    echo -e "${GREEN}✅ Dotfiles setup complete!${NC}"
    echo -e "${BLUE}🔄 Please restart your shell or run 'source ~/.zshrc'${NC}"
else
    echo -e "${YELLOW}⏸️  Setup cancelled${NC}"
fi
