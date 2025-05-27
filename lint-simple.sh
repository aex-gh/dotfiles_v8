#!/bin/bash
set -e

# Simple ansible-lint runner
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

cd "$(dirname "$0")"

echo -e "${BLUE}🔍 Running Ansible Lint${NC}"
echo "═══════════════════════════"

# Check if ansible-lint is installed
if ! command -v ansible-lint >/dev/null 2>&1; then
    echo -e "${RED}❌ ansible-lint not found${NC}"
    echo -e "${YELLOW}Install with: pip install ansible-lint${NC}"
    exit 1
fi

# Build command based on arguments
CMD="ansible-lint"
case "${1:-}" in
    --fix)
        CMD="$CMD --fix"
        echo -e "${YELLOW}🔧 Auto-fix mode enabled${NC}"
        ;;
    --strict)
        CMD="$CMD --strict"
        echo -e "${YELLOW}⚠️ Strict mode enabled${NC}"
        ;;
    --verbose|-v)
        CMD="$CMD -v"
        echo -e "${YELLOW}📝 Verbose mode enabled${NC}"
        ;;
    --help)
        echo "Usage: $0 [--fix|--strict|--verbose|--help]"
        exit 0
        ;;
esac

echo -e "${BLUE}▶️ Running: $CMD${NC}"
echo ""

# Run ansible-lint
if $CMD; then
    echo ""
    echo -e "${GREEN}✅ Ansible-lint completed successfully!${NC}"
else
    echo ""
    echo -e "${RED}❌ Ansible-lint found issues${NC}"
    echo -e "${YELLOW}💡 Try: $0 --fix${NC}"
    exit 1
fi
