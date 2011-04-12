Then /^the Python package "([^"]*)" should be installed$/ do |pkg|
  When "I ssh to vagrantbox \"default\" with the following credentials:", table(%{
    | username | password|
    | vagrant  | vagrant | 
  })
  steps %Q{
    When I run "which #{pkg}" 
    Then I should see "/usr/local/bin/#{pkg}" in the output
  }
end

Then /^a virtualenv should be created at "([^"]*)"$/ do |path|
  When "I ssh to vagrantbox \"default\" with the following credentials:", table(%{
    | username | password|
    | vagrant  | vagrant | 
  })
  steps %Q{
    When I run "test -d #{path}"
    Then it should have exitcode 0
  }
end

Then /^these Python packages should be installed in "([^"]*)":$/ do |path, table|
  When "I ssh to vagrantbox \"default\" with the following credentials:", table(%{
    | username | password|
    | vagrant  | vagrant | 
  })
  steps %Q{
    When I run "#{path}/bin/pip freeze" 
  }
  packages = table.hashes
  packages.each do |pkg|
    @output.downcase.should include "#{pkg['package']}==#{pkg['version']}"
  end
end
