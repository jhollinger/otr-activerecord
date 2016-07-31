module Entities
  module V1
    class Widget < Grape::Entity
      expose :id, documentation: {type: 'integer'}
      expose :name, documentation: {type: 'integer', desc: "Widget name"}
    end
  end
end
