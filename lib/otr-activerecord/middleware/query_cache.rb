module OTR
  module ActiveRecord
    #
    # Rack middleware to enable ActiveRecord's query cache for each request.
    #
    class QueryCache
      def initialize(app)
        @handler = case ::ActiveRecord::VERSION::MAJOR
                   when 4 then ::ActiveRecord::QueryCache.new(app)
                   when 5, 6 then ActionDispatchHandler.new(app)
                   end
      end

      def call(env)
        @handler.call(env)
      end

      class ActionDispatchHandler
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
end
