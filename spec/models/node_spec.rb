require 'rails_helper'

RSpec.describe Node do
  def root_node(params)
    described_class.create_root params
  end

  def child_node(params)
    parent = params.delete(:parent)
    raise "Parent must per persisted" unless parent.present? && parent.persisted?

    parent.create_child(params)
  end

  describe 'validations' do
    subject { described_class.new name: 'Valid root node' }

    it 'has a valid subject' do
      expect(subject).to be_valid
    end

    it 'requires a name' do
      subject.name = ''

      expect(subject).not_to be_valid
      expect(subject.errors[:name]).to include("can't be blank")
    end
  end

  describe '.create_root' do
    it 'persists a new root node' do
      expect do
        Node.create_root name: 'Root node'
      end.to change(Node.roots, :count).by(1)
    end
  end

  describe '.create_tree' do
    context 'with a single root node' do
      subject do
        Node.create_tree name: 'Root node'
      end

      it 'persists the new root node' do
        expect { subject }.to change(Node.roots, :count).by(1)
      end

      it 'creates a single new node' do
        expect { subject }.to change(Node, :count).by(1)
      end
    end

    context 'with a root node and a child' do
      subject do
        Node.create_tree name: 'Root node',
          children: [
            { name: 'Child node' }
          ]
      end

      it 'persists the new root node' do
        expect { subject }.to change(Node.roots, :count).by(1)
      end

      it 'persists the new nodes' do
        expect { subject }.to change(Node, :count).by(2)
      end
    end

    context 'with a root node and multiple children' do
      subject do
        Node.create_tree name: 'Root node',
          children: [
            { name: 'Child node 1' },
            { name: 'Child node 2' }
          ]
      end

      it 'persists the new root node' do
        expect { subject }.to change(Node.roots, :count).by(1)
      end

      it 'persists the new nodes' do
        expect { subject }.to change(Node, :count).by(3)
      end
    end

    context 'with multiply nested children' do
      subject do
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

      it 'persists the new root node' do
        expect { subject }.to change(Node.roots, :count).by(1)
      end

      it 'persists the new nodes' do
        expect { subject }.to change(Node, :count).by(7)
      end
    end
  end

  describe '.roots' do
    subject { Node.roots }

    context 'with no root nodes' do
      it 'returns an ActiveRecord::Relation' do
        expect(subject).to be_an(ActiveRecord::Relation)
      end

      it 'is empty' do
        expect(subject).to be_empty
      end
    end

    context 'with a single root' do
      let!(:node) { root_node(name: 'Single root node') }

      it 'returns an ActiveRecord::Relation' do
        expect(subject).to be_an(ActiveRecord::Relation)
      end

      it 'is contains one node' do
        expect(subject.count).to eq(1)
      end

      it 'returns that single node' do
        expect(subject).to eq([node])
      end
    end

    context 'with a pair of root nodes' do
      let!(:first_root_node)  { root_node(name: 'First root node')  }
      let!(:second_root_node) { root_node(name: 'Second root node') }

      it 'returns an ActiveRecord::Relation' do
        expect(subject).to be_an(ActiveRecord::Relation)
      end

      it 'is contains two nodes' do
        expect(subject.count).to eq(2)
      end

      it 'returns the pair of nodes' do
        expect(subject).to include(first_root_node)
        expect(subject).to include(second_root_node)
      end
    end

    context 'with a single root and a child' do
      let!(:root)  { root_node(name: 'Single root node') }
      let!(:child) { child_node(name: 'Child node', parent: root) }

      it 'returns an ActiveRecord::Relation' do
        expect(subject).to be_an(ActiveRecord::Relation)
      end

      it 'is contains one node' do
        expect(subject.count).to eq(1)
      end

      it 'returns that single root node' do
        expect(subject).to eq([root])
      end
    end
  end

  describe '.children' do
    subject { node.children }

    context 'of a root node' do
      let!(:node)  { root_node  name: 'Root node' }

      context 'with no children' do
        it 'returns an ActiveRecord::Relation' do
          expect(subject).to be_an(ActiveRecord::Relation)
        end

        it 'is contains no nodes' do
          expect(subject.count).to eq(0)
        end

        it 'returns the empty list' do
          expect(subject).to eq([])
        end
      end

      context 'with a single child' do
        let!(:child) { child_node name: 'Child node', parent: node }

        it 'returns an ActiveRecord::Relation' do
          expect(subject).to be_an(ActiveRecord::Relation)
        end

        it 'is contains one node' do
          expect(subject.count).to eq(1)
        end

        it 'returns the correct child node' do
          expect(subject).to eq([child])
        end
      end
    end
  end
end
