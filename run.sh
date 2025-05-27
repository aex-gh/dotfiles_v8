#!/bin/bash
set -e

# Colours for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m' 
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

# Script configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
LOG_DIR="$HOME/.cache/dotfiles"
LOG_FILE="$LOG_DIR/run_${TIMESTAMP}.log"

# Default options
DRY_RUN=false
TAGS=""
SKIP_TAGS=""
VERBOSE=""
VALIDATE_ONLY=false
BACKUP=true
PROFILE=false
LIST_TASKS=false
LIST_TAGS=false
SYNTAX_CHECK=false
LIMIT=""

# Create log directory
mkdir -p "$LOG_DIR"

# Logging function
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $*" | tee -a "$LOG_FILE"
}

# Usage function
usage() {
    cat << EOF
🚀 Dotfiles Management Script

USAGE:
    $0 [OPTIONS]

OPTIONS:
    --check, --dry-run         Run in check mode (no changes)
    --tags TAGS               Run only tasks with specified tags
    --skip-tags TAGS          Skip tasks with specified tags
    --limit HOSTS             Limit to specific hosts
    --validate-only           Only run validation checks
    --list-tasks              List all available tasks
    --list-tags               List all available tags
    --syntax-check            Check playbook syntax only
    --no-backup               Skip backup creation
    --profile                 Enable task profiling
    -v, -vv, -vvv            Verbose output levels
    -h, --help               Show this help

EXAMPLES:
    $0                                    # Run all tasks
    $0 --check                            # Dry run
    $0 --tags git,editor                  # Run only git and editor tasks
    $0 --skip-tags development            # Skip development tasks
    $0 --validate-only                    # Only validate system
    $0 --list-tags                        # Show available tags
    $0 --profile -vv                      # Run with profiling and verbose output

AVAILABLE TAGS:
    foundation    - XDG, common setup
    packages      - Package management (homebrew, linux)
    tools         - Development tools (mise, python)
    development   - Git, editor, shell setup
    security      - SSH, GPG key management
    macos         - macOS specific configuration
    linux         - Linux specific configuration

LOGS:
    Current run: $LOG_FILE
    All logs:    $LOG_DIR/

EOF
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --check|--dry-run)
            DRY_RUN=true
            shift
            ;;
        --tags)
            TAGS="$2"
            shift 2
            ;;
        --skip-tags)
            SKIP_TAGS="$2"
            shift 2
            ;;
        --limit)
            LIMIT="$2"
            shift 2
            ;;
        --validate-only)
            VALIDATE_ONLY=true
            TAGS="validate"
            shift
            ;;
        --list-tasks)
            LIST_TASKS=true
            shift
            ;;
        --list-tags)
            LIST_TAGS=true
            shift
            ;;
        --syntax-check)
            SYNTAX_CHECK=true
            shift
            ;;
        --no-backup)
            BACKUP=false
            shift
            ;;
        --profile)
            PROFILE=true
            shift
            ;;
        -v|--verbose)
            VERBOSE="-v"
            shift
            ;;
        -vv)
            VERBOSE="-vv"
            shift
            ;;
        -vvv)
            VERBOSE="-vvv"
            shift
            ;;
        -h|--help)
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

# Header
echo -e "${BLUE}"
echo "╔══════════════════════════════════════════════════════════════════════════════╗"
echo "║                           🚀 DOTFILES MANAGER                               ║"
echo "╚══════════════════════════════════════════════════════════════════════════════╝"
echo -e "${NC}"

log "Starting dotfiles run with PID $$"
log "Options: DRY_RUN=$DRY_RUN, TAGS=$TAGS, SKIP_TAGS=$SKIP_TAGS"

# Change to script directory
cd "$SCRIPT_DIR"

# Check prerequisites
echo -e "${YELLOW}🔍 Checking prerequisites...${NC}"

if ! command -v ansible >/dev/null 2>&1; then
    echo -e "${RED}❌ Ansible not found. Run bootstrap.sh first.${NC}"
    exit 1
fi

if [[ ! -f inventory.yml ]]; then
    echo -e "${RED}❌ inventory.yml not found. Run bootstrap.sh first.${NC}"
    exit 1
fi

if [[ ! -f site.yml ]]; then
    echo -e "${RED}❌ site.yml not found.${NC}"
    exit 1
fi

echo -e "${GREEN}✅ Prerequisites check passed${NC}"

# Build ansible-playbook command
CMD="ansible-playbook site.yml"

# Add common options
CMD="$CMD $VERBOSE"
CMD="$CMD --diff"

if [[ "$BACKUP" == "false" ]]; then
    CMD="$CMD -e skip_backup=true"
fi

if [[ "$PROFILE" == "true" ]]; then
    CMD="$CMD -e profile_tasks=true"
fi

# Handle special operations
if [[ "$LIST_TASKS" == "true" ]]; then
    echo -e "${CYAN}📋 Available tasks:${NC}"
    ansible-playbook site.yml --list-tasks
    exit 0
fi

if [[ "$LIST_TAGS" == "true" ]]; then
    echo -e "${CYAN}🏷️  Available tags:${NC}"
    ansible-playbook site.yml --list-tags
    exit 0
fi

