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
        cache = defined?(::ActiveRecord::QueryCache::ExecutorHooks) ? ::ActiveRecord::QueryCache::ExecutorHooks : ::ActiveRecord::QueryCache
        state = cache.run
        @app.call(env)
      ensure
        cache.complete(state) if state
      end
    end
  end
end
