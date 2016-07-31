ENV['RACK_ENV'] = 'test'

require 'minitest/autorun'
require_relative '../config/application'
require 'active_record/fixtures'

ActiveRecord::Base.logger = nil
ActiveRecord::Migration.verbose = false

DatabaseCleaner.strategy = :transaction

Dir.glob('./test/support/*.rb').each { |file| require file }
