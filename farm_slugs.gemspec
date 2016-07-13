$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "farm_slugs/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "farm_slugs"
  s.version     = FarmSlugs::VERSION
  s.authors     = ["Jesse Farmer"]
  s.email       = ["jesse@anysoft.us"]
  s.homepage    = "http://anysoft.us"
  s.summary     = "A handy gem for generating meaningful urls"
  s.description = "Just add use_farm_slugs to your model, and make sure you have a column named 'name' and 'slug' (those are just the defaults. 
                   You can change them)."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "rails"

  s.add_development_dependency "sqlite3"
  
  s.test_files = Dir["spec/**/*"]
end
