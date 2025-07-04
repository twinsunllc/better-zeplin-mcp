require_relative '../base_tool'

module BetterZeplinMcp
  module Tools
    class GetScreen < BetterZeplinMcp::BaseTool
      name 'get_screen'
      desc 'Get detailed information for a single screen'
      
      arg :project_id, :string, 'Project ID'
      arg :screen_id, :string, 'Screen ID'
      
      def call(project_id:, screen_id:)
        response = client.get("/projects/#{project_id}/screens/#{screen_id}")
        format_response(response)
      end
    end
  end
end