require 'rails_helper'

RSpec.feature 'Managing tree nodes' do
  scenario 'Visiting the home page' do
    visit '/'

    expect(page).to have_content('Tree Nodes')
  end

  scenario 'seeing a list of root nodes' do
    Node.create_root name: 'First root node'
    Node.create_root name: 'Second root node'

    visit '/'

    expect(page).to have_content('First root node')
    expect(page).to have_content('Second root node')
  end

  context 'with a tree of nodes' do
    before(:each) do
      Node.create_tree name: 'Root node',
        children: [
          {
            name: 'Intermediate node 1',
            children: [
              { name: 'Child node 1' },
              { name: 'Child node 2' }
            ]
          },
          {
            name: 'Intermediate node 2',
            children: [
              { name: 'Child node 3' },
              { name: 'Child node 4' }
            ]
          },
        ]
    end

    let(:root_node) { Node.roots.first }

    scenario 'seeing a list of root nodes wtih their children' do
      visit '/'

      expect(page).to have_content('Root node')
      expect(page).to have_content('Intermediate node 1')
      expect(page).to have_content('Intermediate node 2')
      expect(page).to have_content('Child node 1')
      expect(page).to have_content('Child node 2')
      expect(page).to have_content('Child node 3')
      expect(page).to have_content('Child node 4')
    end

    scenario 'I can click on a node to see its details' do
      visit '/'

      click_link 'Root node'

      expect(current_path).to eq("/nodes/#{root_node.id}")
      expect(page).to have_content('Root node')
    end

    scenario 'Seeing the details on a root node' do
      visit "/nodes/#{root_node.id}"

      expect(page).to have_content('Root node')
    end
  end
end