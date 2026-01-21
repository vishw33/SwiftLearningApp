#!/bin/bash

# Create GitHub repository using GitHub API
# You need to set GITHUB_TOKEN environment variable or replace YOUR_TOKEN below

REPO_NAME="SwiftLearningApp"
DESCRIPTION="Interactive iOS app for learning Swift 6 essentials with Q&A quizzes, topics, and code examples"

# Try to get token from environment or use placeholder
TOKEN=${GITHUB_TOKEN:-"YOUR_GITHUB_TOKEN_HERE"}

if [ "$TOKEN" = "YOUR_GITHUB_TOKEN_HERE" ]; then
    echo "⚠️  GitHub token not found. Please create the repository manually:"
    echo ""
    echo "1. Go to https://github.com/new"
    echo "2. Repository name: $REPO_NAME"
    echo "3. Description: $DESCRIPTION"
    echo "4. Choose Public or Private"
    echo "5. DO NOT initialize with README, .gitignore, or license"
    echo "6. Click 'Create repository'"
    echo ""
    echo "Then run these commands:"
    echo "  git remote add origin https://github.com/YOUR_USERNAME/$REPO_NAME.git"
    echo "  git push -u origin main"
    exit 1
fi

# Get username from token or API
USERNAME=$(curl -s -H "Authorization: token $TOKEN" https://api.github.com/user | grep -o '"login":"[^"]*' | cut -d'"' -f4)

if [ -z "$USERNAME" ]; then
    echo "❌ Failed to authenticate with GitHub. Please check your token."
    exit 1
fi

echo "✅ Authenticated as: $USERNAME"
echo "📦 Creating repository: $REPO_NAME"

# Create repository
RESPONSE=$(curl -s -w "\n%{http_code}" -X POST \
  -H "Authorization: token $TOKEN" \
  -H "Accept: application/vnd.github.v3+json" \
  https://api.github.com/user/repos \
  -d "{
    \"name\": \"$REPO_NAME\",
    \"description\": \"$DESCRIPTION\",
    \"private\": false
  }")

HTTP_CODE=$(echo "$RESPONSE" | tail -n1)
BODY=$(echo "$RESPONSE" | sed '$d')

if [ "$HTTP_CODE" = "201" ]; then
    echo "✅ Repository created successfully!"
    echo ""
    echo "🔗 Repository URL: https://github.com/$USERNAME/$REPO_NAME"
    echo ""
    echo "📤 Adding remote and pushing..."
    git remote add origin https://github.com/$USERNAME/$REPO_NAME.git 2>/dev/null || git remote set-url origin https://github.com/$USERNAME/$REPO_NAME.git
    git push -u origin main
    echo ""
    echo "✅ Done! Your code is now on GitHub."
else
    echo "❌ Failed to create repository. HTTP Code: $HTTP_CODE"
    echo "Response: $BODY"
    exit 1
fi
