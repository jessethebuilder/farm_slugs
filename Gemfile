source 'https://rubygems.org'

# Declare your gem's dependencies in meta_farm.gemspec.
# Bundler will treat runtime dependencies like base dependencies, and
# development dependencies will be added by default to the :development group.
gemspec

# Declare any dependencies that are still in development here instead of in
# your gemspec. These might include edge Rails or gems from your path or
# Git. Remember to move these dependencies to your gemspec before releasing
# your gem to rubygems.org.

# To use a debugger
# gem 'byebug', group: [:development, :test]

group :test, :development do
  gem 'faker'
  gem 'rspec-rails'
  # gem 'wdm'
  gem 'database_cleaner', '~> 1.0.0rc'
  # gem 'timecop'
end

group :test do
  gem 'factory_girl_rails'
  gem 'capybara'
  gem 'guard-rspec'
  # gem 'selenium-webdriver'
  gem 'shoulda'
  # gem 'launchy', '~> 2.3.0'
  # gem 'poltergeist'
end


group :production do
  # gem 'faker'
  gem 'rails_12factor'
end

ruby '2.1.5'

gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
