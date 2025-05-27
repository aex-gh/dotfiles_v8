#!/bin/bash

cd ~/projects/personal/dotfiles_v8

echo "🔍 Debugging ansible-lint..."
echo "============================"

echo "📁 Current directory: $(pwd)"
echo ""

echo "📋 Checking ansible-lint installation:"
which ansible-lint
ansible-lint --version 2>&1 | head -3
echo ""

echo "📋 Available YAML files:"
find . -name "*.yml" -o -name "*.yaml" | head -10
echo ""

echo "📋 Testing ansible-lint on site.yml specifically:"
echo "------------------------------------------------"
ansible-lint site.yml 2>&1 | head -10
echo ""

echo "📋 Testing ansible-lint with maximum verbosity:"
echo "-----------------------------------------------"
ansible-lint -vvv 2>&1 | head -15
echo ""

echo "📋 Checking for .ansible-lint config:"
if [[ -f .ansible-lint ]]; then
    echo "✅ Found .ansible-lint"
    echo "First 10 lines:"
    head -10 .ansible-lint
else
    echo "❌ No .ansible-lint found"
fi
echo ""

echo "📋 Testing without config file:"
echo "------------------------------"
mv .ansible-lint .ansible-lint.bak 2>/dev/null || true
ansible-lint site.yml 2>&1 | head -10
mv .ansible-lint.bak .ansible-lint 2>/dev/null || true
