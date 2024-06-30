module OTR
  module ActiveRecord
    #
    # Rack middleware to enable ActiveRecord's query cache for each request.
    #
    class QueryCache
      def initialize(app)
        @app = app
      end

      def call(env)
        state = nil
        state = ::ActiveRecord::QueryCache.run
        @app.call(env)
      ensure
        ::ActiveRecord::QueryCache.complete(state) if state
      end
    end
  end
end
