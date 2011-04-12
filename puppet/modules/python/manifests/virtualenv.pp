# Handle installing Python virtualenvs containing Python packages.
# https://wiki.mozilla.org/ReleaseEngineering/How_To/Install_a_Python_Virtualenv_with_Puppet
#
# EXAMPLES:
#
#   python::virtualenv {
#       "/path/to/virtualenv":
#           python => "/path/to/python",
#           packages => [ "package==version", "mock==0.6.0",
#                         "buildbot==0.8.0" ];
#   }
#
# or, to remove a virtualenv,
#
#   python::virtualenv {
#       "/path/to/virtualenv":
#           ensure => absent;
#   }
#
# NOTES
#
# Specify the packages using the pypi "==" notation; do NOT use any other operator,
# e.g., "=>" or an unqualified package name.
#
# An appropriate package file for the system must be available in the python
# package directory.  For pure-python packages, this can be an sdist tarball or
# zip; for packages that include some compiled source (e.g., Twisted), this
# will need to be a binary distribution, customized for the particular Python
# version and platform.
#
# On the masters, the package directory is at
#  /N/staging/python-packages
#  /N/production/python-packages
#  /builds/production/python-packages
# depending on the master.
#
# DEPENDENCIES
#
# - The global $level variable, which should be factored out
# - various Python installation stuff elsewhere in the manifests (see $virtualenv_reqs)
#
# TODO:
#  - use regsubst() to qualify python::package names so that the same package can
#    be installed in multiple virtualenvs (see commented-out stuff below)


# Install a virtualenv, based on a particular Python, and containing
# a particular set of packages.
#
# Package dependencies are not followed - list *all* required packages in the
# packages parameter.  Note that this cannot uninstall packages, although it
# can be used to upgrade/downgrade packages (as pip will automatically
# uninstall the previous version)
#
# title: virtualenv directory
# python: python executable on which to base the virtualenv
# ensure: present or absent
# packages: array of package names and versions to install
define python::virtualenv($python, $ensure="present", $packages) {

    $virtualenv = $title

    # calculate the set of stuff that has to be up before we can run a
    # virtualenv; this varies per platform.  Puppet does not support any kind of
    # append or concatenation on arrays (at least, not without lots of gymnastics
    # involving extra classes), so we put these common resources in variables
    # for brevity
    #$virtualenv_dir_req = File["$virtualenv"]

    $virtualenv_reqs = [
        Exec["easy_install virtualenv"],
    ]

    case $ensure {
        present: {

            exec {
                "virtualenv $virtualenv":
	            path => "/usr/local/bin:/usr/bin:/bin",
                    logoutput => on_failure,
                    require => $virtualenv_reqs,
                    creates => "$virtualenv/bin/pip";
            }

            # TODO: requires regsubst, which is not in 0.24.8:
#            # now install each package; we use regsubst to qualify the resource name
#            # with the virtualenv; a similar regsubst will be used in the python::package
#            # define to separate these two values
#            $qualified_packages = regsubst($packages, "^", "$virtualenv||")
#            python::package { $qualified_packages: }
            python::package {
                $packages: 
                    virtualenv => $virtualenv;
            }
        }

        absent: {
            # absent? that's easy - blow away the directory
            file {
                "$virtualenv":
                    ensure => absent,
                    backup => false,
                    force => true;
            }
        }
    }
}

# (private)
#
# Install the given Python package into the given virtualenv.
define python::package($virtualenv) { # TODO: extract $virtualenv from $title (see above)

    # TODO: requires regsubst, which is not in 0.24.8:
#    # extract the virtualenv and tarball from the title
#    $virtualenv = regsubst($title, "\|\|.*$", "")
#    $pkg = regsubst($title, "^.*\|\|", "")
    $pkg = $title


    exec {
        # point pip at the package directory so that it can select the best option
        "pip-$virtualenv||$pkg":
            name => "$virtualenv/bin/pip install \
                    $pkg",
            logoutput => on_failure,
            require => [
                Exec["virtualenv $virtualenv"],
            ];
    }
}
