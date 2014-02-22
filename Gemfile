source 'https://rubygems.org'

ruby '2.0.0'

gem 'grape'
gem 'grape-swagger'
gem 'datamapper'

group :production do
  gem 'pg'
  gem 'dm-postgres-adapter'
end

group :development, :test do
  gem 'sqlite3'
  gem 'dm-sqlite-adapter'
end
group :test do
  gem 'rspec'
  gem 'autotest'
  gem 'autotest-fsevent'
  gem 'rack-test'
end
