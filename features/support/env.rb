require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end

#$LOAD_PATH.unshift(File.dirname(__FILE__) + '/../../lib')

# Disabling cuken until it gets less conflicting with other parts
# require 'cuken/ssh'
# require 'cuken/cmd'
# require 'cuken/file'
# require 'cuken/chef'

# We don't include all nagios steps only the http , but there are of-course more
# require 'cucumber/nagios/steps'
# Disable the following line if you want to use the extended ssh_steps
#require 'cucumber/nagios/steps/ssh_steps'
require 'cucumber/nagios/steps/http_steps'
require 'cucumber/nagios/steps/http_header_steps'
require 'rspec/expectations'
