module OTR
  module ActiveRecord
    # Compatibility layer for ActiveRecord 7
    class Compatibility7 < Compatibility6
      def initialize
        @major_version = 7
        ::ActiveRecord.default_timezone = :utc
      end
    end
  end
end
