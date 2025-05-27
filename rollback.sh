#!/bin/bash
set -e

# Rollback script for dotfiles
# This script can restore previous configurations

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

BACKUP_DIR="$HOME/.dotfiles_backup"
RESTORE_LIST="$HOME/.cache/dotfiles_restore.list"

usage() {
    cat << EOF
🔄 Dotfiles Rollback Script

USAGE:
    $0 [OPTIONS]

OPTIONS:
    --list                    List available backups
    --restore TIMESTAMP       Restore from specific backup
    --latest                  Restore from latest backup
    --dry-run                 Show what would be restored
    --help                    Show this help

EXAMPLES:
    $0 --list                 # Show available backup timestamps
    $0 --latest              # Restore latest backup
    $0 --restore 20240101_120000  # Restore specific backup
    $0 --dry-run --latest    # Preview latest restore

EOF
}

list_backups() {
    echo -e "${BLUE}📁 Available backups:${NC}"
    if [[ -d "$BACKUP_DIR" ]]; then
        find "$BACKUP_DIR" -maxdepth 1 -type d -name "[0-9]*" | sort -r | while read -r backup; do
            timestamp=$(basename "$backup")
            date_formatted=$(date -d "@${timestamp:0:8}" "+%Y-%m-%d %H:%M:%S" 2>/dev/null || echo "Unknown date")
            size=$(du -sh "$backup" 2>/dev/null | cut -f1)
            echo -e "  ${YELLOW}$timestamp${NC} - $date_formatted (${size})"
        done
    else
        echo -e "${YELLOW}⚠️  No backups found${NC}"
    fi
}

get_latest_backup() {
    if [[ -d "$BACKUP_DIR" ]]; then
        find "$BACKUP_DIR" -maxdepth 1 -type d -name "[0-9]*" | sort -r | head -1
    fi
}

restore_backup() {
    local backup_path="$1"
    local dry_run="$2"
    
    if [[ ! -d "$backup_path" ]]; then
        echo -e "${RED}❌ Backup not found: $backup_path${NC}"
        exit 1
    fi
    
    echo -e "${BLUE}🔄 Restoring from: $(basename "$backup_path")${NC}"
    
    # Create restore list
    : > "$RESTORE_LIST"
    
    while IFS= read -r -d '' file; do
        relative_path="${file#$backup_path/}"
        target_path="$HOME/$relative_path"
        
        if [[ "$dry_run" == "true" ]]; then
            echo -e "${YELLOW}Would restore:${NC} $relative_path"
        else
            # Create target directory if needed
            target_dir=$(dirname "$target_path")
            mkdir -p "$target_dir"
            
            # Backup current file if it exists
            if [[ -f "$target_path" ]]; then
                current_backup="${target_path}.rollback_$(date +%s)"
                cp "$target_path" "$current_backup"
                echo "$current_backup" >> "$RESTORE_LIST"
            fi
            
            # Restore file
            cp "$file" "$target_path"
            echo -e "${GREEN}✅ Restored:${NC} $relative_path"
        fi
    done < <(find "$backup_path" -type f -print0)
    
    if [[ "$dry_run" != "true" ]]; then
        echo -e "${GREEN}🎉 Rollback completed!${NC}"
        echo -e "${BLUE}📋 Current files backed up to .rollback_* files${NC}"
        echo -e "${YELLOW}⚠️  You may need to restart your shell${NC}"
    fi
}

# Parse arguments
DRY_RUN=false
ACTION=""
TIMESTAMP=""

while [[ $# -gt 0 ]]; do
    case $1 in
        --list)
            ACTION="list"
            shift
            ;;
        --restore)
            ACTION="restore"
            TIMESTAMP="$2"
            shift 2
            ;;
        --latest)
            ACTION="latest"
            shift
            ;;
        --dry-run)
            DRY_RUN=true
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

# Execute action
case "$ACTION" in
    list)
        list_backups
        ;;
    restore)
        backup_path="$BACKUP_DIR/$TIMESTAMP"
        restore_backup "$backup_path" "$DRY_RUN"
        ;;
    latest)
        latest_backup=$(get_latest_backup)
        if [[ -n "$latest_backup" ]]; then
            restore_backup "$latest_backup" "$DRY_RUN"
        else
            echo -e "${YELLOW}⚠️  No backups available${NC}"
            exit 1
        fi
        ;;
    *)
        echo -e "${RED}❌ No action specified${NC}"
        usage
        exit 1
        ;;
esac
