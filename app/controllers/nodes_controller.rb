class NodesController < ApplicationController
  def index
    @nodes = Node.roots
  end

  def show
    @node = Node.find(params.require(:id))
  end

  def new
    @node = Node.new_root
  end

  def create
    @node = Node.new_root(node_params)
    if @node.save
      redirect_to node_path(@node), notice: 'New root node successfully created.'
    else
      render 'new'
    end
  end

  private
  def node_params
    params.require(:node).permit(:name)
  end
end