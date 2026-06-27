class AddEmbeddingToKnowledgeItems < ActiveRecord::Migration[8.1]
  def change
    add_column :knowledge_items, :embedding, :text
  end
end
