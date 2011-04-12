require 'vagrant/cli'
require 'vagrant'

require 'uri'

When /^I ssh to vagrantbox "([^\"]*)" with the following credentials:$/ do |boxname,table|
  unless @vagrant_env.multivm?
    port=@vagrant_env.primary_vm.ssh.port
  else
    port=@vagrant_env.vms[boxname.to_sym].ssh.port
  end
  hostname="127.0.0.1"
    @keys = []
    @auth_methods ||= %w(password)
    session = table.hashes.first
    session_keys = Array.new(@keys)
    session_auth_methods = Array.new(@auth_methods) 
    if session["keyfile"]
      session_keys << session["keyfile"]
      session_auth_methods << "publickey"
    end
    session_port=port 


    lambda {
      @connection = Net::SSH.start(hostname, session["username"], :password => session["password"], 
                                                                  :auth_methods => session_auth_methods,
                                                                  :port => session_port,
                                                                  :keys => session_keys)
  #                                                                :keys => session_keys,:verbose => :debug)
    }.should_not raise_error
  end
  
Given /^I have a vagrant project in "([^\"]*)"$/ do |path|
  @vagrant_env=Vagrant::Environment.new(:cwd => path)
  @vagrant_env.load!
end

And /^I do a vagrant provision$/ do 
  Vagrant::CLI.start(["provision"], :env => @vagrant_env)
end

Then /^"([^"]*)" should be running$/ do |service|
    When "I ssh to vagrantbox \"default\" with the following credentials:", table(%{
      | username | password|
      | vagrant  | vagrant | 
    })
    steps %Q{
    And I run "ps -ef |grep #{service}|grep -v grep" 
    Then I should see "#{service}" in the output
    And it should have exitcode 0
    And I should see "#{service}" on stdout
    And there should be no output on stderr
    }
end
