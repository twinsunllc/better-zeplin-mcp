# Better Zeplin MCP

A Model Context Protocol (MCP) server that provides tools for interacting with the Zeplin API. This allows Claude to fetch design information, components, screens, and design tokens directly from your Zeplin projects.

## Features

- List and browse Zeplin projects
- Fetch screen details and variants
- Get component information from projects and styleguides
- Access design tokens (colors, spacing, typography)
- Retrieve screen annotations and notes

## Setup

### Prerequisites

- Docker
- A Zeplin personal access token

### Installation

1. Clone this repository:
```bash
git clone <repository-url>
cd better-zeplin-mcp
```

2. Build the Docker image:
```bash
docker build -t better-zeplin-mcp .
```

To get a Zeplin API token:
1. Go to [Zeplin Developer](https://developer.zeplin.io/)
2. Sign in with your Zeplin account
3. Create a new personal access token

## Usage with Claude Desktop

Add this MCP server to your Claude Desktop configuration:

### Configuration

#### macOS/Linux
Edit `~/.config/claude/config.json`:

```json
{
  "mcpServers": {
    "better-zeplin": {
      "command": "docker",
      "args": ["run", "--rm", "-i", "-e", "ZEPLIN_API_TOKEN=your_token_here", "twinsunllc/better-zeplin-mcp"],
      "env": {}
    }
  }
}
```

#### Windows
Edit `%APPDATA%/Claude/config.json` with the same Docker configuration.

## Usage with Claude Code

Add the MCP server to your Claude Code configuration:

```bash
# Add Docker-based MCP server
claude-code mcp add better-zeplin docker -- run --rm -i -e ZEPLIN_API_TOKEN=your_token_here twinsunllc/better-zeplin-mcp
```

Or configure manually in your MCP settings file with the same JSON structure as Claude Desktop.

## Available Tools

### Project Tools
- `list_projects` - List all accessible projects
- `get_project_components` - Get components for a project
- `get_project_component` - Get specific component details
- `get_project_design_tokens` - Get design tokens for a project

### Screen Tools
- `list_screens` - List screens in a project
- `get_screen` - Get detailed screen information
- `get_screen_components` - Get components used in a screen
- `get_screen_notes` - Get notes attached to a screen
- `get_screen_annotations` - Get screen annotations
- `get_screen_variants` - Get all variants of a screen
- `get_screen_variant` - Get specific variant details

### Styleguide Tools
- `get_styleguide` - Get styleguide information
- `get_styleguide_components` - Get all styleguide components
- `get_styleguide_component` - Get specific styleguide component

## Example Usage

Once configured, you can ask Claude questions like:

- "List all my Zeplin projects"
- "Show me the screens in project ABC123"
- "Get the design tokens for project XYZ456"
- "What components are used in screen DEF789?"
- "Show me the annotations on this screen"

## Development

### Running Tests
```bash
bundle exec rspec
```

### Project Structure
```
lib/
├── better_zeplin_mcp.rb          # Main entry point
├── better_zeplin_mcp/
│   ├── base_tool.rb              # Base class for tools
│   ├── client.rb                 # Zeplin API client
│   └── tools/                    # Individual tool implementations
```

## Troubleshooting

### Common Issues

1. **"Authentication failed"**
   - Check that your ZEPLIN_API_TOKEN is correctly set
   - Verify the token has the necessary permissions

2. **"Command not found"**
   - Ensure the path to the executable is correct in your config
   - Check that the file has execute permissions: `chmod +x bin/better_zeplin_mcp`

3. **Docker-specific issues**
   - Ensure Docker is installed and running
   - Pull the latest image: `docker pull twinsunllc/better-zeplin-mcp`
   - For permission issues, ensure Docker daemon is accessible

### Debug Mode

To see debug output, set the environment variable:
```bash
DEBUG=1 ./bin/better_zeplin_mcp
```

## License

MIT License

Copyright (c) 2025 Twin Sun, LLC

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.