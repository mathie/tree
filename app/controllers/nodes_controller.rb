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

  def edit
    @node = Node.find(params.require(:id))
  end

  def update
    @node = Node.find(params.require(:id))
    if @node.update_attributes(node_params)
      redirect_to node_path(@node), notice: 'Node successfully updated.'
    else
      render 'edit'
    end
  end

  private
  def node_params
    params.require(:node).permit(:name)
  end
end