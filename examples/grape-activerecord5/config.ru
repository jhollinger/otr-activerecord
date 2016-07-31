require './config/application'

use ActiveRecord::ConnectionAdapters::ConnectionManagement

run Rack::Cascade.new([
  Routes::V1::API,
  # add versions as desired
])
