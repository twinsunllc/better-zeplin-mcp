require 'spec_helper'

RSpec.describe BetterZeplinMcp::Tools::GetScreenAssets do
  let(:tool) { described_class.new }
  let(:client) { instance_double(BetterZeplinMcp::Client) }
  let(:project_id) { 'project-123' }
  let(:screen_id) { 'screen-456' }

  before do
    allow(tool).to receive(:client).and_return(client)
  end

  describe '#call' do
    let(:full_response) do
      {
        'id' => 'version-789',
        'width' => 1920,
        'height' => 1080,
        'assets' => [
          {
            'layer_source_id' => 'layer-001',
            'display_name' => 'asset1',
            'contents' => [
              { 'url' => 'https://cdn.zeplin.io/asset1.png', 'format' => 'png', 'density' => 1 }
            ]
          },
          {
            'layer_source_id' => 'layer-002',
            'display_name' => 'asset2',
            'contents' => [
              { 'url' => 'https://cdn.zeplin.io/asset2.png', 'format' => 'png', 'density' => 1 }
            ]
          },
          {
            'layer_source_id' => 'layer-003',
            'display_name' => 'asset3',
            'contents' => [
              { 'url' => 'https://cdn.zeplin.io/asset3.png', 'format' => 'png', 'density' => 1 }
            ]
          },
          {
            'layer_source_id' => 'layer-004',
            'display_name' => 'asset4',
            'contents' => [
              { 'url' => 'https://cdn.zeplin.io/asset4.png', 'format' => 'png', 'density' => 1 }
            ]
          },
          {
            'layer_source_id' => 'layer-005',
            'display_name' => 'asset5',
            'contents' => [
              { 'url' => 'https://cdn.zeplin.io/asset5.png', 'format' => 'png', 'density' => 1 }
            ]
          }
        ]
      }
    end

    context 'with default pagination' do
      it 'returns first 20 assets with pagination metadata' do
        expect(client).to receive(:get)
          .with("/projects/#{project_id}/screens/#{screen_id}/versions/latest")
          .and_return(full_response)

        result = tool.call(project_id: project_id, screen_id: screen_id)

        expect(result).to be_an(Array)
        expect(result.first[:type]).to eq('text')
        
        parsed_data = JSON.parse(result.first[:text])
        expect(parsed_data['assets'].length).to eq(5) # All 5 assets fit in default limit
        expect(parsed_data['pagination']).to eq({
          'offset' => 0,
          'limit' => 20,
          'total' => 5,
          'has_more' => false
        })
      end
    end

    context 'with custom pagination' do
      it 'returns paginated assets with correct offset and limit' do
        expect(client).to receive(:get)
          .with("/projects/#{project_id}/screens/#{screen_id}/versions/latest")
          .and_return(full_response)

        result = tool.call(project_id: project_id, screen_id: screen_id, offset: 1, limit: 2)

        parsed_data = JSON.parse(result.first[:text])
        expect(parsed_data['assets'].length).to eq(2)
        expect(parsed_data['assets'][0]['display_name']).to eq('asset2')
        expect(parsed_data['assets'][1]['display_name']).to eq('asset3')
        expect(parsed_data['pagination']).to eq({
          'offset' => 1,
          'limit' => 2,
          'total' => 5,
          'has_more' => true
        })
      end
    end

    context 'with limit exceeding 100' do
      it 'caps limit at 100' do
        expect(client).to receive(:get)
          .with("/projects/#{project_id}/screens/#{screen_id}/versions/latest")
          .and_return(full_response)

        result = tool.call(project_id: project_id, screen_id: screen_id, limit: 200)

        parsed_data = JSON.parse(result.first[:text])
        expect(parsed_data['pagination']['limit']).to eq(100)
      end
    end

    context 'with negative offset' do
      it 'treats negative offset as 0' do
        expect(client).to receive(:get)
          .with("/projects/#{project_id}/screens/#{screen_id}/versions/latest")
          .and_return(full_response)

        result = tool.call(project_id: project_id, screen_id: screen_id, offset: -5)

        parsed_data = JSON.parse(result.first[:text])
        expect(parsed_data['pagination']['offset']).to eq(0)
      end
    end

    context 'with offset beyond available assets' do
      it 'returns empty assets array' do
        expect(client).to receive(:get)
          .with("/projects/#{project_id}/screens/#{screen_id}/versions/latest")
          .and_return(full_response)

        result = tool.call(project_id: project_id, screen_id: screen_id, offset: 10)

        parsed_data = JSON.parse(result.first[:text])
        expect(parsed_data['assets']).to eq([])
        expect(parsed_data['pagination']).to eq({
          'offset' => 10,
          'limit' => 20,
          'total' => 5,
          'has_more' => false
        })
      end
    end

    context 'when screen has no assets' do
      let(:empty_response) do
        {
          'id' => 'version-789',
          'width' => 1920,
          'height' => 1080,
          'assets' => []
        }
      end

      it 'returns empty assets with correct pagination' do
        expect(client).to receive(:get)
          .with("/projects/#{project_id}/screens/#{screen_id}/versions/latest")
          .and_return(empty_response)

        result = tool.call(project_id: project_id, screen_id: screen_id)

        parsed_data = JSON.parse(result.first[:text])
        expect(parsed_data['assets']).to eq([])
        expect(parsed_data['pagination']).to eq({
          'offset' => 0,
          'limit' => 20,
          'total' => 0,
          'has_more' => false
        })
      end
    end

    context 'when assets key is missing' do
      let(:no_assets_response) do
        {
          'id' => 'version-789',
          'width' => 1920,
          'height' => 1080
        }
      end

      it 'treats as empty assets array' do
        expect(client).to receive(:get)
          .with("/projects/#{project_id}/screens/#{screen_id}/versions/latest")
          .and_return(no_assets_response)

        result = tool.call(project_id: project_id, screen_id: screen_id)

        parsed_data = JSON.parse(result.first[:text])
        expect(parsed_data['assets']).to eq([])
        expect(parsed_data['pagination']['total']).to eq(0)
      end
    end
  end
end