FROM ruby:3.4-slim

# Install build dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    git \
    && rm -rf /var/lib/apt/lists/*

# Set working directory
WORKDIR /app

# Copy gemfiles first for better caching
COPY Gemfile Gemfile.lock ./
RUN bundle install

# Copy the rest of the application
COPY . .

# Make the binary executable
RUN chmod +x bin/better_zeplin_mcp

# Run as non-root user
RUN useradd -m -s /bin/bash mcp
USER mcp

# MCP servers communicate via stdin/stdout
CMD ["./bin/better_zeplin_mcp"]