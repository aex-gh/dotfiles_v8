#!/bin/bash

# Quick fix for common ansible-lint issues
cd ~/projects/personal/dotfiles_v8

echo "🔧 Applying common ansible-lint fixes..."

# Fix 1: Add changed_when: false to shell/command tasks that don't change anything
find roles -name "*.yml" -exec sed -i.bak 's/register: .*_version$/&\n  changed_when: false/' {} \;
find roles -name "*.yml" -exec sed -i.bak '/shell:.*--version/a\  changed_when: false' {} \;

# Fix 2: Add explicit file permissions where missing
find roles -name "*.yml" -exec sed -i.bak 's/state: directory$/&\n    mode: '"'"'0755'"'"'/' {} \;

# Remove backup files
find roles -name "*.bak" -delete

echo "✅ Applied common fixes"
echo "🔍 Run ansible-lint again to see remaining issues"
