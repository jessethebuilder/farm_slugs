class FarmSlugRequestObject < ActiveRecord::Base
  use_farm_slugs :id_method => :caption, :slug_method => :url_slug
end
