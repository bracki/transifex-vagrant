Feature: Lighttpd
  
  Scenario: Lighttpd should be up and running
    When I do a vagrant provision
    Then "lighttpd" should be running
