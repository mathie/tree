class Node < ActiveRecord::Base
  include TreeNode

  validates :name, presence: true
end
