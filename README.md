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

- Ruby 3.4 or higher (or use Docker)
- A Zeplin personal access token

### Installation

#### Option 1: Local Installation

1. Clone this repository:
```bash
git clone <repository-url>
cd better-zeplin-mcp
```

2. Install dependencies:
```bash
bundle install
```

3. Create environment file:
```bash
cp .env.example .env
```

4. Add your Zeplin API token to `.env`:
```
ZEPLIN_API_TOKEN=your_token_here
```

#### Option 2: Docker Installation

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

### Local Installation

#### macOS/Linux
Edit `~/.config/claude/config.json`:

```json
{
  "mcpServers": {
    "better-zeplin": {
      "command": "/path/to/better-zeplin-mcp/bin/better_zeplin_mcp",
      "env": {
        "ZEPLIN_API_TOKEN": "your_token_here"
      }
    }
  }
}
```

#### Windows
Edit `%APPDATA%/Claude/config.json` with the same configuration.

### Docker Installation

#### macOS/Linux
Edit `~/.config/claude/config.json`:

```json
{
  "mcpServers": {
    "better-zeplin": {
      "command": "docker",
      "args": ["run", "--rm", "-i", "-e", "ZEPLIN_API_TOKEN=your_token_here", "better-zeplin-mcp"],
      "env": {}
    }
  }
}
```

#### Windows
Edit `%APPDATA%/Claude/config.json` with the same Docker configuration.

## Usage with Claude Code

Add the MCP server to your Claude Code configuration:

### Local Installation
```bash
# Add to your MCP configuration
claude-code mcp add better-zeplin /path/to/better-zeplin-mcp/bin/better_zeplin_mcp
```

### Docker Installation
```bash
# Add Docker-based MCP server
claude-code mcp add better-zeplin docker -- run --rm -i -e ZEPLIN_API_TOKEN=your_token_here better-zeplin-mcp
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
rake spec
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

3. **"Ruby not found"**
   - Make sure Ruby is installed and in your PATH
   - The executable uses `#!/usr/bin/env ruby`
   - Consider using the Docker installation if Ruby setup is problematic

4. **Docker-specific issues**
   - Ensure Docker is installed and running
   - Check that the image was built successfully: `docker images | grep better-zeplin-mcp`
   - For permission issues, ensure Docker daemon is accessible

### Debug Mode

To see debug output, set the environment variable:
```bash
DEBUG=1 ./bin/better_zeplin_mcp
```

## License

[Add your license here]

## Contributing

[Add contribution guidelines here]