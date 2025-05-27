#!/bin/bash

# Direct ansible-lint output - no fancy formatting
cd ~/projects/personal/dotfiles_v8

echo "=== ANSIBLE-LINT OUTPUT ==="
ansible-lint
echo "=== END OUTPUT ==="
