class KnowledgeItemsController < ApplicationController
  before_action :set_knowledge_item, only: %i[show edit update destroy]

  def index
    @knowledge_items = KnowledgeItem.all
  end

  def show
  end

  def new
    @knowledge_item = KnowledgeItem.new
  end

  def edit
  end

  def create
    @knowledge_item = KnowledgeItem.new(knowledge_item_params)

    if @knowledge_item.save
      redirect_to @knowledge_item, notice: "Fiche créée avec succès."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @knowledge_item.update(knowledge_item_params)
      redirect_to @knowledge_item, notice: "Fiche mise à jour avec succès."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @knowledge_item.destroy
    redirect_to knowledge_items_path, notice: "Fiche supprimée avec succès.", status: :see_other
  end

  private

  def set_knowledge_item
    @knowledge_item = KnowledgeItem.find(params[:id])
  end

  def knowledge_item_params
    params.require(:knowledge_item).permit(:title, :category, :content, :source, :embedding)
  end
end
