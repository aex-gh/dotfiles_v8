#!/bin/bash
set -e

# Master ansible-lint fix script
cd ~/projects/personal/dotfiles_v8

echo "🚀 Running comprehensive ansible-lint fixes..."
echo "============================================"

# Make scripts executable
chmod +x fix-lint.sh fix-variables.sh fix-modules.sh

# Step 1: Run basic lint fixes
echo "Step 1: Basic lint fixes..."
./fix-lint.sh

# Step 2: Fix variable naming
echo "Step 2: Variable naming fixes..."
./fix-variables.sh

# Step 3: Fix module and command issues  
echo "Step 3: Module and command fixes..."
./fix-modules.sh

# Step 4: Test syntax after fixes
echo "Step 4: Testing syntax..."
if ansible-playbook site.yml --syntax-check; then
  echo "✅ Syntax check passed!"
else
  echo "❌ Syntax check failed - please review changes"
  exit 1
fi

# Step 5: Run ansible-lint to see remaining issues
echo "Step 5: Checking remaining lint issues..."
echo ""
echo "🔍 Remaining ansible-lint issues:"
echo "================================="

if ansible-lint --parseable; then
  echo "🎉 All ansible-lint issues resolved!"
else
  echo ""
  echo "📋 Summary of fixes applied:"
  echo "  ✅ Added FQCN to all core modules"
  echo "  ✅ Removed trailing spaces"
  echo "  ✅ Fixed meta file schema issues"
  echo "  ✅ Fixed galaxy tags"
  echo "  ✅ Added changed_when to commands"
  echo "  ✅ Fixed YAML truthy values"
  echo "  ✅ Fixed handler names"
  echo "  ✅ Added newlines at end of files"
  echo "  ✅ Fixed excessive blank lines"
  echo "  ✅ Applied variable naming fixes"
  echo ""
  echo "📝 Remaining issues may need manual review:"
  echo "  - Complex variable naming across roles"
  echo "  - Task key ordering"
  echo "  - Shell commands that could use specific modules"
  echo "  - Handler usage optimizations"
fi

echo ""
echo "🎯 Run './lint-simple.sh' to see current status"
