require_relative 'base'

module OTR
  module ActiveRecord
    # Compatibility layer for ActiveRecord 6
    class Shim < ShimBase
      def initialize
        ::ActiveRecord::Base.default_timezone = :utc
      end
    end
  end
end
