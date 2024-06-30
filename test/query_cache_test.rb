require 'test_helper'

class QueryCacheTest < Minitest::Test
  def setup
    @db = Tempfile.create
    OTR::ActiveRecord.configure_from_hash!({adapter: "sqlite3", database: @db.path})
    OTR::ActiveRecord.establish_connection!
    Schema.load!
    @cat = Category.create!(name: "Foo")
    Widget.create!(category_id: @cat.id, name: "Spline")
  end

  def teardown
    ActiveRecord::Base.connection_handler.clear_all_connections!
    ActiveRecord::Base.connection_pool.disconnect!
    File.unlink @db.path
  end

  def test_returns_resp
    app = proc do |env|
      Widget.count
      body = "Testing"
      [200, {"Content-Type" => "text/plain", "Content-Length" => body.size.to_s}, [body]]
    end

    middleware = OTR::ActiveRecord::QueryCache.new(app)
    status, headers, body = middleware.call({})

    assert_equal 200, status
    assert_equal "text/plain", headers["Content-Type"]
    assert_equal ["Testing"], body.to_a
  end
end
