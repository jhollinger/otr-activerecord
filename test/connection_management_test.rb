require 'test_helper'

class ConnectionManagementTest < Minitest::Test
  def setup
    @db = Tempfile.create
    OTR::ActiveRecord.configure_from_hash!({adapter: "sqlite3", database: @db.path})
    OTR::ActiveRecord.establish_connection!
    Schema.load!
    cat = Category.create!(name: "Foo")
    Widget.create!(category_id: cat.id, name: "Spline")
  end

  def teardown
    ActiveRecord::Base.connection_handler.clear_all_connections!
    ActiveRecord::Base.connection_pool.disconnect!
    File.unlink @db.path
  end

  def test_returns_resp
    app = proc do |env|
      body = "Testing"
      [200, {"Content-Type" => "text/plain", "Content-Length" => body.size.to_s}, [body]]
    end

    middleware = OTR::ActiveRecord::ConnectionManagement.new(app)
    status, headers, body = middleware.call({})

    assert_equal 200, status
    assert_equal "text/plain", headers["Content-Type"]
    assert_equal ["Testing"], body.to_a
  end

  def test_with_no_queries
    called = false
    app = proc do |env|
      called = true
      body = "Testing"
      [200, {"Content-Type" => "text/plain", "Content-Length" => body.size.to_s}, [body]]
    end

    middleware = OTR::ActiveRecord::ConnectionManagement.new(app)
    middleware.call({})
    assert called
  end

  def test_with_queries
    n = nil
    app = proc do |env|
      n = Widget.count
      body = "Testing"
      [200, {"Content-Type" => "text/plain", "Content-Length" => body.size.to_s}, [body]]
    end

    middleware = OTR::ActiveRecord::ConnectionManagement.new(app)
    middleware.call({})
    assert_equal 1, n
  end

  def test_with_many_threads
    app = proc do |env|
      n = Widget.count
      body = n.to_s
      [200, {"Content-Type" => "text/plain", "Content-Length" => body.size.to_s}, [body]]
    end

    n = 500
    middleware = OTR::ActiveRecord::ConnectionManagement.new(app)
    results = n.times
      .map {
        Thread.new {
          _, _, body = middleware.call({})
          body.close
          body[0]
        }
      }
      .map(&:value)

    assert_equal n.times.map { "1" }, results
  end
end
