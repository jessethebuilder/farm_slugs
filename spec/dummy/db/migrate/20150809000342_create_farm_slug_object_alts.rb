class CreateFarmSlugObjectAlts < ActiveRecord::Migration
  def change
    create_table :farm_slug_object_alts do |t|
      t.string :title
      t.string :url_slug

      t.timestamps null: false
    end
  end
end
