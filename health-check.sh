#!/bin/bash
set -e

# Health check script for dotfiles
# Validates that all components are working correctly

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

HEALTH_LOG="$HOME/.cache/dotfiles_health.log"
ISSUES_FOUND=0

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $*" | tee -a "$HEALTH_LOG"
}

check_status() {
    local name="$1"
    local command="$2"
    local expected="$3"
    
    echo -n "  Checking $name... "
    
    if eval "$command" >/dev/null 2>&1; then
        if [[ -n "$expected" ]]; then
            result=$(eval "$command" 2>/dev/null | head -1)
            if [[ "$result" == *"$expected"* ]]; then
                echo -e "${GREEN}✅ OK${NC} ($result)"
                log "✅ $name: OK ($result)"
            else
                echo -e "${YELLOW}⚠️ WARNING${NC} ($result)"
                log "⚠️ $name: WARNING ($result)"
                ((ISSUES_FOUND++))
            fi
        else
            echo -e "${GREEN}✅ OK${NC}"
            log "✅ $name: OK"
        fi
    else
        echo -e "${RED}❌ FAILED${NC}"
        log "❌ $name: FAILED"
        ((ISSUES_FOUND++))
    fi
}

check_file() {
    local name="$1"
    local filepath="$2"
    local expected_content="$3"
    
    echo -n "  Checking $name... "
    
    if [[ -f "$filepath" ]]; then
        if [[ -n "$expected_content" ]]; then
            if grep -q "$expected_content" "$filepath" 2>/dev/null; then
                echo -e "${GREEN}✅ OK${NC}"
                log "✅ $name: OK"
            else
                echo -e "${YELLOW}⚠️ MISSING CONTENT${NC}"
                log "⚠️ $name: Missing expected content"
                ((ISSUES_FOUND++))
            fi
        else
            echo -e "${GREEN}✅ EXISTS${NC}"
            log "✅ $name: EXISTS"
        fi
    else
        echo -e "${RED}❌ NOT FOUND${NC}"
        log "❌ $name: NOT FOUND"
        ((ISSUES_FOUND++))
    fi
}

echo -e "${BLUE}"
echo "╔══════════════════════════════════════════════════════════════════════════════╗"
echo "║                           🏥 DOTFILES HEALTH CHECK                          ║"
echo "╚══════════════════════════════════════════════════════════════════════════════╝"
echo -e "${NC}"

log "Starting health check"

# System Health
echo -e "${YELLOW}🔍 System Health${NC}"
check_status "Ansible" "ansible --version" "ansible"
check_status "Git" "git --version" "git version"
check_status "Python" "python3 --version" "Python 3"
check_status "SSH" "ssh -V" "OpenSSH"

# XDG Directories
echo -e "\n${YELLOW}📁 XDG Directories${NC}"
check_file "XDG Config" "$HOME/.config" ""
check_file "XDG Data" "$HOME/.local/share" ""
check_file "XDG Cache" "$HOME/.cache" ""
check_file "XDG Bin" "$HOME/.local/bin" ""

# Shell Configuration  
echo -e "\n${YELLOW}🐚 Shell Configuration${NC}"
check_file "Shell Profile" "$HOME/.profile" "XDG_CONFIG_HOME"
check_file "ZSH Config" "$HOME/.config/zsh/zshrc" ""
check_file "Shell Environment" "$HOME/.config/shell/environment" ""
check_file "Shell Aliases" "$HOME/.config/shell/aliases" ""

# Development Tools
echo -e "\n${YELLOW}🛠️ Development Tools${NC}"
check_status "Mise" "mise --version" "mise"
check_status "UV" "uv --version" "uv"
check_status "Node.js" "node --version" "v"
check_status "Python" "python3 --version" "Python"
check_status "Neovim" "nvim --version" "NVIM"

# Git Configuration
echo -e "\n${YELLOW}📝 Git Configuration${NC}"
check_status "Git User Name" "git config --global user.name" ""
check_status "Git User Email" "git config --global user.email" "@"
check_file "Git Config" "$HOME/.config/git/config" "user"
check_file "Git Ignore" "$HOME/.config/git/ignore" ""

# SSH/Security
echo -e "\n${YELLOW}🔐 Security Configuration${NC}"
check_file "SSH Config" "$HOME/.config/ssh/config" "Host"
check_file "SSH Private Key" "$HOME/.local/share/ssh/id_ed25519" ""
check_file "SSH Public Key" "$HOME/.local/share/ssh/id_ed25519.pub" "ssh-ed25519"

# Editor Configuration
echo -e "\n${YELLOW}📄 Editor Configuration${NC}"
check_file "Neovim Init" "$HOME/.config/nvim/init.lua" ""
check_file "Neovim Plugins" "$HOME/.config/nvim/lua/plugins/init.lua" ""

# Package Managers
echo -e "\n${YELLOW}📦 Package Managers${NC}"
if [[ "$OSTYPE" == "darwin"* ]]; then
    check_status "Homebrew" "brew --version" "Homebrew"
    check_status "MAS" "mas version" ""
else
    if command -v apt >/dev/null 2>&1; then
        check_status "APT" "apt --version" "apt"
    fi
    if command -v pacman >/dev/null 2>&1; then
        check_status "Pacman" "pacman --version" "Pacman"
    fi
    if command -v dnf >/dev/null 2>&1; then
        check_status "DNF" "dnf --version" ""
    fi
    check_status "Flatpak" "flatpak --version" "Flatpak"
fi

# Network Connectivity
echo -e "\n${YELLOW}🌐 Network Connectivity${NC}"
check_status "GitHub" "curl -s --connect-timeout 5 https://github.com" ""
check_status "Package Sources" "curl -s --connect-timeout 5 https://astral.sh/uv" ""

# Performance Check
echo -e "\n${YELLOW}⚡ Performance${NC}"
shell_startup_time=$(time (zsh -i -c exit) 2>&1 | grep real | awk '{print $2}')
echo "  Shell startup time: ${shell_startup_time:-unknown}"

# Summary
echo -e "\n${BLUE}📊 Health Check Summary${NC}"
echo "────────────────────────────────────────"

if [[ $ISSUES_FOUND -eq 0 ]]; then
    echo -e "${GREEN}🎉 All systems operational! No issues found.${NC}"
    log "Health check completed: ALL GOOD"
else
    echo -e "${YELLOW}⚠️ Found $ISSUES_FOUND issue(s) that may need attention.${NC}"
    echo -e "${BLUE}💡 Check the log for details: $HEALTH_LOG${NC}"
    log "Health check completed: $ISSUES_FOUND issues found"
fi

echo -e "\n${CYAN}📋 Detailed log: $HEALTH_LOG${NC}"
echo -e "${CYAN}🔧 To fix issues, try: ./run.sh --tags foundation,tools${NC}"

exit $ISSUES_FOUND
