#!/bin/bash
set -e

# Comprehensive ansible-lint auto-fix script
cd ~/projects/personal/dotfiles_v8

echo "🔧 Fixing ansible-lint issues automatically..."

# Fix 1: Add FQCN (ansible.builtin.) to all core modules
echo "  📦 Adding FQCN to core modules..."

find . -name "*.yml" -not -path "./.git/*" -exec sed -i '' \
  -e 's/^  file:/  ansible.builtin.file:/' \
  -e 's/^  template:/  ansible.builtin.template:/' \
  -e 's/^  copy:/  ansible.builtin.copy:/' \
  -e 's/^  shell:/  ansible.builtin.shell:/' \
  -e 's/^  command:/  ansible.builtin.command:/' \
  -e 's/^  package:/  ansible.builtin.package:/' \
  -e 's/^  apt:/  ansible.builtin.apt:/' \
  -e 's/^  dnf:/  ansible.builtin.dnf:/' \
  -e 's/^  user:/  ansible.builtin.user:/' \
  -e 's/^  systemd:/  ansible.builtin.systemd:/' \
  -e 's/^  debug:/  ansible.builtin.debug:/' \
  -e 's/^  assert:/  ansible.builtin.assert:/' \
  -e 's/^  set_fact:/  ansible.builtin.set_fact:/' \
  -e 's/^  stat:/  ansible.builtin.stat:/' \
  -e 's/^  find:/  ansible.builtin.find:/' \
  -e 's/^  get_url:/  ansible.builtin.get_url:/' \
  -e 's/^  lineinfile:/  ansible.builtin.lineinfile:/' \
  -e 's/^  blockinfile:/  ansible.builtin.blockinfile:/' \
  -e 's/^  git:/  ansible.builtin.git:/' \
  -e 's/^  pip:/  ansible.builtin.pip:/' \
  -e 's/^  uri:/  ansible.builtin.uri:/' \
  -e 's/^  slurp:/  ansible.builtin.slurp:/' \
  -e 's/^  known_hosts:/  ansible.builtin.known_hosts:/' \
  -e 's/^  include_tasks:/  ansible.builtin.include_tasks:/' \
  -e 's/^  apt_key:/  ansible.builtin.apt_key:/' \
  -e 's/^  apt_repository:/  ansible.builtin.apt_repository:/' \
  -e 's/^  yum_repository:/  ansible.builtin.yum_repository:/' \
  {} \;

# Fix 2: Remove trailing spaces
echo "  🧹 Removing trailing spaces..."
find . -name "*.yml" -not -path "./.git/*" -exec sed -i '' 's/[[:space:]]*$//' {} \;

# Fix 3: Fix meta files - make min_ansible_version a string
echo "  📋 Fixing meta files..."
find roles/*/meta/main.yml -exec sed -i '' 's/min_ansible_version: 2.9/min_ansible_version: "2.9"/' {} \;

# Fix 4: Fix galaxy tags - remove invalid characters
find roles/*/meta/main.yml -exec sed -i '' \
  -e 's/version-control/versioncontrol/' \
  -e 's/package-manager/packagemanager/' \
  -e 's/version-manager/versionmanager/' \
  {} \;

# Fix 5: Add changed_when: false to command/shell tasks that don't change things
echo "  ⚙️  Adding changed_when to commands..."
find . -name "*.yml" -not -path "./.git/*" -exec sed -i '' \
  -e '/--version$/a\
  changed_when: false' \
  -e '/doctor$/a\
  changed_when: false' \
  {} \;

# Fix 6: Fix YAML truthy values
find . -name "*.yml" -not -path "./.git/*" -exec sed -i '' \
  -e 's/: False$/: false/' \
  -e 's/: True$/: true/' \
  {} \;

# Fix 7: Fix handler names (capitalize first letter)
find roles/*/handlers/main.yml -exec sed -i '' \
  -e 's/name: reload/name: Reload/' \
  -e 's/name: update/name: Update/' \
  {} \;

# Fix 8: Add newlines at end of files where missing
find . -name "*.yml" -not -path "./.git/*" -exec bash -c 'if [ "$(tail -c1 "$1" | wc -l)" -eq 0 ]; then echo "" >> "$1"; fi' _ {} \;

# Fix 9: Reduce excessive blank lines
find . -name "*.yml" -not -path "./.git/*" -exec sed -i '' '/^$/N;/^\n$/d' {} \;

echo "✅ Automated fixes complete!"
echo ""
echo "🔍 Remaining issues that need manual attention:"
echo "  1. Variable naming (role prefix requirements)"
echo "  2. Some shell commands that should use specific modules"
echo "  3. Key ordering in some tasks"
echo "  4. Handler usage recommendations"
echo ""
echo "Run ansible-lint again to see remaining issues."
