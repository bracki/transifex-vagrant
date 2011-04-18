include python
include lighttpd

# Dependencies copied straight from Transifex's requirements.txt
python::virtualenv {
    "/home/vagrant/virtualenv":
	python => "/usr/bin/python",
	packages => [
		"Django==1.2.3",
		"Markdown==2.0.3",
		"PIL==1.1.7",
		"Pygments==1.3.1",
		"South==0.7.2",
		"django-addons==0.6",
		"django-ajax-selects==1.1.4",
		"django-authority==0.4",
		"django-filter==0.5.3",
		"django-notification==0.1.5",
		"django-pagination==1.0.7",
		"django-staticfiles==0.3.2",
		"django-tagging==0.3.1",
		"polib==0.5.5",
		"pygooglechart==0.3.0",
		"python-magic==0.3.1",
		"http://trac.transifex.org/files/deps/userprofile-0.7-r422-correct-validation.tar.gz",
		"http://trac.transifex.org/files/deps/django-piston-0.2.3-devel-r278.tar.gz",
		"http://trac.transifex.org/files/deps/django-sorting-0.1.tar.gz",
		"http://trac.transifex.org/files/deps/django-threadedcomments-0.9.tar.gz",
		"http://trac.transifex.org/files/deps/contact_form-0.3.tar.gz",
                "gunicorn==0.12.1",
	        ];
}
