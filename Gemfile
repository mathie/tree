source 'https://rubygems.org'

ruby File.read(File.expand_path('../.ruby-version', __FILE__)).chomp

gem 'rails', '~> 4.2.0.beta4'
gem 'pg'
gem 'postgres_ext'
gem 'unicorn'
gem 'rails_12factor', group: :production

# Asset Pipeline
gem 'sass-rails', '~> 5.0.0.beta1'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.1.0'
gem 'jquery-rails', '~> 4.0.0.beta2'
gem 'bootstrap-sass'
gem 'autoprefixer-rails'

group :development, :test do
  gem 'byebug'
  gem 'web-console', '~> 2.0.0.beta4'
  gem 'spring'
  gem 'spring-commands-rspec'

  gem 'rspec-rails'
  gem 'capybara'

  gem 'guard-bundler', require: false
  gem 'guard-rspec', require: false
  gem 'ruby_gntp'
end

