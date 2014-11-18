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
end