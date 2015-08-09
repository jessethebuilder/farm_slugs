require "farm_slugs/engine"

module FarmSlugs
end

module FindForFarmSlugs
  def find(slug)
    if slug.to_i.to_s == slug.to_s
      # Find by integer
      super(slug)
    else
      # Find by slug
      find_by_farm_slug(slug)
    end
  end

  def find_by_farm_slug(slug)
    r = where(@farm_slug_method => slug).limit(1)
    raise ActiveRecord::RecordNotFound, "with id: #{slug}" if r.empty?
    r.first
  end
end
  
class ActiveRecord::Base
  def self.use_farm_slugs(id_method: :name, slug_method: :slug, reserved_names: [])
    @farm_slug_method = slug_method
    # @farm_slug_reserved_names = reserved_names
    
    extend FindForFarmSlugs
    build_instance_methods_for_farm_slugs(id_method, slug_method, reserved_names)

    validates id_method, :presence => true

    validate do
      #records cannot have simple integers for an id_method
      errors.add id_method, "can't be a simple integer" if send(id_method).to_i.to_s == send(id_method).to_s

      #reject if :id_method ends in "/edit" or "/edit/"
      errors.add id_method, 'cannot end with the string "/edit" or "/edit/"' if send(id_method) =~ /\/edit\/?$/
      # errors.add id_method, 'cannot simply be called "new"' if send(id_method).to_s.downcase == 'new'
    end

    after_create{ |r| r.update_slug }
    #update :slug_method if a record is saved that has had changed made to the :id_method,
    #is NOT a new record, and if it passes validation
    after_validation{ |r| r.update_slug if r.changes[id_method] && !r.new_record? && r.errors.empty? }
  end

  private
  


  def self.build_instance_methods_for_farm_slugs(id_method, slug_method, reserved_names = [])
    instance_eval do
      define_method(:slug_is_not_reserved?) do
        # This is necessary to avoid route collision with slug names. "new" and names ending with "/edit" or "/edit/" fail, as
        # do any names specified in the reserved_name parameter of use_farm_slugs 
        reserved_names << 'new'
        reserved_names.each{ |name| return false if name == send(id_method) }
        true
      end  
      
      define_method(:to_param) do
        self.send(slug_method)
      end

      define_method(:update_slug) do
        update_attribute(slug_method, create_farm_slug(send(id_method)))
      end

      define_method(:create_farm_slug) do |val|
        v = val.parameterize
        if slug_is_not_reserved? && self.class.where(slug_method => v).empty?
          v
        else
          "#{v}_#{id}"
        end
      end
      
    end #end instance_eval
  end
end
