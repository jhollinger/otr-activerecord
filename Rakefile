require 'bundler/setup'
require 'minitest/test_task'

Bundler::GemHelper.install_tasks

# Accepts files, dirs, N=test_name_or/pattern/, X=test_name_or/pattern/
Minitest::TestTask.create(:test) do |t|
  globs = ARGV[1..].map { |a|
    if Dir.exist? a
      "#{a}/**/*_test.rb"
    elsif File.exist? a
      a
    end
  }.compact

  t.libs << "test" << "lib"
  t.test_globs = globs.any? ? globs : ["test/**/*_test.rb"]
end
