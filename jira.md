---
name: jira
description: Fetch Jira ticket information. Use when the user mentions a Jira ticket (e.g., ORD-1234) to get the title, description, and details.
allowed-tools: Bash(curl:*)
---

# Jira Integration

Fetch Jira ticket information using the Atlassian REST API.

## Authentication

Requires environment variables:
- `JIRA_EMAIL`: Your Atlassian account email
- `JIRA_API_TOKEN`: API token from https://id.atlassian.com/manage-profile/security/api-tokens

Authentication uses Basic auth with email:token base64 encoded.

## API Base URL

`https://cloudsuite.atlassian.net/rest/api/3`

## Common Operations

### Get ticket details
```bash
curl -s -u "$JIRA_EMAIL:$JIRA_API_TOKEN" \
  -H "Content-Type: application/json" \
  "https://cloudsuite.atlassian.net/rest/api/3/issue/TICKET-123"
```

### Get ticket with specific fields only (faster)
```bash
curl -s -u "$JIRA_EMAIL:$JIRA_API_TOKEN" \
  -H "Content-Type: application/json" \
  "https://cloudsuite.atlassian.net/rest/api/3/issue/TICKET-123?fields=summary,description,status,assignee,priority"
```

### Search for tickets (JQL)
```bash
curl -s -u "$JIRA_EMAIL:$JIRA_API_TOKEN" \
  -H "Content-Type: application/json" \
  -G --data-urlencode "jql=project = ORD AND assignee = currentUser() AND status != Done" \
  "https://cloudsuite.atlassian.net/rest/api/3/search"
```

### Get my open tickets
```bash
curl -s -u "$JIRA_EMAIL:$JIRA_API_TOKEN" \
  -H "Content-Type: application/json" \
  -G --data-urlencode "jql=assignee = currentUser() AND status != Done ORDER BY updated DESC" \
  "https://cloudsuite.atlassian.net/rest/api/3/search?fields=summary,status,priority"
```

## Response Parsing

The ticket response includes:
- `fields.summary`: Ticket title
- `fields.description`: Ticket description (in Atlassian Document Format)
- `fields.status.name`: Current status
- `fields.assignee.displayName`: Assigned person
- `fields.priority.name`: Priority level

## Workflow

1. When user provides a ticket number, fetch the ticket details
2. Extract the summary (title) and description to understand the task
3. Use this context to help with the work
