class Category < ActiveRecord::Base
  has_many :widgets
end

class Widget < ActiveRecord::Base
  belongs_to :category
end
