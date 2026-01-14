#!/usr/bin/env bash

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

usage() {
    echo "Usage: $0 -f <markdown-file> [-n <skill-name>] [-d <description>]"
    echo ""
    echo "Options:"
    echo "  -f <file>          Path to markdown file (required)"
    echo "  -n <name>          Skill name/identifier (default: filename without extension)"
    echo "  -d <description>   Skill description (default: prompt user)"
    echo "  -h                 Show this help message"
    echo ""
    echo "Example:"
    echo "  $0 -f my-feature.md -n my-feature -d 'Does something cool'"
    exit 1
}

# Parse arguments
MD_FILE=""
SKILL_NAME=""
DESCRIPTION=""

while getopts "f:n:d:h" opt; do
    case $opt in
        f) MD_FILE="$OPTARG" ;;
        n) SKILL_NAME="$OPTARG" ;;
        d) DESCRIPTION="$OPTARG" ;;
        h) usage ;;
        *) usage ;;
    esac
done

# Validate markdown file
if [ -z "$MD_FILE" ] || [ ! -f "$MD_FILE" ]; then
    echo -e "${RED}❌ Error: Markdown file not found: $MD_FILE${NC}"
    usage
fi

# Derive skill name from file if not provided
if [ -z "$SKILL_NAME" ]; then
    SKILL_NAME=$(basename "$MD_FILE" .md)
    echo -e "${BLUE}📝 Using skill name: ${SKILL_NAME}${NC}"
fi

# Prompt for description if not provided
if [ -z "$DESCRIPTION" ]; then
    echo -e "${BLUE}📝 Enter skill description (or leave blank for auto-generated):${NC}"
    read -r DESCRIPTION
    if [ -z "$DESCRIPTION" ]; then
        DESCRIPTION="Skill created from $MD_FILE"
    fi
fi

# Create temporary directory
TEMP_DIR=$(mktemp -d)
trap "rm -rf $TEMP_DIR" EXIT

echo -e "${YELLOW}📦 Packaging skill: ${SKILL_NAME}${NC}"

# Create skill directory in temp
SKILL_DIR="$TEMP_DIR/$SKILL_NAME"
mkdir -p "$SKILL_DIR"

# Create SKILL.md with frontmatter
cat > "$SKILL_DIR/SKILL.md" << EOF
---
name: $SKILL_NAME
description: $DESCRIPTION
---

EOF

# Append the markdown content
cat "$MD_FILE" >> "$SKILL_DIR/SKILL.md"

# Also create a root SKILL.md for compatibility (some versions expect this)
cp "$SKILL_DIR/SKILL.md" "$TEMP_DIR/SKILL.md"

# Create the .skill file (zip archive)
OUTPUT_FILE="${SKILL_NAME}.skill"
cd "$TEMP_DIR"
zip -q -r "$OUTPUT_FILE" . -x "*.skill"
cd - > /dev/null

# Move to current directory
mv "$TEMP_DIR/$OUTPUT_FILE" "./$OUTPUT_FILE"

echo -e "${GREEN}✅ Created: ${OUTPUT_FILE}${NC}"
echo -e "${BLUE}📊 Size: $(du -h "$OUTPUT_FILE" | cut -f1)${NC}"
echo ""
echo -e "${YELLOW}📖 Skill details:${NC}"
echo "  Name: $SKILL_NAME"
echo "  Description: $DESCRIPTION"
echo "  File: $OUTPUT_FILE"
echo ""
echo -e "${BLUE}💡 To install this skill:${NC}"
echo "  make install-skill"
