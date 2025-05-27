#!/bin/bash
set -e

# Ansible-lint script for dotfiles_v8
# Run comprehensive linting with reporting

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LINT_LOG="$HOME/.cache/dotfiles_lint.log"

# Default options
FIX_ISSUES=false
VERBOSE=false
STRICT=false

usage() {
    cat << EOF
🔍 Ansible Lint Script for Dotfiles

USAGE:
    $0 [OPTIONS]

OPTIONS:
    --fix                 Auto-fix issues where possible
    --strict              Use strict mode (all warnings as errors)
    --verbose             Verbose output
    --help                Show this help

EXAMPLES:
    $0                    # Basic linting
    $0 --fix              # Auto-fix issues
    $0 --strict           # Strict mode
    $0 --verbose --fix    # Verbose with auto-fix

EOF
}

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --fix)
            FIX_ISSUES=true
            shift
            ;;
        --strict)
            STRICT=true
            shift
            ;;
        --verbose)
            VERBOSE=true
            shift
            ;;
        --help)
            usage
            exit 0
            ;;
        *)
            echo -e "${RED}❌ Unknown option: $1${NC}"
            usage
            exit 1
            ;;
    esac
done

cd "$SCRIPT_DIR"

echo -e "${BLUE}🔍 Running Ansible Lint on Dotfiles${NC}"
echo "══════════════════════════════════════════"

# Check if ansible-lint is installed
if ! command -v ansible-lint >/dev/null 2>&1; then
    echo -e "${RED}❌ ansible-lint not found${NC}"
    echo -e "${YELLOW}Install with: pip install ansible-lint${NC}"
    exit 1
fi

echo -e "${BLUE}📋 Ansible-lint version:${NC} $(ansible-lint --version | head -1)"
echo ""

# Build command
CMD="ansible-lint"

if [[ "$VERBOSE" == "true" ]]; then
    CMD="$CMD -v"
fi

if [[ "$FIX_ISSUES" == "true" ]]; then
    CMD="$CMD --fix"
    echo -e "${YELLOW}🔧 Auto-fix mode enabled${NC}"
fi

if [[ "$STRICT" == "true" ]]; then
    CMD="$CMD --strict"
    echo -e "${YELLOW}⚠️ Strict mode enabled${NC}"
fi

echo -e "${BLUE}▶️ Running: $CMD${NC}"
echo ""

# Create log directory
mkdir -p "$(dirname "$LINT_LOG")"

# Run ansible-lint
if $CMD 2>&1 | tee "$LINT_LOG"; then
    echo ""
    echo -e "${GREEN}✅ Ansible-lint completed successfully!${NC}"
    
    # Count issues more robustly
    if [[ -f "$LINT_LOG" ]]; then
        warning_count=0
        error_count=0
        
        # Count warnings
        if grep -q "WARNING" "$LINT_LOG" 2>/dev/null; then
            warning_count=$(grep -c "WARNING" "$LINT_LOG" 2>/dev/null | head -1)
        fi
        
        # Count errors  
        if grep -q "ERROR" "$LINT_LOG" 2>/dev/null; then
            error_count=$(grep -c "ERROR" "$LINT_LOG" 2>/dev/null | head -1)
        fi
        
        # Ensure we have numeric values
        warning_count=${warning_count:-0}
        error_count=${error_count:-0}
        
        if [[ "$warning_count" -gt 0 ]] || [[ "$error_count" -gt 0 ]]; then
            echo -e "${YELLOW}📊 Summary: $warning_count warnings, $error_count errors${NC}"
        else
            echo -e "${GREEN}🎉 No issues found!${NC}"
        fi
    else
        echo -e "${GREEN}🎉 No issues found!${NC}"
    fi
    
else
    echo ""
    echo -e "${RED}❌ Ansible-lint found issues${NC}"
    echo -e "${BLUE}📋 Check log: $LINT_LOG${NC}"
    echo ""
    echo -e "${YELLOW}🔧 Common fixes:${NC}"
    echo "  - Fix YAML formatting issues"
    echo "  - Add task names where missing"
    echo "  - Use specific Ansible modules instead of shell/command"
    echo "  - Check file permissions and paths"
    echo ""
    echo -e "${YELLOW}💡 Try running with --fix to auto-correct issues${NC}"
    exit 1
fi

echo ""
echo -e "${BLUE}📋 Full log saved to: $LINT_LOG${NC}"

# Show configuration info
echo ""
echo -e "${BLUE}⚙️ Configuration:${NC}"
echo "  Config file: .ansible-lint"
echo "  Profile: production"

# Get rule count safely
rule_count="unknown"
if command -v ansible-lint >/dev/null 2>&1; then
    rule_count=$(ansible-lint --list-rules 2>/dev/null | wc -l 2>/dev/null | tr -d ' ' || echo "unknown")
fi
echo "  Rules: $rule_count available"
