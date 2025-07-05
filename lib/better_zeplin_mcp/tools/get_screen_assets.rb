module BetterZeplinMcp
  module Tools
    class GetScreenAssets < BetterZeplinMcp::BaseTool
      name 'get_screen_assets'
      desc 'Gets assets from a screen with pagination support. Returns only the assets array from the screen version, allowing you to control the number of assets returned per request. Each asset includes downloadable URLs with multiple formats (PNG, SVG, JPG, PDF) and densities. Use this tool when you specifically need to download or list assets from a screen.'
      
      # Define required arguments
      arg :project_id, :string, 'Project ID'
      arg :screen_id, :string, 'Screen ID'
      
      # Define optional arguments for pagination
      opt :offset, :integer, 'Number of assets to skip (default: 0)'
      opt :limit, :integer, 'Maximum number of assets to return (default: 20, max: 100)'
      
      def call(project_id:, screen_id:, offset: 0, limit: 20)
        # Validate pagination parameters
        limit = [limit, 100].min  # Cap at 100
        limit = [limit, 1].max    # Minimum 1
        offset = [offset, 0].max  # Can't be negative
        
        # Get the full screen version data
        response = client.get("/projects/#{project_id}/screens/#{screen_id}/versions/latest")
        
        # Extract just the assets array
        assets = response['assets'] || []
        
        # Apply pagination locally
        total_assets = assets.length
        paginated_assets = assets[offset, limit] || []
        
        # Build paginated response
        paginated_response = {
          'assets' => paginated_assets,
          'pagination' => {
            'offset' => offset,
            'limit' => limit,
            'total' => total_assets,
            'has_more' => (offset + limit) < total_assets
          }
        }
        
        # Return formatted response
        format_response(paginated_response)
      end
    end
  end
end