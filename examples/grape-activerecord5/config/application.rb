require './config/environment'
$:.unshift Config.root.join('lib')

# Connect to database
OTR::ActiveRecord.configure_from_file! Config.root.join('config', 'database.yml')

# Load application
[
  %w(app models ** *.rb),
  %w(app entities ** *.rb),
  %w(app routes v* *.rb),
  %w(app routes ** *.rb),
].each do |pattern|
  Dir.glob(Config.root.join(*pattern)).each { |file| require file }
end
