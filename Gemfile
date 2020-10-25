source 'https://rubygems.org'

gem 'dry-transaction'
gem 'hanami',       '~> 1.3'
gem 'hanami-model', '~> 1.3'
gem 'rake'

gem 'sqlite3'

group :development do
  # Code reloading
  # See: https://guides.hanamirb.org/projects/code-reloading
  gem 'hanami-webconsole'
  gem 'shotgun', platforms: :ruby
end

group :test, :development do
  gem 'dotenv', '~> 2.4'
end

group :test do
  gem 'capybara'
  gem 'database_cleaner'
  gem 'rspec'
end

group :production do
  # gem 'puma'
end
