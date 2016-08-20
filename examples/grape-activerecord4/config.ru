require './config/application'

use OTR::ActiveRecord::ConnectionManagement

run Rack::Cascade.new([
  Routes::V1::API,
  # add versions as desired
])
