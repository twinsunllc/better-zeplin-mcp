require 'spec_helper'

RSpec.describe BetterZeplinMcp::Tools::GetLatestScreenVersion do
  let(:tool) { described_class.new }
  let(:client) { instance_double(BetterZeplinMcp::Client) }
  let(:project_id) { 'project-123' }
  let(:screen_id) { 'screen-456' }

  before do
    allow(tool).to receive(:client).and_return(client)
  end

  describe '#call' do
    let(:response) do
      {
        'id' => 'version-789',
        'width' => 1920,
        'height' => 1080,
        'image_url' => 'https://cdn.zeplin.io/screen-image.png',
        'assets' => [
          {
            'layer_source_id' => 'layer-001',
            'display_name' => 'logo',
            'layer_name' => 'Logo Layer',
            'contents' => [
              {
                'url' => 'https://cdn.zeplin.io/assets/logo@1x.png',
                'format' => 'png',
                'density' => 1
              },
              {
                'url' => 'https://cdn.zeplin.io/assets/logo@2x.png',
                'format' => 'png',
                'density' => 2
              },
              {
                'url' => 'https://cdn.zeplin.io/assets/logo.svg',
                'format' => 'svg',
                'density' => 1
              }
            ]
          },
          {
            'layer_source_id' => 'layer-002',
            'display_name' => 'button',
            'layer_name' => 'Button',
            'contents' => [
              {
                'url' => 'https://cdn.zeplin.io/assets/button.pdf',
                'format' => 'pdf',
                'density' => 1
              }
            ]
          }
        ],
        'layers' => [
          {
            'id' => 'layer-001',
            'name' => 'Logo Layer',
            'type' => 'shape',
            'rect' => {
              'x' => 100,
              'y' => 200,
              'width' => 150,
              'height' => 50
            }
          }
        ]
      }
    end

    it 'gets the latest screen version with assets' do
      expect(client).to receive(:get)
        .with("/projects/#{project_id}/screens/#{screen_id}/versions/latest")
        .and_return(response)

      result = tool.call(project_id: project_id, screen_id: screen_id)

      expect(result).to be_an(Array)
      expect(result.first[:type]).to eq('text')
      
      # Parse the JSON response
      parsed_data = JSON.parse(result.first[:text])
      expect(parsed_data).to eq(response)
      expect(parsed_data['assets']).to be_an(Array)
      expect(parsed_data['assets'].length).to eq(2)
      
      # Check first asset structure
      first_asset = parsed_data['assets'][0]
      expect(first_asset['display_name']).to eq('logo')
      expect(first_asset['contents']).to be_an(Array)
      expect(first_asset['contents'].length).to eq(3)
      
      # Check asset content structure
      first_content = first_asset['contents'][0]
      expect(first_content['url']).to match(/^https:\/\/cdn\.zeplin\.io/)
      expect(first_content['format']).to eq('png')
      expect(first_content['density']).to eq(1)
    end

    context 'when API returns an error' do
      it 'returns formatted error response' do
        error_response = { 'message' => 'Screen not found' }
        expect(client).to receive(:get)
          .with("/projects/#{project_id}/screens/#{screen_id}/versions/latest")
          .and_return(error_response)

        result = tool.call(project_id: project_id, screen_id: screen_id)

        expect(result).to be_an(Array)
        expect(result.first[:type]).to eq('text')
        
        parsed_data = JSON.parse(result.first[:text])
        expect(parsed_data).to eq(error_response)
      end
    end

    context 'when screen has no assets' do
      let(:response_without_assets) do
        {
          'id' => 'version-789',
          'width' => 1920,
          'height' => 1080,
          'assets' => []
        }
      end

      it 'returns empty assets array' do
        expect(client).to receive(:get)
          .with("/projects/#{project_id}/screens/#{screen_id}/versions/latest")
          .and_return(response_without_assets)

        result = tool.call(project_id: project_id, screen_id: screen_id)

        expect(result).to be_an(Array)
        parsed_data = JSON.parse(result.first[:text])
        expect(parsed_data['assets']).to eq([])
      end
    end
  end
end