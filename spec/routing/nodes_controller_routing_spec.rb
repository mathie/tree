require 'rails_helper'

RSpec.describe NodesController do
  it 'routes GET / to nodes#index' do
    expect(get: '/').to route_to('nodes#index')
  end

  it 'routes GET /nodes to nodes#index' do
    expect(get: '/nodes').to route_to('nodes#index')
  end

  it 'routes POST /nodes to nodes#create' do
    expect(post: '/nodes').to route_to('nodes#create')
  end

  it 'routes GET /nodes/chicken to nodes#show with id "chicken"' do
    expect(get: '/nodes/chicken').to route_to(
      controller: 'nodes',
      action: 'show',
      id: 'chicken'
    )
  end

  it 'routes PUT /nodes/chicken to nodes#update with id "chicken"' do
    expect(put: '/nodes/chicken').to route_to(
      controller: 'nodes',
      action: 'update',
      id: 'chicken'
    )
  end

  it 'routes DELETE /nodes/chicken to nodes#update with id "chicken"' do
    expect(delete: '/nodes/chicken').to route_to(
      controller: 'nodes',
      action: 'destroy',
      id: 'chicken'
    )
  end

  it 'generates / for root_path' do
    expect(root_path).to eq('/')
  end

  it 'generates /nodes for nodes_path' do
    expect(nodes_path).to eq('/nodes')
  end

  it 'generates /nodes/chicken for node_path(chicken)' do
    chicken = instance_spy('Node', to_param: 'chicken')

    expect(node_path(chicken)).to eq('/nodes/chicken')
  end
end