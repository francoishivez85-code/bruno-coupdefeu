class CreateKnowledgeItems < ActiveRecord::Migration[8.1]
  def change
    create_table :knowledge_items do |t|
      t.string :category
      t.string :title
      t.text :content
      t.string :source

      t.timestamps
    end
  end
end
