#!/bin/bash

echo "🔍 Debugging ansible-lint setup"
echo "================================"

cd ~/projects/personal/dotfiles_v8

echo "📁 Current directory: $(pwd)"
echo ""

echo "📋 Ansible-lint version:"
ansible-lint --version
echo ""

echo "📋 Available YAML files:"
find . -name "*.yml" -o -name "*.yaml" | head -10
echo ""

echo "📋 Ansible-lint configuration:"
if [[ -f .ansible-lint ]]; then
    echo "✅ .ansible-lint exists"
    cat .ansible-lint
else
    echo "❌ .ansible-lint not found"
fi
echo ""

echo "📋 Testing ansible-lint on site.yml directly:"
ansible-lint site.yml -v
echo ""

echo "📋 Testing ansible-lint on entire project:"
ansible-lint . -v
echo ""

echo "📋 Checking for ansible-lint rules:"
ansible-lint --list-rules | head -5
