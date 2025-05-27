#!/bin/bash

cd ~/projects/personal/dotfiles_v8

echo "🔍 Comprehensive ansible-lint troubleshooting"
echo "============================================="

echo "1. Ansible-lint version and info:"
ansible-lint --version 2>&1 || echo "Version command failed"
echo ""

echo "2. Python version:"
python3 --version
echo ""

echo "3. Ansible version:"
ansible --version | head -3
echo ""

echo "4. Current directory contents:"
ls -la *.yml 2>/dev/null || echo "No .yml files found"
echo ""

echo "5. Testing with absolute minimal config:"
cat > .test-ansible-lint << 'EOF'
skip_list: []
EOF

echo "6. Running with test config:"
ansible-lint -c .test-ansible-lint site.yml 2>&1 || echo "Test config failed"
echo ""

echo "7. Running without any config:"
ansible-lint --nocolor --offline site.yml 2>&1 || echo "No config failed"
echo ""

echo "8. Check if collections are needed:"
ansible-galaxy collection list 2>/dev/null | grep -E "(community|ansible)" || echo "Collections check failed"
echo ""

echo "9. Test with python ansible-lint directly:"
python3 -c "
import sys
try:
    import ansiblelint
    print(f'✅ ansible-lint module found: {ansiblelint.__version__}')
except ImportError as e:
    print(f'❌ Import error: {e}')
except Exception as e:
    print(f'❌ Other error: {e}')
"

echo ""
echo "10. Environment check:"
echo "HOME: $HOME"
echo "PWD: $PWD"
echo "USER: $USER"

# Clean up
rm -f .test-ansible-lint
