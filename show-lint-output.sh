#!/bin/bash

cd ~/projects/personal/dotfiles_v8

echo "🔍 Running ansible-lint with full output capture..."
echo "=================================================="

# Run ansible-lint and capture both stdout and stderr
echo "Running: ansible-lint"
echo ""

# Method 1: Direct execution with error handling
if ansible-lint 2>&1; then
    echo ""
    echo "✅ No issues found!"
else
    exit_code=$?
    echo ""
    echo "❌ Found issues (exit code: $exit_code)"
    echo ""
    echo "Trying with verbose output:"
    echo "=========================="
    ansible-lint -v 2>&1 | head -20
fi

echo ""
echo "List of files being checked:"
echo "==========================="
ansible-lint --list-files 2>/dev/null || echo "Could not list files"
