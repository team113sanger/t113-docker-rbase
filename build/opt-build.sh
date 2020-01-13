
#! /bin/bash

set -xe

if [[ -z "${TMPDIR}" ]]; then
  TMPDIR=/tmp
fi

set -u

if [ "$#" -lt "1" ] ; then
  echo "Please provide an installation path such as /opt/ICGC"
  exit 1
fi

# get path to this script
SCRIPT_PATH=`dirname $0`;
SCRIPT_PATH=`(cd $SCRIPT_PATH && pwd)`

# get the location to install to
INST_PATH=$1
mkdir -p $1
INST_PATH=`(cd $1 && pwd)`
echo $INST_PATH

# get current directory
INIT_DIR=`pwd`

CPU=`grep -c ^processor /proc/cpuinfo`
if [ $? -eq 0 ]; then
  if [ "$CPU" -gt "6" ]; then
    CPU=6
  fi
else
  CPU=1
fi
echo "Max compilation CPUs set to $CPU"

SETUP_DIR=$INIT_DIR/install_tmp
mkdir -p $SETUP_DIR/distro # don't delete the actual distro directory until the very end
mkdir -p $INST_PATH/bin
cd $SETUP_DIR

# make sure tools installed can see the install loc of libraries
set +u
export LD_LIBRARY_PATH=`echo $INST_PATH/lib:$LD_LIBRARY_PATH | perl -pe 's/:\$//;'`
export LIBRARY_PATH=`echo $INST_PATH/lib:$LIBRARY_PATH | perl -pe 's/:\$//;'`
export C_INCLUDE_PATH=`echo $INST_PATH/include:$C_INCLUDE_PATH | perl -pe 's/:\$//;'`
export PATH=`echo $INST_PATH/bin:$PATH | perl -pe 's/:\$//;'`
export MANPATH=`echo $INST_PATH/man:$INST_PATH/share/man:$MANPATH | perl -pe 's/:\$//;'`
export PERL5LIB=`echo $INST_PATH/lib/perl5:$PERL5LIB | perl -pe 's/:\$//;'`
set -u

# texlive
if [ ! -e $SETUP_DIR/texlive.success ]; then
  curl -sSL --retry 10 -o texlive.tar.gz http://ftp.fau.de/ctan/systems/texlive/tlnet/install-tl-unx.tar.gz
  mkdir texlive
  tar --strip-components 1 -C texlive -xzf texlive.tar.gz
  cd texlive
  ./install-tl --profile=/tmp/texlive.profile
  tlmgr install titling framed inconsolata xkeyval
  tlmgr install collection-fontsrecommended
  tlmgr option -- autobackup 0
  cd $SETUP_DIR
  rm -rf texlive.* texlive/*
  touch $SETUP_DIR/texlive.success
fi


# R
if [ ! -e $SETUP_DIR/R.success ]; then
  curl -sSL --retry 10 -o Rdnld.tar.gz https://cran.r-project.org/src/base/R-3/R-${VER_R}.tar.gz
  mkdir Rdnld
  tar --strip-components 1 -C Rdnld -xzf Rdnld.tar.gz
  cd Rdnld
  ./configure   --enable-R-shlib \
                --enable-memory-profiling \
                --with-readline \
                --with-blas \
                --with-tcltk \
                --disable-nls \
                --with-cairo \
                --with-recommended-packages \
		--prefix=$INST_PATH

  make -j4
  make install
  make install-libR
  pwd
#  make check

#  rm -rf Rdnld.* Rdnld/*
  touch $SETUP_DIR/R.success
fi
