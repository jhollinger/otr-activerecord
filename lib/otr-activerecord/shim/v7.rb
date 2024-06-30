module OTR
  module ActiveRecord
    # Compatibility layer for ActiveRecord 7
    class Shim
      def initialize
        ::ActiveRecord.default_timezone = :utc
      end

      # All db migration dir paths
      def migrations_paths
        OTR::ActiveRecord.migrations_paths
      end

      # The dir in which to put new migrations
      def migrations_path
        OTR::ActiveRecord.migrations_paths[0]
      end

      # Basename of migration classes
      def migration_base_class_name
        version = "7.#{::ActiveRecord::VERSION::MINOR}"
        "ActiveRecord::Migration[#{version}]"
      end

      # Force RACK_ENV/RAILS_ENV to be 'test' when running any db:test:* tasks
      def force_db_test_env?
        false
      end
    end
  end
end
