class CreateFarmSlugObjects < ActiveRecord::Migration
  def change
    create_table :farm_slug_objects do |t|
      t.string :name
      t.string :slug

      t.timestamps null: false
    end
  end
end
