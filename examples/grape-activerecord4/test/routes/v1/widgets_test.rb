require_relative '../../test_helper'

class ApiV1WidgestTest < ApiV1TestCase
  def test_get_widgets
    get '/v1/widgets'
    assert_equal 1, json_response.size
  end
end
