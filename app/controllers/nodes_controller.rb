class NodesController < ApplicationController
  def index
    @nodes = Node.roots
  end

  def show
    @node = Node.find(params.require(:id))
  end
end