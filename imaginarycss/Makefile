VERSION:=$(shell Rscript -e 'x<-readLines("DESCRIPTION");cat(gsub(".+[:]\\s*", "", x[grepl("^Vers", x)]))')
PKGNAME:=$(shell Rscript -e 'x<-readLines("DESCRIPTION");cat(gsub(".+[:]\\s*", "", x[grepl("^Package", x)]))')

.PHONY: build
${PKGNAME}_${VERSION}.tar.gz: R/* src/*.cpp inst/include/barry/** man
	$(MAKE) clean ;\
	       	Rscript -e 'Rcpp::compileAttributes();roxygen2::roxygenize()' && \
		R CMD build .	
build: ${PKGNAME}_${VERSION}.tar.gz

install: build
	R CMD INSTALL ${PKGNAME}_${VERSION}.tar.gz
check: build
	R CMD check --as-cran ${PKGNAME}_${VERSION}.tar.gz

# Once running, we can set a debug point using 'break [filename].hpp:[linenumber]
# and then type 'run'
debug:
	R -d gdb switch
profile: install
	R --debugger=valgrind --debugger-args='--tool=cachegrind --cachegrind-out-file=test.cache.out'

update:
	rsync -av ~/Documents/development/barry/include/barry inst/include

update-css:
	rsync -av ~/Documents/development/barry/include/barry/counters/network-css.hpp inst/include/barry/counters

.PHONY: man docker

man: R/* 
	Rscript --vanilla -e 'Rcpp::compileAttributes(verbose = TRUE)' & \
		Rscript --vanilla -e 'roxygen2::roxygenize()' 



.PHONY: clean
clean:
	rm -rf src/*.o; rm -rf src/*.a; rm -f ${PKGNAME}_${VERSION}.tar.gz
