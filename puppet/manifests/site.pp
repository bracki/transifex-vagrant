include python
include lighttpd

python::virtualenv {
    "/home/vagrant/virtualenv":
	python => "/usr/bin/python",
        packages => [
		"django==1.2.3", 
                "http://trac.transifex.org/files/deps/contact_form-0.3.tar.gz",
	        "gunicorn==0.12.1" ];
}
