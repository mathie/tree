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

  feature 'Creating a new root node' do
    scenario 'finding the new root node button' do
      visit '/'

      click_link 'New root node'

      expect(current_path).to eq('/nodes/new')
    end

    scenario 'hitting the cancel button' do
      visit '/nodes/new'

      click_on 'Cancel'

      expect(current_path).to eq('/nodes')
    end

    scenario 'trying to create a root node without a name' do
      visit '/nodes/new'

      within '#new_node' do
        fill_in 'Name', with: ''
      end

      click_button 'Create Node'

      expect(current_path).to eq('/nodes')
      expect(page).to have_content('Name can\'t be blank')
    end
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

    scenario 'seeing a list of root nodes with their children' do
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

    context 'editing an existing node' do
      scenario 'I can find the edit button on a root node' do
        visit "/nodes/#{root_node.id}"

        click_on 'Edit node'

        expect(current_path).to eq("/nodes/#{root_node.id}/edit")
      end
    end
  end
end