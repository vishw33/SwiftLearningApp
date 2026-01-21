#!/bin/bash

# Script to push SwiftLearningApp to GitHub
# Usage: ./push_to_github.sh YOUR_GITHUB_USERNAME

if [ -z "$1" ]; then
    echo "❌ Error: GitHub username required"
    echo ""
    echo "Usage: ./push_to_github.sh YOUR_GITHUB_USERNAME"
    echo ""
    echo "Example: ./push_to_github.sh johndoe"
    exit 1
fi

USERNAME=$1
REPO_NAME="SwiftLearningApp"

echo "🚀 Pushing SwiftLearningApp to GitHub..."
echo "📦 Repository: https://github.com/$USERNAME/$REPO_NAME"
echo ""

# Check if remote already exists
if git remote get-url origin > /dev/null 2>&1; then
    echo "⚠️  Remote 'origin' already exists. Updating URL..."
    git remote set-url origin "https://github.com/$USERNAME/$REPO_NAME.git"
else
    echo "➕ Adding remote 'origin'..."
    git remote add origin "https://github.com/$USERNAME/$REPO_NAME.git"
fi

echo "📤 Pushing to GitHub..."
git push -u origin main

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Success! Your code is now on GitHub:"
    echo "   https://github.com/$USERNAME/$REPO_NAME"
else
    echo ""
    echo "❌ Push failed. Make sure:"
    echo "   1. The repository exists on GitHub"
    echo "   2. You have push access"
    echo "   3. Your GitHub credentials are configured"
    echo ""
    echo "If you haven't created the repository yet, go to:"
    echo "   https://github.com/new"
    echo "   Name: $REPO_NAME"
    echo "   DO NOT initialize with README, .gitignore, or license"
fi
