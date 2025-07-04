require_relative '../base_tool'

module BetterZeplinMcp
  module Tools
    class GetScreenVariant < BetterZeplinMcp::BaseTool
      name 'get_screen_variant'
      desc 'Get a specific screen variant'
      
      arg :project_id, :string, 'Project ID'
      arg :screen_id, :string, 'Screen ID'
      arg :variant_id, :string, 'Variant ID'
      
      def call(project_id:, screen_id:, variant_id:)
        response = client.get("/projects/#{project_id}/screens/#{screen_id}/versions/#{variant_id}")
        format_response(response)
      end
    end
  end
end