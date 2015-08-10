class CreateFarmSlugRequestObjects < ActiveRecord::Migration
  def change
    create_table :farm_slug_request_objects do |t|
      t.string :caption
      t.string :url_slug

      t.timestamps null: false
    end
  end
end
