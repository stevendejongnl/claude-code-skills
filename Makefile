.PHONY: install-skill help

help:
	@echo "Claude Code Skills Management"
	@echo ""
	@echo "Available commands:"
	@echo "  make install-skill    Install a .skill file to ~/.claude/skills/"

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
	SKILL_MD=$$(find "$$TEMP_DIR" -name "SKILL.md" -type f); \
	if [ -z "$$SKILL_MD" ]; then \
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
	mkdir -p "$$INSTALL_PATH"; \
	cp -r "$$TEMP_DIR"/* "$$SKILLS_DIR"; \
	chmod +x "$$SKILL_MD"; \
	rm -rf "$$TEMP_DIR"; \
	echo "✅ Installed: $$SKILL_NAME"; \
	echo "📍 Location: $$INSTALL_PATH"; \
	echo "📋 Account: $$ACTIVE_ACCOUNT"; \
	echo "🔄 Restart Claude Code to use: /$$SKILL_NAME"
