require 'json'
require 'bundler'
Bundler.require(:default, ENV['OTR_ENV'] ? ENV['OTR_ENV'].to_sym : :development)
OTR::ActiveRecord.configure_from_file! './data/config.yml'
#OTR::ActiveRecord.configure_from_url! 'sqlite3:///home/jhollinger/devel/otr-activerecord/examples/rakefile-activerecord5.2/db.sqlite3'
#OTR::ActiveRecord.configure_from_hash!(adapter: 'sqlite3', database: '/home/jhollinger/devel/otr-activerecord/examples/rakefile-activerecord5.2/db.sqlite3')

class Widget < ActiveRecord::Base
  validates_presence_of :name
end
