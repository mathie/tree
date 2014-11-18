require 'rails_helper'

RSpec.feature 'Managing tree nodes' do
  scenario 'Visiting the home page' do
    visit '/'

    expect(page).to have_content('Tree Nodes')
  end
end