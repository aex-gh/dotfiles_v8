# Set executable permissions on scripts
chmod +x bootstrap.sh run.sh rollback.sh health-check.sh

echo "✅ All scripts are now executable"
echo ""
echo "🚀 Ready to run:"
echo "  ./bootstrap.sh    # First-time setup"
echo "  ./run.sh          # Apply dotfiles"
echo "  ./rollback.sh     # Restore backups" 
echo "  ./health-check.sh # Validate system"
