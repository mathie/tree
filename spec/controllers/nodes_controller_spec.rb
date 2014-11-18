require 'rails_helper'

RSpec.describe NodesController do
  describe 'GET :index' do
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
  end
end