FROM ubuntu:20.04

LABEL maintainer="vo1@sanger.ac.uk" \
      version="1.0.0" \
      description="Base R 4.x.x"

MAINTAINER  Victoria Offord <vo1@sanger.ac.uk>

USER root

# Locale
ENV LC_ALL C
ENV LC_ALL C.UTF-8
ENV LANG C.UTF-8

# Prevent interactive options
ENV DEBIAN_FRONTEND=noninteractive

# Run initial system updates
RUN apt-get update && \
  apt-get install -yq --no-install-recommends lsb-release && \
  apt-get update && \
  apt-get install -qy --no-install-recommends \
  software-properties-common \
  dirmngr \
  apt-transport-https \
  update-manager-core \
  locales \
  hdf5-helpers \
  hdf5-tools \
  libhdf5-103 \
  libhdf5-cpp-103 \
  libhdf5-doc \
  libhdf5-java \
  libhdf5-jni \
  libhdf5-mpich-103 \
  libhdf5-openmpi-103 \
  unattended-upgrades && \
  unattended-upgrade -d -v && \
  apt-get remove -yq unattended-upgrades && \
  apt-get autoremove -yq

RUN sed -i 's/Prompt=lts/Prompt=normal/' /etc/update-manager/release-upgrades
RUN do-release-upgrade -d -f DistUpgradeViewNonInteractive

RUN apt-get purge r-base* r-recommended r-cran-*
RUN apt-get autoremove -yq
RUN apt-get update

RUN apt-get install -yq gpg-agent
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv 51716619E084DAB9
RUN add-apt-repository 'deb https://cloud.r-project.org/bin/linux/ubuntu focal-cran40/'
RUN apt-get update

RUN apt-get install -yq \
  libblas-dev \
  libcurl4 \
  libxml2 \
  libcairo2 \
  libssl1.1 \
  openssl \
  r-base \
  r-base-core \
  r-recommended \
  python3 \
  python3-distutils \
  python3-pip 

RUN pip3 install --upgrade pip

ENV OPT /opt/wsi-t113

ENV PATH $OPT/bin:$OPT/python3/bin:$PATH
ENV LD_LIBRARY_PATH $OPT/lib
ENV PYTHONPATH="/usr/src/app:${PYTHONPATH}"
ENV R_LIBS $OPT/R-lib
ENV R_LIBS_USER $R_LIBS

RUN mkdir -p $R_LIBS_USER

ADD build/* build/
RUN bash build/opt-build.sh $OPT
RUN bash build/install_R_packages.sh

ENV DISPLAY=:0

#Create some usefull symlinks
RUN cd /usr/local/bin && \
    ln -s /usr/bin/python3 python

# USER CONFIGURATION
RUN adduser --disabled-password --gecos '' ubuntu && chsh -s /bin/bash && mkdir -p /home/ubuntu

USER ubuntu
WORKDIR /home/ubuntu

CMD ["/bin/bash"]

