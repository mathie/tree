require 'rails_helper'

RSpec.feature 'Managing tree nodes' do
  scenario 'Visiting the home page' do
    visit '/'

    expect(page).to have_content('Tree Nodes')
  end

  scenario 'seeing a list of root nodes' do
    Node.create_root_node name: 'First root node'
    Node.create_root_node name: 'Second root node'

    visit '/'

    expect(page).to have_content('First root node')
    expect(page).to have_content('Second root node')
  end
end