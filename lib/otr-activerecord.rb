require 'active_record'

require 'otr-activerecord/version'
require 'otr-activerecord/activerecord'

ENV["DISABLE_DATABASE_ENVIRONMENT_CHECK"] ||= "true"

OTR::ActiveRecord.db_dir = 'db'
OTR::ActiveRecord.migrations_paths = %w(db/migrate)
OTR::ActiveRecord.fixtures_path = 'test/fixtures'
OTR::ActiveRecord.seed_file = 'seeds.rb'
OTR::ActiveRecord.shim = OTR::ActiveRecord::Shim.new
