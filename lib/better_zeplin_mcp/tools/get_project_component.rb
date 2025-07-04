require_relative '../base_tool'

module BetterZeplinMcp
  module Tools
    class GetProjectComponent < BetterZeplinMcp::BaseTool
      name 'get_project_component'
      desc 'Get a single component from a project'
      
      arg :project_id, :string, 'Project ID'
      arg :component_id, :string, 'Component ID'
      
      def call(project_id:, component_id:)
        response = client.get("/projects/#{project_id}/components/#{component_id}")
        format_response(response)
      end
    end
  end
end