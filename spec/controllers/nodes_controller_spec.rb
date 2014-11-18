require 'rails_helper'

RSpec.describe NodesController do
  let(:node_class) { class_spy('Node').as_stubbed_const }

  describe 'GET :index' do
    let(:nodes) { [instance_spy('Node')] }

    before(:each) do
      allow(node_class).to receive(:roots).and_return(nodes)
    end

    def do_get
      get :index
    end

    it 'responds with http success' do
      do_get

      expect(response).to have_http_status(:success)
    end

    it 'renders the index template' do
      do_get

      expect(response).to render_template('nodes/index')
    end

    it 'requests the root nodes from the model' do
      do_get

      expect(node_class).to have_received(:roots)
    end

    it 'assigns @nodes to the view' do
      do_get

      expect(assigns(:nodes)).to eq(nodes)
    end
  end

  describe 'GET :show' do
    let(:node) { instance_spy('Node') }

    before(:each) do
      allow(node_class).to receive(:find).and_return(node)
    end

    def do_get
      get :show, id: 'node'
    end

    it 'responds with http success' do
      do_get

      expect(response).to have_http_status(:success)
    end

    it 'renders the show template' do
      do_get

      expect(response).to render_template('nodes/show')
    end

    it 'requests the node from the model' do
      do_get

      expect(node_class).to have_received(:find).with('node')
    end

    it 'assigns @node to the view' do
      do_get

      expect(assigns(:node)).to eq(node)
    end
  end
end