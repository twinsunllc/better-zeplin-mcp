#!/bin/bash
export PATH="/Users/jami/.rbenv/shims:$PATH"
exec ruby "$(dirname "$0")/better_zeplin_mcp" "$@"