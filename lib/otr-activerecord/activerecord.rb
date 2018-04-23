require 'erb'

# "Off the Rails" ActiveRecord configuration/integration for Grape, Sinatra, Rack, and any other kind of app
module OTR
  # ActiveRecord configuration module
  module ActiveRecord
    autoload :Compatibility4, 'otr-activerecord/compatibility_4'
    autoload :Compatibility5, 'otr-activerecord/compatibility_5'

    class << self
      # Relative path to the "db" dir
      attr_accessor :db_dir
      # Relative path(s) to the migrations directory
      attr_accessor :migrations_paths
      # Relative path to the fixtures directory
      attr_accessor :fixtures_path
      # Name of the seeds file in db_dir
      attr_accessor :seed_file
      # Internal compatibility layer across different major versions of AR
      attr_accessor :_normalizer
    end

    # Connect to database with a Hash. Example:
    # {adapter: 'postgresql', host: 'localhost', database: 'db', username: 'user', password: 'pass', encoding: 'utf8', pool: 10, timeout: 5000}
    def self.configure_from_hash!(spec)
      config = spec.stringify_keys.merge("migrations_paths" => ::OTR::ActiveRecord.migrations_paths)
      ::ActiveRecord::Base.configurations = {rack_env.to_s => config}
      ::ActiveRecord::Base.establish_connection(rack_env)
    end

    # Connect to database with a DB URL. Example: "postgres://user:pass@localhost/db"
    def self.configure_from_url!(url)
      configure_from_hash! ::ActiveRecord::ConnectionAdapters::ConnectionSpecification::ConnectionUrlResolver.new(url).to_hash
    end

    # Connect to database with a yml file. Example: "config/database.yml"
    def self.configure_from_file!(path)
      raise "#{path} does not exist!" unless File.file? path
      ::ActiveRecord::Base.configurations =
        (YAML.load(ERB.new(File.read(path)).result) || {}).
        reduce({}) { |a, (env, config)|
          a[env] = {"migrations_paths" => ::OTR::ActiveRecord.migrations_paths}.merge config
          a
        }
      ::ActiveRecord::Base.establish_connection(rack_env)
    end

    # The current Rack environment
    def self.rack_env
      (ENV['RACK_ENV'] || ENV['RAILS_ENV'] || ENV['APP_ENV'] || ENV['OTR_ENV'] || 'development').to_sym
    end
  end
end
