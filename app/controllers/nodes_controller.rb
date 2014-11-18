class NodesController < ApplicationController
  def index
    @nodes = Node.roots
  end
end