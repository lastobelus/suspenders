# Suspenders
# =============
# by thoughtbot

require 'net/http'
require 'net/https'
require 'date'
template_root = File.expand_path(File.join(File.dirname(__FILE__)))
source_paths << File.join(template_root, "files")

db_password = ask("do you have a database password?")
puts "db_password: #{db_password.inspect}"
# Helpers

def concat_file(source, destination)
  contents = IO.read(find_in_source_paths(source))
  append_file destination, contents
end

def replace_in_file(relative_path, find, replace)
  path = File.join(destination_root, relative_path)
  contents = IO.read(path)
  unless contents.gsub!(find, replace)
    raise "#{find.inspect} not found in #{relative_path}"
  end
  File.open(path, "w") { |file| file.write(contents) }
end

def action_mailer_host(rails_env, host)
  inject_into_file(
    "config/environments/#{rails_env}.rb",
    "\n\n  config.action_mailer.default_url_options = { :host => '#{host}' }",
    :before => "\nend"
  )
end

def download_file(uri_string, destination)
  uri = URI.parse(uri_string)
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true if uri_string =~ /^https/
  request = Net::HTTP::Get.new(uri.path)
  contents = http.request(request).body
  path = File.join(destination_root, destination)
  File.open(path, "w") { |file| file.write(contents) }
end

def origin
  "git://github.com/lastobelus/suspenders.git"
end

def trout(destination_path)
  run "trout checkout --source-root=template/trout #{destination_path} #{origin}"
end

say "initializing git repo..."
git :init
git :add    => '.'
git :commit => '-a -m "fresh rails app"'

say "Getting rid of files we don't use"

remove_file "README"
remove_file "public/index.html"
remove_file "public/images/rails.png"

say "Setting up the staging environment"

run "cp config/environments/production.rb config/environments/staging.rb"

say "Creating suspenders views"

empty_directory "app/views/shared"
copy_file "_flashes.html.erb", "app/views/shared/_flashes.html.erb"
copy_file "_javascript.html.erb", "app/views/shared/_javascript.html.erb"
template "suspenders_layout.html.erb.erb",
         "app/views/layouts/application.html.erb",
         :force => true

say "Let's use jQuery"

%w(jquery jquery-ui).each do |file|
  trout "public/javascripts/#{file}.js"
end

download_file "https://github.com/rails/jquery-ujs/raw/master/src/rails.js",
          "public/javascripts/rails.js"

say "Pulling in some common javascripts"

trout "public/javascripts/prefilled_input.js"

say "Documentation"

copy_file "README_FOR_SUSPENDERS", "doc/README_FOR_SUSPENDERS"

say "Get ready for bundler... (this will take a while)"

trout 'Gemfile'
run "bundle install"

say "Let's use MySQL"

template "mysql_database.yml.erb", "config/database.yml", :force => true
rake "db:create:all"
# for some reason the above line is not working, but if I pause and go to the project and run it by hand it does.
yes? "is the database there?"

# stuff from https://github.com/greendog99/greendog-rails-template
say "use compass/html-5-boilerplate"
apply "_boilerplate.rb"
say "use 960 grid"
apply "_grid.rb"          # Must be after boilerplate since it modifies SASS files
apply "_stylesheets.rb"
apply "_layouts.rb"
apply "_helpers.rb"
apply "_application.rb"
apply "_appconfig.rb"
apply "_demo.rb"

say "Setting up plugins"
plugin 'showoff', :git => "git://github.com/adamlogic/showoff.git"
plugin 'alter_table', :git => "git://github.com/xing/alter_table.git"
plugin 'rails_indexes', :git => "git://github.com/eladmeidar/rails_indexes.git"
plugin 'abingo', :git => "git://git.bingocardcreator.com/abingo.git"


generators_config = <<-RUBY
    config.generators do |generate|
      generate.test_framework :rspec
    end
RUBY

inject_into_class "config/application.rb", "Application", generators_config

action_mailer_host "development", "#{app_name}.local"
action_mailer_host "test",        "example.com"
action_mailer_host "staging",     "staging.#{app_name}.com"
action_mailer_host "production",  "#{app_name}.com"

generate "rspec:install"
generate "cucumber:install", "--rspec --capybara"
generate "clearance"
generate "clearance_features"

create_file "public/stylesheets/sass/screen.scss"
create_file "public/stylesheets/screen.css"

copy_file "factory_girl_steps.rb", "features/step_definitions/factory_girl_steps.rb"
copy_file "cucumber.yml", "config/cucumber.yml"

# replace_in_file "spec/spec_helper.rb", "mock_with :rspec", "mock_with :mocha"
# replace_in_file "spec/spec_helper.rb", "require 'rspec/rails'", "require 'rspec/rails'\nrequire 'remarkable/active_record'"
copy_file "spec_helper.rb", "spec/spec_helper.rb"


# inject_into_file "features/support/env.rb",
#                  %{Capybara.save_and_open_page_path = 'tmp'\n} +
#                  %{Capybara.javascript_driver = :akephalos\n},
#                  :before => %{Capybara.default_selector = :css}
# replace_in_file "features/support/env.rb",
#                 %r{require .*capybara_javascript_emulation.*},
#                 ''
copy_file "cucumber_env.rb", "features/support/env.rb"

rake "flutie:install"

say "Ignore the right files"

concat_file "suspenders_gitignore", ".gitignore"
empty_directory_with_gitkeep "app/models"
empty_directory_with_gitkeep "app/views/pages"
empty_directory_with_gitkeep "db/migrate"
empty_directory_with_gitkeep "log"
empty_directory_with_gitkeep "public/images"
empty_directory_with_gitkeep "spec/support"

say "Copying miscellaneous support files"

copy_file "errors.rb", "config/initializers/errors.rb"
copy_file "time_formats.rb", "config/initializers/time_formats.rb"
copy_file "body_class_helper.rb", "app/helpers/body_class_helper.rb"

say "Setting up a root route"

route "root :to => 'Clearance::Sessions#new'"

rake "db:migrate"

git :add => '--all'
git :commit => '-a -m "applied application template"'

say "Congratulations! You just pulled our suspenders."
say "Remember to run 'rails generate hoptoad' with your API key."

