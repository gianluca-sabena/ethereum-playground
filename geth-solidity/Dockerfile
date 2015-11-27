#
#   Docker for go ethereum with solidity compiler
#

FROM centos:centos7.1.1503

MAINTAINER https://github.com/gianluca-sabena

# --- --- ---  Update OS --- --- ---
RUN yum -y install epel-release; yum -y update
RUN yum -y install git tar gmp gmp-devel gcc make

# --- --- --- Install Go --- --- ---
RUN curl -fsSL https://storage.googleapis.com/golang/go1.5.1.linux-amd64.tar.gz| tar xzf - -C /usr/local
ENV GOPATH /opt/gocode
ENV PATH $PATH:/usr/local/go/bin:/opt/gocode/bin/

# --- --- --- Ethereum --- --- ---
RUN cd /opt && git clone https://github.com/ethereum/go-ethereum.git && cd go-ethereum && make all
RUN ln -s /opt/go-ethereum/build/bin/geth /usr/bin/geth

# --- --- --- Solidity compiler --- --- ---

# --- need last version of cmake ---
RUN curl -fsSL  https://cmake.org/files/v3.4/cmake-3.4.0-Linux-x86_64.sh -o /opt/cmake-install.sh && chmod u+x /opt/cmake-install.sh
RUN mkdir /opt/cmake  && /opt/cmake-install.sh --prefix=/opt/cmake --exclude-subdir
RUN ln -s /opt/cmake/bin/cmake /usr/bin/cmake

# --- need last version of boost ---
RUN curl -fsSL  http://sourceforge.net/projects/boost/files/boost/1.55.0/boost_1_55_0.tar.gz/download | tar xzf - -C /opt
RUN yum -y install gcc-c++
RUN cd /opt/boost_1_55_0 && ./bootstrap.sh && ./b2 --layout=tagged --with-thread --with-date_time --with-system --with-regex --with-chrono --with-filesystem --with-test --with-program_options --with-random
ENV BOOST_ROOT /opt/boost_1_55_0

# --- need libjson-rpc-cpp ---
RUN yum -y install libmicrohttpd-devel libcurl-devel jsoncpp-devel argtable-devel
RUN cd /opt && git clone https://github.com/cinemast/libjson-rpc-cpp
RUN cd /opt/libjson-rpc-cpp; git checkout tags/v0.4.2;
RUN mkdir -p /opt/libjson-rpc-cpp/build; cd /opt/libjson-rpc-cpp/build; cmake -DCOMPILE_TESTS=NO  .. && make; make install; ldconfig

# --- clone ethereum solidity compiler ---
RUN yum -y install jsoncpp-devel leveldb-devel cryptopp-devel llvm-devel
RUN cd /opt && git clone https://github.com/ethereum/webthree-helpers
RUN cd /opt && webthree-helpers/scripts/ethupdate.sh --no-push --simple-pull --project solidity
RUN sed -i -e 's/-Werror//g' /opt/webthree-helpers/cmake/EthCompilerSettings.cmake
RUN cd /opt && webthree-helpers/scripts/ethbuild.sh --no-git --cores 4 --project solidity -DEVMJIT=0 -DETHASHCL=0

# --- --- --- Start --- --- ---
RUN mkdir /opt/console-scripts
COPY console-scripts/* /opt/console-scripts/
COPY build/* /opt/
CMD /opt/start.sh