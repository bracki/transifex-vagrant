Feature: Python

  Scenario: Virtualenv should be installed
    When I do a vagrant provision
    Then the Python package "virtualenv" should be installed

  Scenario: A virtualenv for deployment should be created
    When I do a vagrant provision
    Then a virtualenv should be created at "/home/vagrant/virtualenv"

  @wip
  Scenario: All requirements should be installed
    When I do a vagrant provision
    Then these Python packages should be installed in "/home/vagrant/virtualenv":
      | package      | version |
      | django       | 1.2.3   |
      | gunicorn     | 0.12.1  |
      | contact-form | 0.3     |
