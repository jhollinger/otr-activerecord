require_relative './test_case'

class ApiV1TestCase < TestCase
  include Rack::Test::Methods
  include ApiTestHelpers

  def app
    Routes::V1::API
  end
end

class ApiV2TestCase < TestCase
  include Rack::Test::Methods
  include ApiTestHelpers

  def app
    Routes::V1::AP2
  end
end
