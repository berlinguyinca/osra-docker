FROM openjdk:8
MAINTAINER Gert wohlgemuth <wohlgemuth@ucdavis.edu>

#installing build tools
RUN \
	apt-get update && \
	apt-get install -y build-essential automake checkinstall git cmake

#fetching source codes
RUN \
	cd /tmp && \
  git clone https://github.com/metamolecular/gocr-patched.git && \
	git clone https://github.com/openbabel/openbabel.git && \
	git clone https://github.com/metamolecular/osra.git

#installing dependencies for osra
RUN \
	apt-get install -y libtclap-dev libpotrace0  libpotrace-dev  libocrad-dev libgraphicsmagick++1-dev libgraphicsmagick++1-dev libgraphicsmagick++3 libgraphicsmagick1-dev libgraphicsmagick3 libnetpbm10-dev libpoppler-dev libpoppler-cpp-dev

#patching gocr
RUN \
	cd /tmp/gocr-patched && \
	./configure && \
	make libs && \
	make all install

#installing openbabel and its dependencies
RUN \
	apt-get  install -y libeigen3-dev

RUN \
		cd /tmp/openbabel && \
		git checkout openbabel-2-3-2 && \
		mkdir build && \
    cd build && \
		cmake .. && \
		make && \
		make install

#installing osra
RUN \
	cd /tmp/osra && \
	./configure  --with-openbabel-include=/usr/local/include/openbabel-2.0 --with-openbabel-lib=/usr/local/lib/openbabel && \
	make all && \
	make install && \
	echo export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib >> ~/.bashrc

#cleanup
RUN rm -rf /var/lib/apt/lists/*

CMD ["bash"]
