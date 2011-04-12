Feature: Python

  Scenario: Virtualenv should be installed
    When I do a vagrant provision
    Then the Python package "virtualenv" should be installed

  @wip
  Scenario: A virtualenv for deployment should be created
    When I do a vagrant provision
    Then a virtualenv should be created at "/home/vagrant/virtualenv"
