require 'fileutils'

module TestApp
  DIR = "/tmp/otr-activerecord-test-app"
  DB_DEV = "db/development.sqlite3"
  DB_TEST = "db/test.sqlite3"
  DB_PROD = "db/production.sqlite3"

  def self.delete
    FileUtils.rm_r DIR
  end

  def self.exists?
    Dir.exist? DIR
  end

  def self.create
    FileUtils.mkdir_p DIR
    FileUtils.mkdir_p File.join(DIR, "db", "migrate")
    File.write File.join(DIR, "Gemfile"), gemfile
    File.write File.join(DIR, "Rakefile"), rakefile
    File.write File.join(DIR, "models.rb"), models
    File.write File.join(DIR, "db", "schema.rb"), schemarb
    File.write File.join(DIR, "db", "seeds.rb"), seedsrb
    File.write File.join(DIR, "db", "config.yaml"), dbconfig
  end

  def self.models
    <<-STR
      class Widget < ActiveRecord::Base
      end
    STR
  end

  def self.gemfile
    File
      .readlines(File.join("gemfiles", "ar_#{ActiveRecord::VERSION::MAJOR}.#{ActiveRecord::VERSION::MINOR}.gemfile"))
      .select { |line| line =~ /source|rake|activerecord|sqlite/ }
      .push("gem 'otr-activerecord', path: #{Rake.application.original_dir}")
      .join("")
  end

  def self.rakefile
    <<-STR
      require 'json'
      require 'bundler/setup'
      load 'tasks/otr-activerecord.rake'

      namespace :db do
        task :environment do
          require_relative "./models"
          OTR::ActiveRecord.configure_from_file! "db/config.yaml"
          OTR::ActiveRecord.establish_connection!
        end
      end

      namespace :widgets do
        desc "List all widgets"
        task :list => 'db:environment' do
          widgets = Widget.order('name').to_a
          puts widgets.map(&:as_json).to_json
        end
      end
    STR
  end

  def self.dbconfig
    <<-STR
      development:
        adapter: sqlite3
        database: #{DB_DEV}

      test:
        adapter: sqlite3
        database: #{DB_TEST}

      production:
        adapter: sqlite3
        database: #{DB_PROD}
    STR
  end

  def self.schemarb
    <<-STR
      ActiveRecord::Schema.define(version: 2026_07_02_013351) do
        create_table "widgets", force: :cascade do |t|
          t.string "name", null: false
          t.datetime "created_at", precision: 6, null: false
          t.datetime "updated_at", precision: 6, null: false
        end
      end
    STR
  end

  def self.seedsrb
    <<-STR
      Widget.create!(name: "Foo")
    STR
  end
end
