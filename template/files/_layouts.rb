# Set up default haml layout

say "Creating default layout ..."

remove_file 'app/views/layouts/_footer.html.haml'
file 'app/views/layouts/_footer.html.haml', <<-HAML.gsub(/^ {2}/, '')
  .copyright
    %p Copyright &copy; #{Date.today.year}
HAML

remove_file 'app/views/layouts/_header.html.haml'
file 'app/views/layouts/_header.html.haml', <<-HAML.gsub(/^ {2}/, '')
  .title
    %h1 Header

  .logo
    %h1 Logo goes here
HAML

file 'app/views/layouts/_nav.html.haml', <<-HAML.gsub(/^ {2}/, '')
  .menu
    %p
      This is your navigation bar. Enjoy.

  .login-out
    - if signed_in?
      %p
        = link_to "Sign out", sign_out_path, :method => :delete
    - else
      %p
        = link_to "Sign in", sign_in_path
HAML

# This needs to be kept up to date as the boilerplate and sporkd gem get updated
remove_file 'app/views/layouts/application.html.haml'
remove_file 'app/views/layouts/application.html.erb'
file 'app/views/layouts/application.html.haml', <<-HAML.gsub(/^ {2}/, '')
  !!! 5
  -# http://paulirish.com/2008/conditional-stylesheets-vs-css-hacks-answer-neither
  -ie_html :lang => 'en', :class => 'no-js' do
    = render :partial => 'layouts/head'
    %body{ :class => "\#{controller.controller_name}" }
      #container
        %header#header
          .row
            = render :partial => 'layouts/header'
        %nav#nav
          .row
            = render :partial => 'layouts/nav'
        #main
          .row
            = render :partial => 'layouts/flashes'
          -# You MUST enclose your yielded content in at least one .row
          = yield
        %footer#footer
          .row
            = render :partial => 'layouts/footer'
      -# Javascript at the bottom for fast page loading
      = render :partial => 'layouts/javascripts'
HAML