require 'tiny_mcp'
require_relative 'client'

module BetterZeplinMcp
  class BaseTool < TinyMCP::Tool
    def client
      @client ||= Client.new
    end
    
    # Override to_h to fix schema type conversion
    def self.to_h
      {
        name: name,
        description: desc,
        inputSchema: {
          type: 'object',
          properties: props.map { |prop| 
            [prop.name, { 
              type: prop.type.to_s, 
              description: prop.desc 
            }] 
          }.to_h,
          required: props.select(&:req).map(&:name)
        }
      }
    end
    
    protected
    
    def format_response(data)
      if data.is_a?(Hash) && data.key?('error')
        raise data['error']['message'] || 'Unknown error occurred'
      end
      
      [
        {
          type: "text",
          text: JSON.pretty_generate(data)
        }
      ]
    end
    
    def validate_required_params(**params)
      missing = []
      self.class.schema[:properties].each do |name, config|
        if self.class.schema[:required].include?(name.to_s) && params[name].nil?
          missing << name
        end
      end
      
      unless missing.empty?
        raise ArgumentError, "Missing required parameters: #{missing.join(', ')}"
      end
    end
  end
end