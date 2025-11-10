module OTR
  module ActiveRecord
    #
    # Rack middleware to enable ActiveRecord's query cache for each request.
    #
    class QueryCache
      def initialize(app)
        @app = app
      end

      if ::ActiveRecord.version >= Gem::Version.new('8.1.0.beta1')
        def call(env)
          state = nil
          state = ::ActiveRecord::QueryCache::ExecutorHooks.run
          @app.call(env)
        ensure
          ::ActiveRecord::QueryCache::ExecutorHooks.complete(state) if state
        end
      else
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
end
