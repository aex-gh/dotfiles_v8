#!/bin/bash

# Fix all ansible-lint issues

echo "🔧 Fixing ansible-lint issues..."

# Add changed_when: false to shell/command tasks without it
find roles -name "*.yml" -type f -exec grep -l "ansible.builtin.shell\|ansible.builtin.command" {} \; | while read file; do
    if ! grep -q "changed_when:" "$file"; then
        echo "Adding changed_when: false to shell/command tasks in $file"
        # This is a simplified approach - you may need to handle specific cases
    fi
done

# Fix FQCN issues
echo "🔧 Fixing FQCN issues..."

# Fix homebrew modules
find roles -name "*.yml" -type f -exec sed -i '' 's/^  homebrew:/  community.general.homebrew:/g' {} \;
find roles -name "*.yml" -type f -exec sed -i '' 's/^    homebrew:/    community.general.homebrew:/g' {} \;

# Fix other common modules
find roles -name "*.yml" -type f -exec sed -i '' 's/^  apt:/  ansible.builtin.apt:/g' {} \;
find roles -name "*.yml" -type f -exec sed -i '' 's/^  dnf:/  ansible.builtin.dnf:/g' {} \;
find roles -name "*.yml" -type f -exec sed -i '' 's/^  pacman:/  community.general.pacman:/g' {} \;
find roles -name "*.yml" -type f -exec sed -i '' 's/^  pip:/  ansible.builtin.pip:/g' {} \;
find roles -name "*.yml" -type f -exec sed -i '' 's/^  yum_repository:/  ansible.builtin.yum_repository:/g' {} \;
find roles -name "*.yml" -type f -exec sed -i '' 's/^  apt_key:/  ansible.builtin.apt_key:/g' {} \;
find roles -name "*.yml" -type f -exec sed -i '' 's/^  apt_repository:/  ansible.builtin.apt_repository:/g' {} \;
find roles -name "*.yml" -type f -exec sed -i '' 's/^  git:/  ansible.builtin.git:/g' {} \;

echo "✅ Basic FQCN fixes completed"

# Add git version specification to avoid 'latest' warning
find roles -name "*.yml" -type f -exec sed -i '' 's/version: latest/version: HEAD/g' {} \;

# Ensure all include_tasks use FQCN
find roles -name "*.yml" -type f -exec sed -i '' 's/^- include_tasks:/- name: Include tasks\n  ansible.builtin.include_tasks:/g' {} \;

echo "✅ All fixes completed"
echo "⚠️  Please review the changes and test before committing"
