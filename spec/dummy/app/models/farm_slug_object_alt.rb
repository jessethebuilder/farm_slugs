class FarmSlugObjectAlt < ActiveRecord::Base
  use_farm_slugs :id_method => :title, :slug_method => :url_slug, :reserved_names => ['reserved']
end
