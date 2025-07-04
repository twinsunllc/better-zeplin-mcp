require_relative '../base_tool'

module BetterZeplinMcp
  module Tools
    class GetStyleguideComponents < BetterZeplinMcp::BaseTool
      name 'get_styleguide_components'
      desc 'Get all components in a styleguide'
      
      arg :styleguide_id, :string, 'Styleguide ID'
      opt :limit, :integer, 'Number of results to return (default: 100)'
      opt :offset, :integer, 'Number of results to skip (default: 0)'
      
      def call(styleguide_id:, limit: 100, offset: 0)
        response = client.get("/styleguides/#{styleguide_id}/components", 
                             limit: limit, offset: offset)
        format_response(response)
      end
    end
  end
end