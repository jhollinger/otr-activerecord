require 'json'
require 'bundler'
Bundler.require(:default, ENV['OTR_ENV'] ? ENV['OTR_ENV'].to_sym : :development)

OTR::ActiveRecord.configure_from_file! './db/config.yml'
OTR::ActiveRecord.establish_connection!

class Widget < ActiveRecord::Base
  validates_presence_of :name
end
