require_relative '../base_tool'

module BetterZeplinMcp
  module Tools
    class GetProjectDesignTokens < BetterZeplinMcp::BaseTool
      name 'get_project_design_tokens'
      desc 'Get design tokens for a project'
      
      arg :project_id, :string, 'Project ID'
      
      def call(project_id:)
        response = client.get("/projects/#{project_id}/design_tokens")
        format_response(response)
      end
    end
  end
end