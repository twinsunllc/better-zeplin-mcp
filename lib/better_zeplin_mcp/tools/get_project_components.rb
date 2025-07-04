require_relative '../base_tool'

module BetterZeplinMcp
  module Tools
    class GetProjectComponents < BetterZeplinMcp::BaseTool
      name 'get_project_components'
      desc 'Get all components for a specific project'
      
      arg :project_id, :string, 'Project ID'
      opt :limit, :integer, 'Number of results to return (default: 100)'
      opt :offset, :integer, 'Number of results to skip (default: 0)'
      
      def call(project_id:, limit: 100, offset: 0)
        response = client.get("/projects/#{project_id}/components", 
                             limit: limit, offset: offset)
        format_response(response)
      end
    end
  end
end