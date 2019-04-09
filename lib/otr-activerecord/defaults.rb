ENV["DISABLE_DATABASE_ENVIRONMENT_CHECK"] ||= "true"

OTR::ActiveRecord.db_dir = 'db'
OTR::ActiveRecord.migrations_paths = %w(db/migrate)
OTR::ActiveRecord.fixtures_path = 'test/fixtures'
OTR::ActiveRecord.seed_file = 'seeds.rb'
OTR::ActiveRecord._normalizer = case ::ActiveRecord::VERSION::MAJOR
                                when 4 then OTR::ActiveRecord::Compatibility4.new
                                when 5 then OTR::ActiveRecord::Compatibility5.new
                                when 6 then OTR::ActiveRecord::Compatibility6.new
                                end
