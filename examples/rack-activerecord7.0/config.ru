require_relative 'environment'

use OTR::ActiveRecord::ConnectionManagement
use OTR::ActiveRecord::QueryCache

map '/' do
  run ->(env) {
    body = Widget.all
      .map { |w|
        {id: w.id, name: w.name}
      }
      .to_json
    [200, {'Content-Type' => 'application/json', 'Content-Length' => body.size.to_s}, [body]]
  }
end
