require 'erb'

# "Off the Rails" ActiveRecord configuration/integration for Grape, Sinatra, Rack, and any other kind of app
module OTR
  # ActiveRecord configuration module
  module ActiveRecord
    autoload :Compatibility4, 'otr-activerecord/compatibility_4'
    autoload :Compatibility5, 'otr-activerecord/compatibility_5'
    autoload :Compatibility6, 'otr-activerecord/compatibility_6'
    autoload :Compatibility7, 'otr-activerecord/compatibility_7'

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
    end

    # Connect to database with a DB URL. Example: "postgres://user:pass@localhost/db"
    def self.configure_from_url!(url)
      require 'uri'
      uri = URI(url)
      spec = {"adapter" => uri.scheme}

      case spec["adapter"]
      when /^sqlite/i
        spec["database"] = url =~ /::memory:/ ? ":memory:" : "#{uri.host}#{uri.path}"
      else
        spec["host"] = uri.host if uri.host
        spec["port"] = uri.port if uri.port
        spec["database"] = uri.path.sub(/^\//, "")
        spec["username"] = uri.user if uri.user
        spec["password"] = uri.password if uri.password
      end

      if uri.query
        opts_ary = URI.decode_www_form(uri.query)
        opts = Hash[opts_ary]
        spec.merge!(opts)
      end

      configure_from_hash! spec
    end

    # Connect to database with a yml file. Example: "config/database.yml"
    def self.configure_from_file!(path)
      raise "#{path} does not exist!" unless File.file? path
        result =(YAML.safe_load(ERB.new(File.read(path)).result, aliases: true) || {})
        ::ActiveRecord::Base.configurations = begin
        result.each do |_env, config|
          if config.all? { |_, v| v.is_a?(Hash) }
            config.each { |_, v| append_migration_path(v) }
          else
            append_migration_path(config)
          end
        end
      end
    end

    # Establish a connection to the given db (defaults to current rack env)
    def self.establish_connection!(db = rack_env)
      ::ActiveRecord::Base.establish_connection(db)
    end

    def self.append_migration_path(config)
      config['migrations_paths'] = ::OTR::ActiveRecord.migrations_paths unless config.key?('migrations_paths')
      config
    end

    # The current Rack environment
    def self.rack_env
      (ENV['RACK_ENV'] || ENV['RAILS_ENV'] || ENV['APP_ENV'] || ENV['OTR_ENV'] || 'development').to_sym
    end
  end
end
