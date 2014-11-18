class Node < ActiveRecord::Base
  validates :name, presence: true

  def self.create_root_node(params = {})
    roots.create(params)
  end

  def self.roots
    where(path: [])
  end
end
