module OTR
  module ActiveRecord
    # Compatibility layer for ActiveRecord 4
    class Compatibility4
      attr_reader :major_version

      # Compatibility layer for ActiveRecord 4
      def initialize
        @major_version = 4
        ::ActiveRecord::Base.default_timezone = :utc
        ::ActiveRecord::Base.logger = Logger.new(STDOUT)
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
        'ActiveRecord::Migration'
      end

      # Force RACK_ENV/RAILS_ENV to be 'test' when running any db:test:* tasks
      def force_db_test_env?
        true
      end
    end
  end
end
