require_relative '../base_tool'

module BetterZeplinMcp
  module Tools
    class GetStyleguideComponent < BetterZeplinMcp::BaseTool
      name 'get_styleguide_component'
      desc 'Get a single component from a styleguide'
      
      arg :styleguide_id, :string, 'Styleguide ID'
      arg :component_id, :string, 'Component ID'
      
      def call(styleguide_id:, component_id:)
        response = client.get("/styleguides/#{styleguide_id}/components/#{component_id}")
        format_response(response)
      end
    end
  end
end