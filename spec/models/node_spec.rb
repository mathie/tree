require 'rails_helper'

RSpec.describe Node do
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

  describe '.create_root_node' do
    it 'persists a new root node' do
      expect do
        Node.create_root_node name: 'Root node'
      end.to change(Node.roots, :count).by(1)
    end
  end

  describe '.roots' do
    subject { Node.roots }

    def root_node(params)
      Node.create! params
    end

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
      def child_node(params)
        # FIXME: Implementation needs to work in terms of a built in child
        # creator when that functionality exists and is tested... It'll
        # currently only work with creating immediate children of a root node.
        parent = params.delete(:parent)
        raise "Parent must per persisted" unless parent.present? && parent.persisted?

        Node.create!(params.merge(path: [ parent.id ]))
      end

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
end
