# otr-activerecord

An easy way to use ActiveRecord "off the rails." Works with Grape, Sinatra, plain old Rack, or even in a boring little script!. The defaults are all very Railsy (`config/database.yml`, `db/seeds.rb`, `db/migrate`, etc.), but you can easily change them. (Formerly known as `grape-activerecord`.) Supports:

* ActiveRecord 6
* ActiveRecord 5
* ActiveRecord 4

## How to use

#### 1. Add it to your Gemfile

    gem "otr-activerecord"

#### 2. Configure your database connection

After loading your gems, tell `OTR::ActiveRecord` about your database config using one of the following examples:

    OTR::ActiveRecord.configure_from_file! "config/database.yml"
    OTR::ActiveRecord.configure_from_url! ENV['DATABASE_URL'] # e.g. postgres://user:pass@host/db
    OTR::ActiveRecord.configure_from_hash!(adapter: "postgresql", host: "localhost", database: "db", username: "user", password: "pass", encoding: "utf8", pool: 10, timeout: 5000)

**Important note**: `configure_from_file!` won't work as expected if you have already `DATABASE_URL` set as part of your environment variables.
This is because in ActiveRecord when that env variable is set it will merge its properties into the current connection configuration.

#### 3. Enable middleware for Rack apps

Add these middlewares in `config.ru`:

    # Clean up database connections after every request (required)
    use OTR::ActiveRecord::ConnectionManagement

    # Enable ActiveRecord's QueryCache for every request (optional)
    use OTR::ActiveRecord::QueryCache

#### 4. Import ActiveRecord tasks into your Rakefile

This will give you most of the standard `db:` tasks you get in Rails. Add it to your `Rakefile`.

    require "bundler/setup"
    load "tasks/otr-activerecord.rake"

    namespace :db do
      # Some db tasks require your app code to be loaded; they'll expect to find it here
      task :environment do
        require_relative "app"
      end
    end

Unlike in Rails, creating a new migration is also a rake task. Run `bundle exec rake -T` to get a full list of tasks.

    bundle exec rake db:create_migration[create_widgets]

## Examples

Look under [/examples](https://github.com/jhollinger/otr-activerecord/tree/master/examples) for some example apps.

## Advanced options

The defaults for db-related files like migrations, seeds, and fixtures are the same as Rails. If you want to override them, use the following options in your `Rakefile`:

    OTR::ActiveRecord.db_dir = 'db'
    OTR::ActiveRecord.migrations_paths = ['db/migrate']
    OTR::ActiveRecord.fixtures_path = 'test/fixtures'
    OTR::ActiveRecord.seed_file = 'seeds.rb'

## License

Licensed under the MIT License

Copyright 2016 Jordan Hollinger
