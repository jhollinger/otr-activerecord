module Routes
  module V1
    class Widgets < Grape::API
      desc "Get a list of Widgets"
      get :widgets do
        present Widget.all, with: Entities::V1::Widget
      end
    end
  end
end