if [[ "$SYNTAX_CHECK" == "true" ]]; then
    echo -e "${YELLOW}🔍 Checking syntax...${NC}"
    if ansible-playbook site.yml --syntax-check; then
        echo -e "${GREEN}✅ Syntax check passed${NC}"
        exit 0
    else
        echo -e "${RED}❌ Syntax check failed${NC}"
        exit 1
    fi
fi

# Add conditional options
if [[ "$DRY_RUN" == "true" ]]; then
    CMD="$CMD --check"
    echo -e "${YELLOW}🧪 Running in check mode (dry run)${NC}"
fi

if [[ -n "$TAGS" ]]; then
    CMD="$CMD --tags $TAGS"
    echo -e "${YELLOW}🏷️  Running tags: $TAGS${NC}"
fi

if [[ -n "$SKIP_TAGS" ]]; then
    CMD="$CMD --skip-tags $SKIP_TAGS"
    echo -e "${YELLOW}⏭️  Skipping tags: $SKIP_TAGS${NC}"
fi

if [[ -n "$LIMIT" ]]; then
    CMD="$CMD --limit $LIMIT"
    echo -e "${YELLOW}🎯 Limited to hosts: $LIMIT${NC}"
fi

# Pre-run validation
echo -e "${YELLOW}🔍 Running pre-flight checks...${NC}"
if ! ansible-playbook site.yml --syntax-check >/dev/null 2>&1; then
    echo -e "${RED}❌ Syntax check failed${NC}"
    exit 1
fi

if [[ "$VALIDATE_ONLY" == "true" ]]; then
    echo -e "${CYAN}🔍 Running validation only...${NC}"
else
    echo -e "${BLUE}▶️  Executing: $CMD${NC}"
fi

# Execute the command with logging
echo -e "${PURPLE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"

log "Executing: $CMD"
START_TIME=$(date +%s)

if eval "$CMD" 2>&1 | tee -a "$LOG_FILE"; then
    END_TIME=$(date +%s)
    DURATION=$((END_TIME - START_TIME))
    
    echo -e "${PURPLE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    
    if [[ "$DRY_RUN" == "false" && "$VALIDATE_ONLY" == "false" ]]; then
        echo -e "${GREEN}"
        echo "╔══════════════════════════════════════════════════════════════════════════════╗"
        echo "║                          ✅ SUCCESS - COMPLETED                              ║"
        echo "╚══════════════════════════════════════════════════════════════════════════════╝"
        echo -e "${NC}"
        echo -e "${GREEN}🎉 Dotfiles applied successfully!${NC}"
        echo -e "${BLUE}⏱️  Duration: ${DURATION}s${NC}"
        echo -e "${CYAN}📋 Log saved to: $LOG_FILE${NC}"
        echo ""
        echo -e "${YELLOW}📖 Next Steps:${NC}"
        echo -e "   1. Restart your terminal or run: ${CYAN}source ~/.profile${NC}"
        echo -e "   2. Verify installation: ${CYAN}mise doctor${NC}"
        echo -e "   3. Check SSH key: ${CYAN}ssh-copy-key${NC}"
        if command -v git >/dev/null 2>&1; then
            if [[ -z "$(git config --global user.name)" ]]; then
                echo -e "   4. Set Git credentials: ${CYAN}git config --global user.name 'Your Name'${NC}"
                echo -e "      Set Git email: ${CYAN}git config --global user.email 'you@example.com'${NC}"
            fi
        fi
    elif [[ "$DRY_RUN" == "true" ]]; then
        echo -e "${GREEN}✅ Dry run completed successfully!${NC}"
        echo -e "${BLUE}⏱️  Duration: ${DURATION}s${NC}"
        echo -e "${YELLOW}💡 Run without --check to apply changes${NC}"
    else
        echo -e "${GREEN}✅ Validation completed successfully!${NC}"
        echo -e "${BLUE}⏱️  Duration: ${DURATION}s${NC}"
    fi
    
    log "Completed successfully in ${DURATION}s"
    
else
    END_TIME=$(date +%s)
    DURATION=$((END_TIME - START_TIME))
    
    echo -e "${PURPLE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${RED}"
    echo "╔══════════════════════════════════════════════════════════════════════════════╗"
    echo "║                            ❌ FAILED - ERROR                                ║"
    echo "╚══════════════════════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
    echo -e "${RED}💥 Dotfiles run failed!${NC}"
    echo -e "${BLUE}⏱️  Duration: ${DURATION}s${NC}"
    echo -e "${CYAN}📋 Check log: $LOG_FILE${NC}"
    echo -e "${YELLOW}🔧 Troubleshooting:${NC}"
    echo -e "   1. Check the error messages above"
    echo -e "   2. Run with ${CYAN}--check${NC} to see what would change"
    echo -e "   3. Run with ${CYAN}-vvv${NC} for detailed output"
    echo -e "   4. Check individual components with ${CYAN}--tags${NC}"
    
    log "Failed after ${DURATION}s"
    exit 1
fi

# Cleanup old logs (keep last 10)
find "$LOG_DIR" -name "run_*.log" -type f | sort | head -n -10 | xargs rm -f 2>/dev/null || true

echo -e "${CYAN}📁 Log files cleaned up (keeping last 10 runs)${NC}"
