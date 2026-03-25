source "https://rubygems.org"

gem "rails", "~> 8.1.3"
gem "pg", "~> 1.1"
gem "puma", ">= 5.0"
gem "redis", ">= 4.0.1"
gem "sidekiq", ">= 7.0"
gem "bcrypt", "~> 3.1.7"
gem "jwt"
gem "tzinfo-data", platforms: %i[ windows jruby ]
gem "bootsnap", require: false
gem "rack-cors"

group :development, :test do
  gem "rspec-rails", "~> 7.0"
  gem "rswag"
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"
  gem "brakeman", require: false
  gem "rubocop-rails-omakase", require: false
end
