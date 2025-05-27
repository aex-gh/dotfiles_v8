#!/bin/bash
set -e

# Fix variable naming issues - add role prefixes
cd ~/projects/personal/dotfiles_v8

echo "🏷️ Fixing variable naming issues..."

# Common role - add common_ prefix
sed -i '' \
  -e 's/^shell_config_dir:/common_shell_config_dir:/' \
  -e 's/^base_environment:/common_base_environment:/' \
  -e 's/^setup_shell_integration:/common_setup_shell_integration:/' \
  -e 's/^create_profile_backup:/common_create_profile_backup:/' \
  roles/common/defaults/main.yml

# Update references to renamed common variables
find . -name "*.yml" -not -path "./.git/*" -exec sed -i '' \
  -e 's/{{ shell_config_dir }}/{{ common_shell_config_dir }}/' \
  -e 's/{{ base_environment }}/{{ common_base_environment }}/' \
  {} \;

# Development role - add development_ prefix  
sed -i '' \
  -e 's/^ssh_key_type:/development_ssh_key_type:/' \
  -e 's/^ssh_key_bits:/development_ssh_key_bits:/' \
  -e 's/^ssh_key_comment:/development_ssh_key_comment:/' \
  -e 's/^ssh_config_strict_host_key_checking:/development_ssh_config_strict_host_key_checking:/' \
  -e 's/^ssh_config_user_known_hosts_file:/development_ssh_config_user_known_hosts_file:/' \
  -e 's/^gpg_key_type:/development_gpg_key_type:/' \
  -e 's/^gpg_key_length:/development_gpg_key_length:/' \
  -e 's/^gpg_key_usage:/development_gpg_key_usage:/' \
  -e 's/^gpg_subkey_usage:/development_gpg_subkey_usage:/' \
  -e 's/^gpg_expire_date:/development_gpg_expire_date:/' \
  -e 's/^gpg_name_real:/development_gpg_name_real:/' \
  -e 's/^gpg_name_email:/development_gpg_name_email:/' \
  -e 's/^dev_directories:/development_dev_directories:/' \
  -e 's/^setup_certificates:/development_setup_certificates:/' \
  -e 's/^cert_directory:/development_cert_directory:/' \
  -e 's/^configure_git_signing:/development_configure_git_signing:/' \
  -e 's/^setup_development_aliases:/development_setup_development_aliases:/' \
  -e 's/^create_project_templates:/development_create_project_templates:/' \
  -e 's/^setup_ssh_keys:/development_setup_ssh_keys:/' \
  -e 's/^setup_gpg_keys:/development_setup_gpg_keys:/' \
  -e 's/^setup_development_directories:/development_setup_development_directories:/' \
  -e 's/^configure_development_environment:/development_configure_development_environment:/' \
  roles/development/defaults/main.yml

# Update references in development role tasks
find roles/development -name "*.yml" -exec sed -i '' \
  -e 's/{{ ssh_key_type }}/{{ development_ssh_key_type }}/' \
  -e 's/{{ ssh_key_bits }}/{{ development_ssh_key_bits }}/' \
  -e 's/{{ ssh_key_comment }}/{{ development_ssh_key_comment }}/' \
  -e 's/{{ ssh_config_strict_host_key_checking }}/{{ development_ssh_config_strict_host_key_checking }}/' \
  -e 's/{{ ssh_config_user_known_hosts_file }}/{{ development_ssh_config_user_known_hosts_file }}/' \
  -e 's/{{ gpg_key_type }}/{{ development_gpg_key_type }}/' \
  -e 's/{{ gpg_key_length }}/{{ development_gpg_key_length }}/' \
  -e 's/{{ gpg_key_usage }}/{{ development_gpg_key_usage }}/' \
  -e 's/{{ gpg_subkey_usage }}/{{ development_gpg_subkey_usage }}/' \
  -e 's/{{ gpg_expire_date }}/{{ development_gpg_expire_date }}/' \
  -e 's/{{ gpg_name_real }}/{{ development_gpg_name_real }}/' \
  -e 's/{{ gpg_name_email }}/{{ development_gpg_name_email }}/' \
  -e 's/{{ dev_directories }}/{{ development_dev_directories }}/' \
  -e 's/{{ cert_directory }}/{{ development_cert_directory }}/' \
  {} \;

echo "✅ Variable naming fixes applied!"
echo ""
echo "⚠️  Note: This is a partial fix. You may need to:"
echo "  1. Update other role variable references"
echo "  2. Check group_vars for consistency"
echo "  3. Test the playbook after changes"
