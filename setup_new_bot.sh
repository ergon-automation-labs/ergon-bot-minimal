#!/bin/bash
set -euo pipefail

# Setup script for new bot based on template

echo "🤖 Bot Army Minimal Template Setup"
echo ""

# Prompt for bot details
read -p "Bot name (snake_case, e.g. my_task_bot): " BOT_APP_NAME
read -p "Release name (default: ${BOT_APP_NAME}): " BOT_RELEASE_NAME
BOT_RELEASE_NAME="${BOT_RELEASE_NAME:-${BOT_APP_NAME}}"

read -p "Bot title (e.g. My Task Bot): " BOT_NAME_TITLE

# Convert to camel case
BOT_APP_NAME_CAMEL=$(echo "$BOT_APP_NAME" | sed 's/_\([a-z]\)/\U\1/g' | sed 's/^\([a-z]\)/\U\1/')

echo ""
echo "Creating bot: $BOT_NAME_TITLE"
echo "  App name: $BOT_APP_NAME"
echo "  Release: $BOT_RELEASE_NAME"
echo "  Module: $BOT_APP_NAME_CAMEL"
echo ""

# Function to replace template variables
replace_in_file() {
  local file="$1"
  sed -i.bak \
    -e "s|{{BOT_APP_NAME}}|${BOT_APP_NAME}|g" \
    -e "s|{{BOT_RELEASE_NAME}}|${BOT_RELEASE_NAME}|g" \
    -e "s|{{BOT_APP_NAME_CAMEL}}|${BOT_APP_NAME_CAMEL}|g" \
    -e "s|{{BOT_NAME_TITLE}}|${BOT_NAME_TITLE}|g" \
    "$file"
  rm "${file}.bak"
}

# Replace in all files
find . -type f \( -name "*.ex" -o -name "*.exs" -o -name "*.eex" -o -name "mix.exs" -o -name "Dockerfile" \) ! -path "./.git/*" ! -path "./.github/*" | while read -r file; do
  replace_in_file "$file"
done

# Rename directory if needed
read -p "Rename directory to $BOT_APP_NAME? (y/n, default: n): " RENAME_DIR
if [ "$RENAME_DIR" = "y" ] || [ "$RENAME_DIR" = "Y" ]; then
  cd ..
  mv "$(basename "$(pwd)")" "$BOT_APP_NAME" || echo "Could not rename directory"
  cd "$BOT_APP_NAME"
fi

# Initialize git if not already
if [ ! -d .git ]; then
  git init
  git add .
  git commit -m "initial: create bot from template"
fi

echo ""
echo "✅ Setup complete!"
echo ""
echo "📋 Next steps:"
echo "  1. Edit handlers/example_handler.ex to add your logic"
echo "  2. Enable the handler in application.ex"
echo "  3. Run: mix deps.get && mix compile"
echo "  4. Test with: mix test (after adding tests)"
echo "  5. Deploy: docker build -t myorg/$BOT_APP_NAME:v0.1.0 ."
echo ""
