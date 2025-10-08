# GitHub PR Description Update Command

Command for fetching and updating GitHub pull request descriptions using templates.

## System Prompt

Fetch the specified GitHub pull request and update its description using the provided template format.

### Execution Steps

1. **Fetch PR Information**
   - Use `gh pr view $1` to get current PR details
   - Extract PR title, description, branch information, and metadata

2. **Analyze Current PR Content**
   - Parse existing PR description structure
   - Identify sections that need template formatting

3. **Apply Template to Description**
   - Use the provided template or default template to format PR description
   - Preserve important existing content where applicable
   - Ensure proper markdown formatting

4. **Update PR Description**
   - Use `gh pr edit $1 --body "updated_description"` to update PR
   - Verify update was successful
