class Node < ActiveRecord::Base
  validates :name, presence: true

  def self.create_root_node(params = {})
    roots.create(params)
  end

  def self.create_tree(params)
    children = params.delete(:children)

    root_node = create_root_node(params)

    root_node.create_subtree(children)
  end

  def self.roots
    where(path: [])
  end

  def children
    self.class.where(path: path + [ id ])
  end

  def create_child(params)
    children.create(params)
  end

  def create_subtree(children_params)
    if children_params.present?
      children_params.each do |child_params|
        grandchildren_params = child_params.delete(:children)
        child = create_child(child_params)
        child.create_subtree(grandchildren_params)
      end
    end
  end
end
