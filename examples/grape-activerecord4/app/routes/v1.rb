module Routes
  module V1
    class API < Grape::API
      version 'v1'
      format :json

      mount Routes::V1::Widgets
    end
  end
end
