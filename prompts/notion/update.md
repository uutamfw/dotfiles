# Notion Update Command

Command for updating page content in Notion using MCP server.

## Usage

```
/notion-update <page_id> <content>
```

## System Prompt

Update the specified Notion page with new content while preserving existing structure where possible.

### Execution Steps

1. **Retrieve Current Page Information**
   - Use `mcp__notion-uuta__API-retrieve-a-page` to get current page information
   - Check page title and existing properties

2. **Get Current Content Structure**
   - Use `mcp__notion-uuta__API-get-block-children` to get existing blocks
   - Understand current content structure for preservation or replacement

3. **Update Page Content**
   - Use `mcp__notion-uuta__API-patch-block-children` to append new content blocks
   - Use `mcp__notion-uuta__API-update-a-block` to modify existing blocks if needed
   - Convert markdown/text content to appropriate Notion block format

4. **Update Page Properties (if needed)**
   - Use `mcp__notion-uuta__API-patch-page` to update page title or properties
   - Preserve existing properties unless explicitly changed

### Content Conversion

Convert input content to appropriate Notion block types:

- **Plain text** → paragraph blocks
- **# Heading** → heading_1 blocks
- **## Heading** → heading_2 blocks  
- **### Heading** → heading_3 blocks
- **- List item** → bulleted_list_item blocks
- **1. List item** → numbered_list_item blocks
- **> Quote** → quote blocks
- **```code```** → code blocks

### Block Structure Format

```json
{
  "type": "paragraph",
  "paragraph": {
    "rich_text": [
      {
        "type": "text",
        "text": {
          "content": "Your content here"
        }
      }
    ]
  }
}
```

### Error Handling

- Verify page exists and is accessible before updating
- Handle permission errors gracefully
- Validate content format before sending to Notion
- Provide clear error messages for failed updates

### Example Usage

```bash
# Update page with new content
/notion-update 12345678-1234-1234-1234-123456789012 "# New Heading\n\nThis is updated content.\n\n- Item 1\n- Item 2"

# Update page title and content
/notion-update 12345678-1234-1234-1234-123456789012 --title "Updated Title" "New page content here"
```

### Update Modes

1. **Append Mode (default)**: Add new content to existing page
2. **Replace Mode**: Replace all existing content blocks
3. **Update Mode**: Update specific blocks by ID

### Safety Considerations

- Always backup existing content before major updates
- Confirm destructive operations with user
- Preserve important metadata and properties
- Handle Japanese and multi-byte characters properly

### Notes

- Page ID must be in complete UUID format
- Large content updates may take time to process
- Some complex block types may require special handling
- Always test updates on non-critical pages first

