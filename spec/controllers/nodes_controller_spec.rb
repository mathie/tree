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

  describe 'GET :new' do
    let(:node) { instance_spy('Node') }

    before(:each) do
      allow(node_class).to receive(:new_root).and_return(node)
    end

    def do_get
      get :new
    end

    it 'responds with http success' do
      do_get

      expect(response).to have_http_status(:success)
    end

    it 'renders the new template' do
      do_get

      expect(response).to render_template('nodes/new')
    end

    it 'builds a new root node from the model' do
      do_get

      expect(node_class).to have_received(:new_root)
    end

    it 'assigns @node to the view' do
      do_get

      expect(assigns(:node)).to eq(node)
    end
  end

  describe 'POST :create' do
    let(:node) { instance_spy('Node', save: true, to_param: 'node') }
    let(:node_params) { { name: 'Root node' } }
    let(:params) { { node: node_params } }

    before(:each) do
      allow(node_class).to receive(:new_root).and_return(node)
    end

    def do_post(params = params)
      post :create, params
    end

    it 'builds a new node' do
      do_post

      expect(node_class).to have_received(:new_root)
    end

    it 'attempts to save the new node' do
      do_post

      expect(node).to have_received(:save)
    end

    context 'when successfully saved' do
      before(:each) do
        allow(node).to receive(:save).and_return(true)
      end

      it 'redirects to the newly created node' do
        do_post

        expect(response).to redirect_to(node_path(node))
      end

      it 'sets a flash notice' do
        do_post

        expect(flash.notice).to eq('New root node successfully created.')
      end
    end

    context 'when it fails to save' do
      before(:each) do
        allow(node).to receive(:save).and_return(false)
      end

      it 'returns http success' do
        do_post

        expect(response).to have_http_status(:success)
      end

      it 'renders the new template' do
        do_post

        expect(response).to render_template('nodes/new')
      end

      it 'assigns the node to the view' do
        do_post

        expect(assigns(:node)).to eq(node)
      end
    end
  end

  describe 'GET :edit' do
    let(:node) { instance_spy('Node') }

    before(:each) do
      allow(node_class).to receive(:find).and_return(node)
    end

    def do_get
      get :edit, id: 'node'
    end

    it 'responds with http success' do
      do_get

      expect(response).to have_http_status(:success)
    end

    it 'renders the edit template' do
      do_get

      expect(response).to render_template('nodes/edit')
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

  describe 'PUT :update' do
    let(:node) { instance_spy('Node', update_attributes: true, to_param: 'node') }
    let(:node_params) { { name: 'Alternate root node' } }
    let(:params) { { id: 'node', node: node_params } }

    before(:each) do
      allow(node_class).to receive(:find).and_return(node)
    end

    def do_put(params = params)
      put :update, params
    end

    it 'finds the existing node' do
      do_put

      expect(node_class).to have_received(:find).with('node')
    end

    it 'attempts to update the node attributes' do
      do_put

      expect(node).to have_received(:update_attributes).with(node_params)
    end

    context 'when successfully saved' do
      before(:each) do
        allow(node).to receive(:update_attributes).and_return(true)
      end

      it 'redirects to the updated node' do
        do_put

        expect(response).to redirect_to(node_path(node))
      end

      it 'sets a flash notice' do
        do_put

        expect(flash.notice).to eq('Node successfully updated.')
      end
    end

    context 'when it fails to save' do
      before(:each) do
        allow(node).to receive(:update_attributes).and_return(false)
      end

      it 'returns http success' do
        do_put

        expect(response).to have_http_status(:success)
      end

      it 'renders the edit template' do
        do_put

        expect(response).to render_template('nodes/edit')
      end

      it 'assigns the node to the view' do
        do_put

        expect(assigns(:node)).to eq(node)
      end
    end
  end
end