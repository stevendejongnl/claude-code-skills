.PHONY: install-skill package-skill help

help:
	@echo "Claude Code Skills Management"
	@echo ""
	@echo "Available commands:"
	@echo "  make package-skill    Package a markdown file as a .skill file"
	@echo "  make install-skill    Install a .skill file to ~/.claude/skills/"

package-skill:
	@read -p "Enter markdown file path: " md_file; \
	read -p "Enter skill name (default: filename): " skill_name; \
	read -p "Enter skill description: " description; \
	./package-skill.sh -f "$$md_file" -n "$$skill_name" -d "$$description"

install-skill:
	@SKILLS=$$(ls -1 *.skill 2>/dev/null); \
	if [ -z "$$SKILLS" ]; then \
		echo "❌ No .skill files found in current directory"; \
		exit 1; \
	fi; \
	echo "📦 Available skills:"; \
	echo "$$SKILLS" | nl; \
	echo ""; \
	read -p "Select skill number (1-$$(echo "$$SKILLS" | wc -l)): " choice; \
	SKILL_FILE=$$(echo "$$SKILLS" | sed -n "$${choice}p"); \
	if [ -z "$$SKILL_FILE" ]; then \
		echo "❌ Invalid selection"; \
		exit 1; \
	fi; \
	echo "📂 Installing $$SKILL_FILE..."; \
	TEMP_DIR=$$(mktemp -d); \
	unzip -q "$$SKILL_FILE" -d "$$TEMP_DIR"; \
	SKILL_MD="$$TEMP_DIR/SKILL.md"; \
	if [ ! -f "$$SKILL_MD" ]; then \
		SKILL_MD=$$(find "$$TEMP_DIR" -name "SKILL.md" -type f | head -1); \
	fi; \
	if [ -z "$$SKILL_MD" ] || [ ! -f "$$SKILL_MD" ]; then \
		echo "❌ SKILL.md not found in archive"; \
		rm -rf "$$TEMP_DIR"; \
		exit 1; \
	fi; \
	SKILL_NAME=$$(grep -m 1 "^name:" "$$SKILL_MD" | sed 's/name: *//'); \
	ACTIVE_ACCOUNT=$$(cat "$$HOME/.claude/active-profile"); \
	SKILLS_DIR="$$HOME/.claude/accounts/$$ACTIVE_ACCOUNT/skills"; \
	mkdir -p "$$SKILLS_DIR"; \
	SKILL_DIR=$$(dirname "$$SKILL_MD" | sed "s|$$TEMP_DIR||"); \
	INSTALL_PATH="$$SKILLS_DIR$$SKILL_DIR"; \
	mkdir -p "$$SKILLS_DIR"; \
	rm -rf "$$SKILLS_DIR/$$SKILL_NAME"; \
	if [ -d "$$TEMP_DIR/$$SKILL_NAME" ]; then \
		cp -r "$$TEMP_DIR/$$SKILL_NAME" "$$SKILLS_DIR"; \
	fi; \
	cp -f "$$TEMP_DIR/SKILL.md" "$$SKILLS_DIR/SKILL.md"; \
	chmod +x "$$SKILLS_DIR/SKILL.md" 2>/dev/null || true; \
	rm -rf "$$TEMP_DIR"; \
	echo "✅ Installed: $$SKILL_NAME"; \
	echo "📍 Location: $$INSTALL_PATH"; \
	echo "📋 Account: $$ACTIVE_ACCOUNT"; \
	echo "🔄 Restart Claude Code to use: /$$SKILL_NAME"
