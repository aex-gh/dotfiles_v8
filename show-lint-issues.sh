#!/bin/bash

cd ~/projects/personal/dotfiles_v8

echo "🔍 Running ansible-lint to see actual issues..."
echo "================================================"

# Run ansible-lint and capture output
ansible-lint > lint_output.txt 2>&1
exit_code=$?

echo "Exit code: $exit_code"
echo ""
echo "First 30 lines of output:"
echo "========================="
head -30 lint_output.txt

echo ""
echo "========================="
echo "Full output saved to: lint_output.txt"
