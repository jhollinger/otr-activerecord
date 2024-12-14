module OTR
  module ActiveRecord
    # Base compatibility layer for ActiveRecord
    class ShimBase
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
        major_v = ::ActiveRecord::VERSION::MAJOR
        minor_v = ::ActiveRecord::VERSION::MINOR
        "ActiveRecord::Migration[#{major_v}.#{minor_v}]"
      end

      # Force RACK_ENV/RAILS_ENV to be 'test' when running any db:test:* tasks
      def force_db_test_env?
        false
      end
    end
  end
end
