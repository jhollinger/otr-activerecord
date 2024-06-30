require 'test_helper'
require 'rake'
require 'json'

class RakeTest < Minitest::Test
  def self.test_order; :alpha; end

  def setup
    Dir.chdir TestApp::DIR if TestApp.exists?
  end

  def teardown
    Dir.chdir Rake.application.original_dir
  end

  def test_1_create
    TestApp.delete if TestApp.exists?
    TestApp.create
  end

  def test_2_setup
    skip unless TestApp.exists?
    assert system "bundle install"
    assert system "bundle exec rake db:setup"
    widgets = JSON.parse(`bundle exec rake widgets:list`)
    assert_equal ["Foo"], widgets.map { |w| w["name"] }
  end

  def test_3_create_migration
    skip unless TestApp.exists?
    migration = `bundle exec rake db:create_migration[add_active]`.chomp

    assert File.exist? migration
    assert_equal <<-STR.chomp, File.read(migration).chomp
class AddActive < ActiveRecord::Migration[#{ActiveRecord::VERSION::MAJOR}.#{ActiveRecord::VERSION::MINOR}]
  def change
  end
end
    STR
  end

  def test_4_run_migration
    skip unless TestApp.exists?
    migration = Dir.glob("db/migrate/*.rb")[0]
    File.write migration, <<-STR
class AddActive < ActiveRecord::Migration[#{ActiveRecord::VERSION::MAJOR}.#{ActiveRecord::VERSION::MINOR}]
  def change
    add_column :widgets, :active, :boolean, default: true, null: false
  end
end
    STR

    assert system "bundle exec rake db:migrate db:test:prepare"
    widgets = JSON.parse(`bundle exec rake widgets:list`)
    assert_equal ["Foo:true"], widgets.map { |w| "#{w['name']}:#{w['active']}" }
  end

  def test_5_teardown
    TestApp.delete
  end
end
