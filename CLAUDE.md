# CLAUDE.md

Guidance for working with Claude Code skills in this repository.

## Project Overview

This repository contains packaged Claude Code skills (slash commands) for extending Claude's capabilities. Skills are distributed as `.skill` files (zip archives) containing a `SKILL.md` manifest and related files. These can be installed system-wide and are available across all Claude Code projects.

## Quick Start

Install a skill:

```bash
make install-skill
```

This will:
1. List available `.skill` files in the current directory
2. Prompt you to select one
3. Extract and install to `~/.claude/accounts/[ACCOUNT]/skills/`
4. Make it available as a slash command after restarting Claude Code

## Available Skills

### file-condenser
Intelligently condenses markdown files to reduce token usage while preserving critical information. Useful for condensing CLAUDE.md and other instruction files.

## Development

### Creating a New Skill

1. Create a directory structure:
```
my-skill/
├── SKILL.md       (required - defines skill metadata and logic)
└── [additional files]
```

2. Create `SKILL.md` with:
```markdown
---
name: my-skill
description: Brief description
---

# Implementation
[Bash script or logic here]
```

3. Package as a zip archive: `my-skill.skill`

4. Install with `make install-skill`

### Skill Metadata

The `SKILL.md` must contain YAML frontmatter:
- `name:` - Skill identifier (used as `/name`)
- `description:` - Brief description

### Installation

Skills are installed to account-specific directories:
```
~/.claude/accounts/[ACTIVE_ACCOUNT]/skills/
```

They're not stored in git and are available system-wide across all Claude Code projects.
