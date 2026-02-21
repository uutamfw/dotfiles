---
name: github:create-pr
description: Create a GitHub PR using the current branch's issue title and project PR template. Designed to be called after all dev steps complete.
---

# Create PR

現在のブランチに紐づくissueのtitleを使ってPRを作成する。

## Procedure

### 1. Get Issue Info

1. Get current branch: `git branch --show-current`
   - Extract issue number: `feat/#123` → `123`
   - If no number found → Report error and stop

2. Get issue title:
   ```bash
   gh issue view {number} --json title --jq .title
   ```

### 2. Build PR Description

1. Look for PR template:
   ```bash
   # Check common locations
   .github/pull_request_template.md
   .github/PULL_REQUEST_TEMPLATE.md
   .github/PULL_REQUEST_TEMPLATE/*.md
   ```

2. If template found → use it as base structure, fill in content
   If not found → use default:
   ```markdown
   ## Summary

   ## Changes

   ## Notes
   ```

3. Read diff to fill in content:
   ```bash
   git diff main...HEAD
   ```
   - Write concise, factual descriptions based on actual changes
   - Keep each section brief (2-5 bullet points max)

### 3. Create PR

```bash
gh pr create \
  --title "{issue title}" \
  --body "$(cat <<'EOF'
{filled description}
EOF
)"
```

### 4. Report

- Display PR URL to user
- Update `docs/{branch_name}/dev-workflow.yaml`:
  ```yaml
  pr:
    status: Done
    url: {pr_url}
  ```
