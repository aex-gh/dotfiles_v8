#!/bin/bash

echo "🧪 Testing ansible-lint configuration..."
echo

# Test the linting
echo "Running ansible-lint on site.yml..."
if ansible-lint site.yml > /tmp/lint_test.out 2>&1; then
    echo "✅ ansible-lint passed successfully!"
    echo
    echo "📋 Summary:"
    echo "   - All critical syntax errors fixed"
    echo "   - FQCN issues resolved"
    echo "   - YAML structure corrected"
    echo "   - Appropriate rules skipped for personal dotfiles"
    echo
    echo "🎉 Your Ansible playbook is now lint-compliant!"
else
    echo "❌ Some issues remain. Check /tmp/lint_test.out for details:"
    echo
    cat /tmp/lint_test.out
    echo
    echo "💡 If these are acceptable for your use case, you can add them to skip_list in .ansible-lint"
fi

echo
echo "🚀 To run your playbook:"
echo "   ansible-playbook -i inventory.yml site.yml"
echo
echo "📝 To check specific files:"
echo "   ansible-lint roles/*/tasks/*.yml"
echo "   ansible-lint playbooks/*.yml"
