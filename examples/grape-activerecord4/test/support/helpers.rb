module ApiTestHelpers
  def json_response
    JSON.parse(last_response.body, symbolize_names: true)
  end
end
