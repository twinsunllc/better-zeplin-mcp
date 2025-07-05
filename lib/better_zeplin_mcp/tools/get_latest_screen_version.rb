module BetterZeplinMcp
  module Tools
    class GetLatestScreenVersion < BetterZeplinMcp::BaseTool
      name 'get_latest_screen_version'
      desc 'Gets the latest version of a screen including detailed information about layers, assets, and visual properties. This includes downloadable asset URLs with multiple formats and densities, layer structure and styling, screen dimensions, and metadata. Use this tool when you need to access screen assets for download or analyze the complete visual structure of a screen.'
      
      # Define required arguments
      arg :project_id, :string, 'Project ID'
      arg :screen_id, :string, 'Screen ID'
      
      def call(project_id:, screen_id:)
        # Use client to make API call
        response = client.get("/projects/#{project_id}/screens/#{screen_id}/versions/latest")
        
        # Return formatted response
        format_response(response)
      end
    end
  end
end