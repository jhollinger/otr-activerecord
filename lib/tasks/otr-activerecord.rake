require 'pathname'
require 'fileutils'
require 'active_support/core_ext/string/strip'
require 'active_support/core_ext/string/inflections'
require 'otr-activerecord'
load 'active_record/railties/databases.rake'

#
# Configure and override the default activerecord db rake tasks
#

Rake::Task.define_task('db:_load_config') do
  ::ActiveRecord::Base.logger = nil
  ::ActiveRecord::Tasks::DatabaseTasks.tap do |config|
    config.root = Rake.application.original_dir
    config.env = OTR::ActiveRecord.rack_env.to_s
    config.db_dir = OTR::ActiveRecord.db_dir
    config.migrations_paths = Array(OTR::ActiveRecord.migrations_paths)
    config.fixtures_path = OTR::ActiveRecord.fixtures_path
    config.database_configuration = ::ActiveRecord::Base.configurations
    config.seed_loader = Object.new
    config.seed_loader.instance_eval do
      def load_seed
        load "#{OTR::ActiveRecord.db_dir}/#{OTR::ActiveRecord.seed_file}"
      end
    end
  end
end

Rake::Task['db:load_config'].clear
Rake::Task.define_task('db:load_config') do
  # Run the user's db:environment task first, so they have an opportunity to set a custom db config location
  Rake::Task['db:environment'].invoke
end

Rake::Task.define_task('db:environment') do
  # defined by user
end

# Load db config at the end of user-defined db:environment
Rake::Task['db:environment'].enhance do
  Rake::Task['db:_load_config'].invoke
end

Rake::Task['db:test:deprecated'].clear if Rake::Task.task_defined?('db:test:deprecated')

#
# Define otr-activerecord helper tasks
#

namespace :db do
  namespace :test do
    task :environment do
      ENV['RACK_ENV'] = 'test'
    end
  end

  desc "Create a migration (parameters: NAME, VERSION)"
  task :create_migration do
    unless ENV["NAME"]
      puts "No NAME specified. Example usage: `rake db:create_migration NAME=create_widgets`"
      exit 1
    end

    name = ENV["NAME"]
    version = ENV["VERSION"] || Time.now.utc.strftime("%Y%m%d%H%M%S")

    OTR::ActiveRecord._normalizer.migrations_paths.each do |directory|
      next unless File.exists?(directory)
      migration_files = Pathname(directory).children
      if duplicate = migration_files.find { |path| path.basename.to_s.include?(name) }
        puts "Another migration is already named \"#{name}\": #{duplicate}."
        exit 1
      end
    end

    filename = "#{version}_#{name}.rb"
    dirname = OTR::ActiveRecord._normalizer.migrations_path
    path = File.join(dirname, filename)

    FileUtils.mkdir_p(dirname)
    File.write path, <<-MIGRATION.strip_heredoc
      class #{name.camelize} < #{OTR::ActiveRecord._normalizer.migration_base_class_name}
        def change
        end
      end
    MIGRATION

    puts path
  end
end
