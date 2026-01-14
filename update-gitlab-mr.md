# Update GitLab MR

Automatically detect your current Git branch, find the corresponding GitLab merge request, and update its title and description with new information.

## Prompts

This skill will:
1. Detect your current Git branch
2. Find the matching GitLab MR for that branch
3. Ask if you want to update the MR
4. Prompt for new title and description (or auto-extract from commits)

## Prerequisites

- `.env` file with `GITLAB_TOKEN` set
- Git repository configured with GitLab remote
- Must be on a feature branch (not main/master)

## Example Workflow

```bash
/update-gitlab-mr
Current branch: feature/add-dark-mode
Found MR: !1234 - Add dark mode
Update MR? (yes/no): yes
New title: Add dark mode toggle with persistence
New description:
- Implements dark/light theme switch
- Saves preference to localStorage
- Updates UI on system preference change
```

Updates MR #1234 with new title and description.

## Implementation Details

- Uses GitLab API v4
- Auto-detects branch from `git rev-parse --abbrev-ref HEAD`
- Searches for MR where target branch = current branch + source branch check
- Preserves existing MR state, only updates title/description
- Validates GitLab token before making requests

## Configuration

Environment variable required in `.env`:
```
GITLAB_TOKEN=your-gitlab-personal-access-token
```

Token needs `api` scope for MR updates.
