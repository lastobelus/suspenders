# Set up an APP_CONFIG[] hash from app_config.yml to allow easy configuration
# of custom settings for each app.

say "Creating custom app configuration hash ..."

initializer 'app_config.rb' do
<<-RUBY.gsub(/^ {2}/, '')
  # Load application-specific configuration from config/app_config.yml.
  # Access the config params via APP_CONFIG['param']
  APP_CONFIG = YAML.load_file("\#{Rails.root}/config/app_config.yml")
RUBY
end

file 'config/app_config.yml', <<-RUBY.gsub(/^ {2}/, '')
  # Application-specific global configuration settings.
RUBY