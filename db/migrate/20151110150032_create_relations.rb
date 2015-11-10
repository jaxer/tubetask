class CreateRelations < ActiveRecord::Migration
  def change
    create_table :relations do |t|
      t.integer :relation_type
      t.integer :external_id
      t.belongs_to :organization, index: true
      t.belongs_to :related_organization, class_name: 'Organization', index: true

      t.datetime :sync_started_at
      t.datetime :sync_finished_at

      t.timestamps null: false
    end
  end
end
