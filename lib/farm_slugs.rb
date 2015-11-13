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

    # validates id_method, :presence => true

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
        reserved_names.each{ |name| return false if name.to_s.downcase == send(id_method).to_s.downcase }
        return false if slug_is_an_integer? 
        true
      end  
    
      define_method(:slug_is_an_integer?) do
        /\A\d+\Z/ =~ send(id_method) ? true : false
      end     
       
      define_method(:to_param) do
        self.send(slug_method) || self.id
      end

      define_method(:update_slug) do
        this_slug = send(id_method) || "#{self.class.name.underscore.humanize.parameterize}_#{send(:id)}"
          update_attribute(slug_method, create_farm_slug(this_slug[0..99])) 
      
        # update_attribute(slug_method, create_farm_slug(truncate(this_slug, length: 100, omission: ''))) 
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
