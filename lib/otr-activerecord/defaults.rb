ENV['RACK_ENV'] ||= OTR::ActiveRecord.rack_env.to_s
ENV['RAILS_ENV'] ||= OTR::ActiveRecord.rack_env.to_s

OTR::ActiveRecord.db_dir = 'db'
OTR::ActiveRecord.migrations_paths = %w(db/migrate)
OTR::ActiveRecord.fixtures_path = 'test/fixtures'
OTR::ActiveRecord.seed_file = 'seeds.rb'
OTR::ActiveRecord._normalizer = case ::ActiveRecord::VERSION::MAJOR
                                when 4 then OTR::ActiveRecord::Compatibility4.new
                                when 5 then OTR::ActiveRecord::Compatibility5.new
                                end
