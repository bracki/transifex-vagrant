include python
include lighttpd

python::virtualenv {
    "/home/vagrant/virtualenv":
	python => "/usr/bin/python",
        packages => [
		"django==1.2.3", 
	        "gunicorn==0.12.1" ];
}
