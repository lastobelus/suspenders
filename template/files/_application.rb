# Update things in config/application.rb

say "Adding password_confirmation to filter_parameters ... "
gsub_file 'config/application.rb', /:password/, ':password, :password_confirmation'

say "Adding app/extras/ to autoload_paths ... "
gsub_file 'config/application.rb', /# config.autoload_paths/, 'config.autoload_paths'

say "Setting up log file rotation ..."
inject_into_file 'config/application.rb', :before => "  end\nend" do
  <<-RUBY

    # Rotate log files (50 files max at 1MB each)
    config.logger = Logger.new(config.paths.log.first, 50, 1048576)
  RUBY
end