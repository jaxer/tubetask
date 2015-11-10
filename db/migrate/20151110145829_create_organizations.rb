class CreateOrganizations < ActiveRecord::Migration
  def change
    create_table :organizations do |t|
      t.string :name
      t.integer :external_id

      t.datetime :sync_started_at
      t.datetime :sync_finished_at

      t.timestamps null: false
    end
  end
end
