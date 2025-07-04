require_relative '../base_tool'

module BetterZeplinMcp
  module Tools
    class ListProjects < BetterZeplinMcp::BaseTool
      name 'list_projects'
      desc 'List all projects accessible with the API token'
      
      opt :limit, :integer, 'Number of results to return (default: 100)'
      opt :offset, :integer, 'Number of results to skip (default: 0)'
      
      def call(limit: 100, offset: 0)
        response = client.get('/projects', limit: limit, offset: offset)
        format_response(response)
      end
    end
  end
end