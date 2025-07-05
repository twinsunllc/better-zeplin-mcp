require 'tiny_mcp'
require 'dotenv/load'
require_relative 'better_zeplin_mcp/base_tool'
require_relative 'better_zeplin_mcp/client'
require_relative 'better_zeplin_mcp/server'

# Load all tools
Dir[File.join(__dir__, 'better_zeplin_mcp/tools/*.rb')].each { |file| require file }

module BetterZeplinMcp
  def self.tools
    [
      Tools::ListProjects,
      Tools::ListScreens,
      Tools::GetScreen,
      Tools::GetScreenComponents,
      Tools::GetScreenNotes,
      Tools::GetScreenAnnotations,
      Tools::GetScreenVariants,
      Tools::GetScreenVariant,
      Tools::GetLatestScreenVersion,
      Tools::GetScreenAssets,
      Tools::GetStyleguide,
      Tools::GetProjectComponents,
      Tools::GetStyleguideComponents,
      Tools::GetProjectComponent,
      Tools::GetStyleguideComponent,
      Tools::GetProjectDesignTokens
    ]
  end
end