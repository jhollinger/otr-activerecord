require 'test_helper'

class ConfigureTest < Minitest::Test
  def test_configure_from_file
    OTR::ActiveRecord.configure_from_file! "test/fixtures/simple.yml"

    t = ::ActiveRecord::Base.configurations.find_db_config('test')
    assert_equal "sqlite3", t.adapter
    assert_equal "tmp/simple.sqlite3", t.database
    assert_equal ['db/migrate'], t.migrations_paths
  end

  def test_configure_from_file_with_multiple_roles
    OTR::ActiveRecord.configure_from_file! "test/fixtures/multi.yml"

    t = ::ActiveRecord::Base.configurations.find_db_config('test')
    assert_equal "sqlite3", t.adapter
    assert_equal "tmp/multi.sqlite3", t.database
    assert_equal ['db/migrate'], t.migrations_paths
  end

  def test_configure_from_url
    OTR::ActiveRecord.configure_from_url! "postgresql://foo:bar@my.host/mydb"

    t = ::ActiveRecord::Base.configurations.find_db_config('development')
    assert_equal "postgresql", t.adapter
    assert_equal "my.host", t.host
    assert_equal "mydb", t.database
    assert_equal ['db/migrate'], t.migrations_paths
  end

  def test_configure_from_url_with_port
    OTR::ActiveRecord.configure_from_url! "postgresql://foo:bar@my.host/mydb:5433"

    t = ::ActiveRecord::Base.configurations.find_db_config('development')
    assert_equal "postgresql", t.adapter
    assert_equal "my.host", t.host
    assert_equal "mydb:5433", t.database
    assert_equal ['db/migrate'], t.migrations_paths
  end

  def test_configure_from_url_using_sqlite3
    OTR::ActiveRecord.configure_from_url! "sqlite3:///srv/db/mydb.sqlite3"

    t = ::ActiveRecord::Base.configurations.find_db_config('development')
    assert_equal "sqlite3", t.adapter
    assert_equal "/srv/db/mydb.sqlite3", t.database
    assert_equal ['db/migrate'], t.migrations_paths
  end

  def test_configure_from_url_using_sqlite3_memory
    OTR::ActiveRecord.configure_from_url! "sqlite3::memory:"

    t = ::ActiveRecord::Base.configurations.find_db_config('development')
    assert_equal "sqlite3", t.adapter
    assert_equal ":memory:", t.database
    assert_equal ['db/migrate'], t.migrations_paths
  end

  def test_configure_from_hash
    OTR::ActiveRecord.configure_from_hash!({adapter: "postgresql", host: "localhost", database: "db"})

    t = ::ActiveRecord::Base.configurations.find_db_config('development')
    assert_equal "postgresql", t.adapter
    assert_equal "localhost", t.host
    assert_equal "db", t.database
    assert_equal ['db/migrate'], t.migrations_paths
  end

  def test_configure_from_hash_with_multiple_roles
    OTR::ActiveRecord.configure_from_hash!({
      primary: {adapter: "postgresql", host: "localhost", database: "primary"},
      reading: {adapter: "postgresql", host: "localhost", database: "reading"},
    })

    t = ::ActiveRecord::Base.configurations.find_db_config('development')
    assert_equal "postgresql", t.adapter
    assert_equal "localhost", t.host
    assert_equal "primary", t.database
    assert_equal ['db/migrate'], t.migrations_paths
  end
end
