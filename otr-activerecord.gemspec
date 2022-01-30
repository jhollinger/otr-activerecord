# encoding: utf-8

require File.expand_path('../lib/otr-activerecord/version.rb', __FILE__)
Gem::Specification.new do |gem|
  gem.name = 'otr-activerecord'
  gem.version = OTR::ActiveRecord::VERSION
  gem.date = '2022-01-30'

  gem.description = 'Off The Rails ActiveRecord: Use ActiveRecord with Grape, Sinatra, Rack, or anything else! Formerly known as \'grape-activerecord\'.'
  gem.summary = 'Off The Rails: Use ActiveRecord with Grape, Sinatra, Rack, or anything else!'
  gem.homepage = 'https://github.com/jhollinger/otr-activerecord'

  gem.authors = ['Jordan Hollinger']
  gem.email = 'jordan.hollinger@gmail.com'

  gem.license = 'MIT'

  gem.files = Dir['lib/**/**'] + ['README.md', 'LICENSE']

  gem.required_ruby_version = '>= 2.1.0'

  gem.add_runtime_dependency 'activerecord', ['>= 4.0', '< 7.1']
  gem.add_runtime_dependency 'hashie-forbidden_attributes', '~> 0.1'
end
