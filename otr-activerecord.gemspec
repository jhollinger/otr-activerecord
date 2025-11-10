# encoding: utf-8

require File.expand_path('../lib/otr-activerecord/version.rb', __FILE__)
Gem::Specification.new do |gem|
  gem.name = 'otr-activerecord'
  gem.version = OTR::ActiveRecord::VERSION

  gem.description = 'Off The Rails ActiveRecord: Use ActiveRecord with Grape, Sinatra, Rack, or anything else! Formerly known as \'grape-activerecord\'.'
  gem.summary = 'Off The Rails: Use ActiveRecord with Grape, Sinatra, Rack, or anything else!'
  gem.homepage = 'https://github.com/jhollinger/otr-activerecord'

  gem.authors = ['Jordan Hollinger']
  gem.email = 'jordan.hollinger@gmail.com'

  gem.license = 'MIT'

  gem.files = Dir['lib/**/**'] + ['README.md', 'LICENSE']

  gem.required_ruby_version = '>= 3.0.0'

  gem.add_runtime_dependency 'activerecord', ['>= 6.0', '< 8.2']
end
