build:
	R CMD build imaginarycss

check:
	R CMD check --as-cran imaginarycss*tar.gz

clean:
	rm -rf imaginarycss*tar.gz ; \
	cd imaginarycss/src && rm -rf *.o *.so *.a