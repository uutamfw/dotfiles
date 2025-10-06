# Notion Read Command

Command for retrieving page content from Notion MCP server.

## Usage

```
/notion-read <page_id>
```

## System Prompt

Retrieve content from the specified Notion page ID and display it in a readable format.

### Execution Steps

1. **Retrieve Page Information**
   - Use `mcp__notion-uuta__API-retrieve-a-page` to get basic page information
   - Check page title and properties

2. **Retrieve Page Content**
   - Use `mcp__notion-uuta__API-get-block-children` to get child blocks of the page
   - Recursively retrieve nested blocks as well

3. **Display in Readable Format**
   - Organize and display in markdown format
   - Preserve structure of headings, paragraphs, lists, quotes, etc.
   - Properly display Japanese content

### Supported Block Types

- **paragraph**: Paragraph text
- **heading_1, heading_2, heading_3**: Headings
- **bulleted_list_item**: Bullet points
- **numbered_list_item**: Numbered lists
- **to_do**: Checklists
- **quote**: Quotes
- **code**: Code blocks
- **divider**: Dividers

### Error Handling

- Display appropriate error message when page is not found
- Handle cases with insufficient access permissions
- Retry logic for failed retrievals

### Example Usage

```bash
# Read a specific page
/notion-read 12345678-1234-1234-1234-123456789012

# Example result:
# # Project Specification
# 
# ## Overview
# This project is...
# 
# ## Requirements
# - Feature A: Description
# - Feature B: Description
```

### Notes

- Please specify the page ID in complete UUID format
- Large pages may take time to retrieve
- Some block types may not be fully supported

