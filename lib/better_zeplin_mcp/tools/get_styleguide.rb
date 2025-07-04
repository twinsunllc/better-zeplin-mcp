require_relative '../base_tool'

module BetterZeplinMcp
  module Tools
    class GetStyleguide < BetterZeplinMcp::BaseTool
      name 'get_styleguide'
      desc 'Get styleguide information'
      
      arg :styleguide_id, :string, 'Styleguide ID'
      
      def call(styleguide_id:)
        response = client.get("/styleguides/#{styleguide_id}")
        format_response(response)
      end
    end
  end
end