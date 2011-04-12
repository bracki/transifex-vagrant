class python {
    package {
        "build-essential": ensure => latest;
        "python": ensure => latest;
        "python-dev": ensure => latest;
        "python-setuptools": ensure => installed;
    }
    exec {"easy_install virtualenv":
        path => "/usr/local/bin:/usr/bin:/bin",
        #refreshonly => true,
        require => Package["python-setuptools"],
        #subscribe => Package["python-setuptools"],
    }
#    exec {"virtualenv /home/vagrant/virtualenv":
#        path => "/usr/local/bin:/usr/bin:/bin",
#        creates => "/home/vagrant/virtualenv",
#    }
}
