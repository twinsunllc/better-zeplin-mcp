# Better Zeplin MCP

This project provides Model Context Protocol (MCP) tools for interacting with the Zeplin API using the tiny_mcp Ruby gem.

## Project Structure

```
better-zeplin-mcp/
├── lib/
│   ├── better_zeplin_mcp.rb          # Main entry point
│   ├── better_zeplin_mcp/
│   │   ├── base_tool.rb              # Base class for all tools
│   │   ├── client.rb                 # Zeplin API client
│   │   └── tools/
│   │       ├── list_projects.rb
│   │       ├── list_screens.rb
│   │       ├── get_screen.rb
│   │       ├── get_screen_components.rb
│   │       ├── get_screen_notes.rb
│   │       ├── get_screen_annotations.rb
│   │       ├── get_screen_variants.rb
│   │       ├── get_screen_variant.rb
│   │       ├── get_latest_screen_version.rb
│   │       ├── get_screen_assets.rb
│   │       ├── get_styleguide.rb
│   │       ├── get_project_components.rb
│   │       ├── get_styleguide_components.rb
│   │       ├── get_project_component.rb
│   │       ├── get_styleguide_component.rb
│   │       └── get_project_design_tokens.rb
│   └── bin/
│       └── better_zeplin_mcp         # Executable
├── test/
│   └── spec/
│       └── tools/                    # Tool tests
├── .env.example                      # Example environment variables
├── Gemfile                          # Ruby dependencies
└── Rakefile                         # Rake tasks

```

## Setup Instructions

1. Clone the repository
2. Copy `.env.example` to `.env` and add your Zeplin API token
3. Run `bundle install` to install dependencies
4. Run tests with `rake spec`

## Environment Variables

- `ZEPLIN_API_TOKEN`: Your Zeplin personal access token (required)

## Tool Descriptions

### Project Tools

1. **list_projects**: Lists all projects accessible with the API token
   - No arguments required
   - Returns array of project objects with id, name, etc.

2. **get_project_components**: Gets all components for a specific project
   - Required: `project_id`
   - Returns array of component objects

3. **get_project_component**: Gets a single component from a project
   - Required: `project_id`, `component_id`
   - Returns component details

4. **get_project_design_tokens**: Gets design tokens for a project
   - Required: `project_id`
   - Returns color, spacing, and text style tokens

### Screen Tools

5. **list_screens**: Lists all screens in a project
   - Required: `project_id`
   - Returns array of screen objects

6. **get_screen**: Gets detailed information for a single screen
   - Required: `project_id`, `screen_id`
   - Returns screen details including layers

7. **get_screen_components**: Gets components used in a screen
   - Required: `project_id`, `screen_id`
   - Returns array of component references

8. **get_screen_notes**: Gets notes attached to a screen
   - Required: `project_id`, `screen_id`
   - Returns array of note objects

9. **get_screen_annotations**: Gets annotations on a screen
   - Required: `project_id`, `screen_id`
   - Returns array of annotation objects

10. **get_screen_variants**: Gets all variants of a screen
    - Required: `project_id`, `screen_id`
    - Returns array of variant objects

11. **get_screen_variant**: Gets a specific screen variant
    - Required: `project_id`, `screen_id`, `variant_id`
    - Returns variant details

12. **get_latest_screen_version**: Gets the latest version of a screen with full details
    - Required: `project_id`, `screen_id`
    - Returns complete screen version including:
      - Downloadable asset URLs with multiple formats (PNG, SVG, JPG, PDF)
      - Asset densities for different screen resolutions
      - Layer structure with styling information
      - Screen dimensions and visual properties
      - Full metadata for the screen version
    - Use this tool when you need to download assets or analyze screen structure

13. **get_screen_assets**: Gets paginated assets from a screen
    - Required: `project_id`, `screen_id`
    - Optional: `offset` (default: 0), `limit` (default: 20, max: 100)
    - Returns:
      - Paginated array of assets with download URLs
      - Each asset includes multiple formats and densities
      - Pagination metadata (offset, limit, total, has_more)
    - Use this tool when you specifically need to list or download assets
    - Supports local pagination to control response size

### Styleguide Tools

14. **get_styleguide**: Gets styleguide information
    - Required: `styleguide_id`
    - Returns styleguide details

15. **get_styleguide_components**: Gets all components in a styleguide
    - Required: `styleguide_id`
    - Returns array of component objects

16. **get_styleguide_component**: Gets a single component from a styleguide
    - Required: `styleguide_id`, `component_id`
    - Returns component details

## API Client

The `BetterZeplinMcp::Client` handles:
- Authentication via API token
- Base URL: https://api.zeplin.dev/v1/
- HTTP requests with proper headers
- Error handling
- JSON parsing

## Tool Pattern

Each tool follows this pattern:

```ruby
module BetterZeplinMcp
  module Tools
    class ToolName < BetterZeplinMcp::BaseTool
      name 'tool_name'
      desc 'Description of what the tool does'
      
      # Define required arguments
      arg :project_id, :string, 'Project ID'
      
      # Define optional arguments
      opt :limit, :integer, 'Number of results to return'
      
      def call(project_id:, limit: 100)
        # Use client to make API call
        response = client.get("/projects/#{project_id}/screens", limit: limit)
        
        # Return formatted response
        format_response(response)
      end
    end
  end
end
```

## Running the MCP Server

```bash
./bin/better_zeplin_mcp
```

This will start the MCP server listening on stdin/stdout for JSON-RPC requests.

## Testing

Run all tests:
```bash
rake spec
```

Run specific test:
```bash
rspec spec/tools/list_projects_spec.rb
```

## Common Zeplin API Patterns

- All IDs are strings (UUIDs)
- Pagination uses `limit` and `offset` parameters
- Responses include metadata about collections
- Error responses use standard HTTP status codes
- Rate limiting information in response headers

## Development Tips

1. Each tool should be in its own file for maintainability
2. Use the base tool class to share common functionality
3. Handle API errors gracefully with helpful messages
4. Include proper validation for required parameters
5. Format responses consistently across tools
6. Write tests for each tool including error cases