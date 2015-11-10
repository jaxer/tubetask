class CreateRelations < ActiveRecord::Migration
  def change
    create_table :relations, id: false do |t|
      t.integer :type
      t.integer :external_id
      t.belongs_to :organization, index: true
      t.belongs_to :related_organization, class_name: 'Organization', index: true

      t.timestamps null: false
    end
  end
end
