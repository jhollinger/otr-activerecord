require 'erb'
require 'uri'
require 'yaml'

# "Off the Rails" ActiveRecord configuration/integration for Grape, Sinatra, Rack, and any other kind of app
module OTR
  # ActiveRecord configuration module
  module ActiveRecord
    autoload :ConnectionManagement, 'otr-activerecord/middleware/connection_management'
    autoload :QueryCache, 'otr-activerecord/middleware/query_cache'
    autoload :Shim, "otr-activerecord/shim/v#{::ActiveRecord::VERSION::MAJOR}"

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
      attr_accessor :shim
    end

    # Connect to database with a Hash. Example:
    # {adapter: 'postgresql', host: 'localhost', database: 'db', username: 'user', password: 'pass', encoding: 'utf8', pool: 10, timeout: 5000}
    def self.configure_from_hash!(spec)
      ::ActiveRecord::Base.configurations = transform_config({rack_env.to_s => spec})
    end

    # Connect to database with a DB URL. Example: "postgres://user:pass@localhost/db"
    def self.configure_from_url!(url)
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
      yaml = ERB.new(File.read(path)).result
      spec = YAML.safe_load(yaml, aliases: true) || {}
      ::ActiveRecord::Base.configurations = transform_config spec
    end

    # Establish a connection to the given db (defaults to current rack env)
    def self.establish_connection!(db = rack_env)
      ::ActiveRecord::Base.establish_connection(db)
    end

    # The current Rack environment
    def self.rack_env
      (ENV['RACK_ENV'] || ENV['RAILS_ENV'] || ENV['APP_ENV'] || ENV['OTR_ENV'] || 'development').to_sym
    end

    def self.transform_config(spec)
      fixup = ->(config) {
        config = config.stringify_keys
        config["migrations_paths"] ||= migrations_paths
        config
      }
      spec.stringify_keys.transform_values { |config|
        if config.all? { |_, v| v.is_a? Hash }
          config.transform_values { |v| fixup.(v) }
        else
          fixup.(config)
        end
      }
    end

    private_class_method :transform_config
  end
end
