require_relative '../base_tool'

module BetterZeplinMcp
  module Tools
    class GetScreenVariants < BetterZeplinMcp::BaseTool
      name 'get_screen_variants'
      desc 'Get all variants of a screen'
      
      arg :project_id, :string, 'Project ID'
      arg :screen_id, :string, 'Screen ID'
      opt :limit, :integer, 'Number of results to return (default: 100)'
      opt :offset, :integer, 'Number of results to skip (default: 0)'
      
      def call(project_id:, screen_id:, limit: 100, offset: 0)
        response = client.get("/projects/#{project_id}/screens/#{screen_id}/versions", 
                             limit: limit, offset: offset)
        format_response(response)
      end
    end
  end
end