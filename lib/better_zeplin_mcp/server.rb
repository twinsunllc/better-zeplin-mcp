require 'tiny_mcp'

module BetterZeplinMcp
  class Server < TinyMCP::Server
    def initialize(*tools, **opts)
      super(*tools, **opts)
      # Add capabilities for prompts and resources even though we don't implement them
      @capabilities = opts[:capabilities] || { 
        tools: {},
        resources: {},
        prompts: {}
      }
    end

    def run
      loop do
        input = STDIN.gets
        break if input.nil?

        message =
          begin
            JSON.parse(input.strip)
          rescue
            puts error_for({'id' => nil}, :invalid_json)
            STDOUT.flush
            next
          end

        # Check if this is a notification (no id field means it's a notification)
        if message['method'] && !message.key?('id')
          handle_notification(message)
        else
          response = handle_request(message)
          puts JSON.generate(response)
          STDOUT.flush
        end
      end
    end

    private

    def handle_notification(notification)
      # Notifications don't require a response
      case notification['method']
      when 'notifications/initialized'
        # Log that we received the initialized notification but don't respond
        STDERR.puts "[#{@server_name}] Received initialized notification"
      else
        STDERR.puts "[#{@server_name}] Received unknown notification: #{notification['method']}"
      end
    end

    def handle_request(request)
      case request['method']
      when 'initialize'
        response_for request,
          protocolVersion: @protocol_version,
          capabilities: @capabilities,
          serverInfo: { name: @server_name, version: @server_version }
      when 'tools/list'
        response_for request, tools: @tool_defs.values
      when 'tools/call'
        handle_tool_call request
      when 'resources/list'
        # Return empty resources list instead of method not found error
        response_for request, resources: []
      when 'resources/read'
        # Return error but with better message
        error_for(request, :method_not_found, "No resources available in this server")
      when 'prompts/list'
        # Return empty prompts list instead of method not found error
        response_for request, prompts: []
      when 'prompts/get'
        # Return error but with better message
        error_for(request, :method_not_found, "No prompts available in this server")
      else
        error_for(request, :method_not_found)
      end
    end
  end
end