module TreeNode
  extend ActiveSupport::Concern

  module ClassMethods
    def new_root(params = {})
      roots.new(params)
    end

    def create_root(params = {})
      roots.create(params)
    end

    def create_tree(params)
      children = params.delete(:children)

      root_node = create_root(params)

      root_node.create_subtree(children)
    end

    def roots
      where(path: [])
    end
  end

  def root
    root_id = path.first
    if root_id.present?
      self.class.find(root_id)
    else
      self
    end
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