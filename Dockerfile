FROM ubuntu:18.04 as builder

USER root

# Locale
ENV LC_ALL C
ENV LC_ALL C.UTF-8
ENV LANG C.UTF-8

# ALL tool versions used by opt-build.sh
ENV VER_R="3.6.0"

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get -yq update

RUN apt-get install -yq \
  build-essential \
  gfortran \
  perl \
  curl \
  less \
  tar \
  unzip \
  zip \
  g++ \
  gawk 

RUN apt-get -yq update

RUN apt-get install -yq software-properties-common
RUN add-apt-repository ppa:mozillateam/firefox-next

RUN apt-get install -yq \
  default-jre \
  default-jdk \
  firefox \
  okular

# R-specific libraries
RUN apt-get install -yq \
  libreadline-dev \
  libx11-dev \
  libxt-dev \
  zlib1g-dev \
  libbz2-dev \
  liblzma-dev \
  libpcre3-dev \
  libcurl4-openssl-dev \
  libcairo2-dev \
  libjpeg-dev \
  libpango1.0-dev \
  libpangocairo-1.0-0 \
  libpaper-utils \
  libpng-dev \
  libtiff-dev \
  texinfo \
  libbison-dev \
  byacc \
  libblas-dev \
  tcl-dev \ 
  tk-dev

ENV OPT /opt/wsi-t113
ENV PATH $OPT/bin:$OPT/texlive/2019/bin/x86_64-linux:$PATH
ENV LD_LIBRARY_PATH $OPT/lib

RUN curl -L http://cpanmin.us | perl - App::cpanminus 
RUN cpanm Pod::Usage

ADD build/opt-build.sh build/
ADD build/texlive.profile /tmp/
RUN bash build/opt-build.sh $OPT

RUN Rscript -e "install.packages(pkgs = c('devtools', 'tidyverse', 'argparse', 'pheatmap', 'optparse', 'viridis', 'extrafont', 'rdgal'), repos='https://www.stats.bris.ac.uk/R/', dependencies=TRUE, clean = TRUE)"

FROM ubuntu:18.04 

LABEL maintainer="vo1@sanger.ac.uk" \
      version="1.0.0" \
      description="R-base container"

MAINTAINER  Victoria Offord <vo1@sanger.ac.uk>

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get -yq update
RUN apt-get install -yq --no-install-recommends \
  curl \
  less \
  tar \
  unzip \
  zip \
  firefox \
  okular \
  default-jre \
  xorg \
  openbox \
  tcl \
  tk \
  libblas3 \
  gfortran \
  g++

ENV OPT /opt/wsi-t113
ENV PATH $OPT/bin:$OPT/python3/bin:$OPT/texlive/2019/bin/x86_64-linux:$PATH
ENV LD_LIBRARY_PATH $OPT/lib

ENV LC_ALL C
ENV LC_ALL C.UTF-8
ENV LANG C.UTF-8
ENV DISPLAY=:0

RUN mkdir -p $OPT
COPY --from=builder $OPT $OPT

RUN find / -name *tclConfig* > /tmp/tcl.all

# USER CONFIGURATION
RUN adduser --disabled-password --gecos '' ubuntu && chsh -s /bin/bash && mkdir -p /home/ubuntu

USER ubuntu
WORKDIR /home/ubuntu

CMD ["/bin/bash"]
