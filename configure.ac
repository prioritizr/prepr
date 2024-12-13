dnl Process this file with autoconf to produce a configure script.
dnl GDAL stuff largely copied from sf, (c) Edzer Pebesma
AC_PREREQ([2.69])
AC_INIT([prepr], [see.DESCRIPTION], [https://github.com/dickoa/prepr/issues])
AC_CONFIG_SRCDIR([src/prepr.cpp])

# Preliminary processing
## print status message
AC_MSG_CHECKING([if R found])
## ensure C++ is set up as R expects
: ${R_HOME=`R RHOME`}
if test -z "${R_HOME}"; then
  AC_MSG_RESULT([no])
  AC_MSG_ERROR([Could not determine R_HOME.])
fi
AC_MSG_RESULT([yes])

## verify suitable R version
RBIN="${R_HOME}/bin/R"
RSCRIPT="${R_HOME}/bin/Rscript"
RVER=`"${RSCRIPT}" -e 'writeLines(paste(sep=".", base::version$major, base::version$minor))'`
RVER_MAJOR=`echo ${RVER} | cut  -f1 -d"."`
RVER_MINOR=`echo ${RVER} | cut  -f2 -d"."`
RVER_PATCH=`echo ${RVER} | cut  -f3 -d"."`

if test [$RVER_MAJOR = "development"]; then
  AC_MSG_NOTICE([R version: development])
  CPP11=`"${RBIN}" CMD config CPP11`
  CPP11STD=`"${RBIN}" CMD config CPP11STD`
else
  AC_MSG_NOTICE([R version: ${RVER_MAJOR}.${RVER_MINOR}.${RVER_PATCH}])
  if test [$RVER_MAJOR -lt 4]; then
      AC_MSG_ERROR([prepr is not compatible with R versions before 4.0.0])
  else
    CPP11=`"${RBIN}" CMD config CPP11`
    CPP11STD=`"${RBIN}" CMD config CPP11STD`
  fi
fi

## pick all flags for testing from R
: ${CC=`"${RBIN}" CMD config CC`}
: ${CPP=${CPP17} ${CPP17STD}}
: ${CFLAGS=`"${RBIN}" CMD config CFLAGS`}
: ${CPPFLAGS=`"${RBIN}" CMD config CPPFLAGS`}
: ${LDFLAGS=`"${RBIN}" CMD config LDFLAGS`}
AC_MSG_NOTICE([CC: ${CC}])
AC_MSG_NOTICE([CPP: ${CPP}])
AC_MSG_NOTICE([CFLAGS: ${CFLAGS}])
AC_MSG_NOTICE([CPPFLAGS: ${CPPFLAGS}])
AC_MSG_NOTICE([LDFLAGS: ${LDFLAGS}])

# GDAL configuration
## set variables
GDAL_CONFIG="gdal-config"
GDAL_CONFIG_SET="no"

## find package
AC_ARG_WITH(
  [gdal-config],
  AS_HELP_STRING(
    [--with-gdal-config=GDAL_CONFIG],
    [the location of gdal-config]
  ),
  [gdal_config=$withval]
)
AC_ARG_WITH(
  [gdal-config],
  AS_HELP_STRING(
    [--with-gdal-config=GDAL_CONFIG],
    [the location of gdal-config]
  ),
  [gdal_config=$withval]
)
if test [ -n "$gdal_config" ]; then
  GDAL_CONFIG_SET="yes"
  AC_SUBST([GDAL_CONFIG],["${gdal_config}"])
  AC_MSG_NOTICE(gdal-config set to $GDAL_CONFIG)
fi

if test ["$GDAL_CONFIG_SET" = "no"]; then
  AC_PATH_PROG([GDAL_CONFIG], ["$GDAL_CONFIG"],["no"])
  if test ["$GDAL_CONFIG" = "no"] ; then
    AC_MSG_RESULT(no)
    AC_MSG_ERROR([gdal-config not found or not executable.])
  fi
else
  AC_MSG_CHECKING(gdal-config exists)
  if test -r "${GDAL_CONFIG}"; then
    AC_MSG_RESULT(yes)
  else
    AC_MSG_RESULT(no)
    AC_MSG_ERROR([gdal-config not found - configure argument error.])
  fi
  AC_MSG_CHECKING(gdal-config executable)
  if test -x "${GDAL_CONFIG}"; then
    AC_MSG_RESULT(yes)
  else
    AC_MSG_RESULT(no)
    AC_MSG_ERROR([gdal-config not executable.])
  fi
fi

## find compilation flags
AC_MSG_CHECKING(gdal-config usability)
if test `${GDAL_CONFIG} --version`; then
  GDAL_CPPFLAGS=`${GDAL_CONFIG} --cflags`
  GDAL_VERSION=`${GDAL_CONFIG} --version`
  GDAL_LIBS=`${GDAL_CONFIG} --libs`
  GDAL_DEP_LIBS=`${GDAL_CONFIG} --dep-libs`
  GDAL_DATADIR=`${GDAL_CONFIG} --datadir`
  AC_MSG_RESULT(yes)
else
  AC_MSG_RESULT(no)
  echo "Error: gdal-config not found"
  echo "The gdal-config script distributed with GDAL could not be found."
  echo "If you have not installed the GDAL libraries, you can"
  echo "download the source from http://www.gdal.org/"
  echo "If you have installed the GDAL libraries, then make sure that"
  echo "gdal-config is in your path. Try typing gdal-config at a"
  echo "shell prompt and see if it runs. If not, use:"
  echo " --configure-args='--with-gdal-config=/usr/local/bin/gdal-config'"
  echo "with appropriate values for your installation."
  echo ""
  exit 1
fi

## verify version compatibility
AC_MSG_NOTICE([GDAL: ${GDAL_VERSION}])
AC_MSG_CHECKING([GDAL version >= 2.0.1])

GDAL_MAJ_VER=`echo $GDAL_VERSION | cut -d "." -f1`
if test ${GDAL_MAJ_VER} -lt 2 ; then
  AC_MSG_RESULT(no)
  AC_MSG_ERROR([prepr is not compatible with GDAL versions below 2.0.1])
else
   AC_MSG_RESULT(yes)
fi

# CGAL configuration
## manually specify compilation flags
CGAL_CPPFLAGS="-O3 -DNDEBUG -frounding-math -DCGAL_USE_GMPXX=1"

# GMP/MPFR configuration
## set GMP variables
GMP_NAME="gmp"
GMP_CONFIG_NAME="gmpxx"
GMP_DEB_NAME="libgmp3-dev"
GMP_RPM_NAME="gmp-devel"
GMP_CSW_NAME=""
GMP_BREW_NAME="gmp"
GMP_TEST_C_HEADER="<gmp.h>"
GMP_TEST_CPP_HEADER="<gmpxx.h>"

## set MFRP variables
MPFR_NAME="mpfr"
MPFR_CONFIG_NAME="mpfr"
MPFR_DEB_NAME="libmpfr-dev"
MPFR_RPM_NAME="mpfr-devel"
MPFR_CSW_NAME=""
MPFR_BREW_NAME="mpfr"
MPFR_TEST_HEADER="<mpfr.h>"


## set up pkgconfig
AC_DEFUN([AC_PROG_PKGCONFIG], [AC_CHECK_PROG(PKGCONFIG,pkg-config,yes)])
AC_PROG_PKGCONFIG

## specify flags and library paths
if test ["$PKGCONFIG" = "yes"]; then
  ### GMP settings
  if pkg-config --exists ${GMP_CONFIG_NAME}; then
    GMP_CFLAGS=`pkg-config --cflags --silence-errors ${GMP_CONFIG_NAME}`
    GMP_LIBS=`pkg-config --libs --silence-errors ${GMP_CONFIG_NAME}`
  else
    GMP_CFLAGS=""
    GMP_LIBS="-lgmpxx -lgmp"
  fi
  ### MPFR settings
  if pkg-config --exists ${MPFR_CONFIG_NAME}; then
    MPFR_CFLAGS=`pkg-config --cflags --silence-errors ${MPFR_CONFIG_NAME}`
    MPFR_LIBS=`pkg-config --libs --silence-errors ${MPFR_CONFIG_NAME}`
  else
    MPFR_CFLAGS=""
    MPFR_LIBS="-lmpfr -lgmp  -lpthread"
  fi
else
  ## manually specify defaults if pkg-config missing
  GMP_CFLAGS=""
  GMP_LIBS="-lgmpxx -lgmp"
  MPFR_CFLAGS=""
  MPFR_LIBS="-lmpfr -lgmp -lpthread"
fi

## display compilation flags
AC_MSG_NOTICE([GMP_CFLAGS: ${GMP_CFLAGS}])
AC_MSG_NOTICE([GMP_LIBS: ${GMP_LIBS}])
AC_MSG_NOTICE([MPFR_CFLAGS: ${MPFR_CFLAGS}])
AC_MSG_NOTICE([MPFR_LIBS: ${MPFR_LIBS}])

# Verify GMP settings work
## display message
AC_MSG_CHECKING([if ${GMP_NAME} compiles])

## try compiling file with settings
[cat > gmp_test.cpp <<_EOCONF
#include ${GMP_TEST_C_HEADER}
#include ${GMP_TEST_CPP_HEADER}
#if defined(__GNU_MP_VERSION)
#define SUCCESS 0
#else
#define SUCCESS 1
#endif
int main() {
  return SUCCESS;
}
_EOCONF]
${CXX} ${CPPFLAGS} ${GMP_CFLAGS} -o gmp_test gmp_test.cpp ${LIBS} 2> errors.txt
if test `echo $?` -ne 0 ; then
  gmp_ok=no
  AC_MSG_RESULT([no])
else
  gmp_ok=yes
  AC_MSG_RESULT([yes])
fi

## throw error if needed
if test x"${gmp_ok}" == x"no"; then
  AC_MSG_NOTICE([Configuration failed because ${GMP_NAME} was not found. Try installing:])
  AC_MSG_NOTICE([  * deb:  ${GMP_DEB_NAME} (Debian, Ubuntu)])
  AC_MSG_NOTICE([  * rpm:  ${GMP_RPM_NAME} (Fedora, EPEL)])
  AC_MSG_NOTICE([  * brew: ${GMP_BREW_NAME} (Mac OSX)])
  AC_MSG_NOTICE([])
  AC_MSG_NOTICE([If ${GMP_NAME} is already installed, check that 'pkg-config' is in])
  AC_MSG_NOTICE([your PATH and PKG_CONFIG_PATH contains a ${GMP_CONFIG_NAME}.pc file.])
  AC_MSG_NOTICE([])
  AC_MSG_ERROR([ERROR: Installation failed])
fi

## clean up
rm -f gmp_test errors.txt gmp_test.cpp

# Verify MPFR settings work
## display message
AC_MSG_CHECKING([if ${MPFR_NAME} compiles])

## try compiling file with settings
[cat > mpfr_test.cpp <<_EOCONF
#include ${MPFR_TEST_HEADER}
#if defined(MPFR_VERSION_MAJOR)
#define SUCCESS 0
#else
#define SUCCESS 1
#endif
int main() {
  return SUCCESS;
}
_EOCONF]
${CXX} ${CPPFLAGS} ${GMP_CFLAGS} ${MPFR_CFLAGS} -o mpfr_test mpfr_test.cpp ${LIBS} 2> errors.txt
if test `echo $?` -ne 0 ; then
  mpfr_ok=no
  AC_MSG_RESULT([no])
else
  mpfr_ok=yes
  AC_MSG_RESULT([yes])
fi

## throw error if needed
if test ["$mpfr_ok" = "no"]; then
  AC_MSG_NOTICE([Configuration failed because ${MPFR_NAME} was not found. Try installing:])
  AC_MSG_NOTICE([  * deb:  ${MPFR_DEB_NAME} (Debian, Ubuntu)])
  AC_MSG_NOTICE([  * rpm:  ${MPFR_RPM_NAME} (Fedora, EPEL)])
  AC_MSG_NOTICE([  * brew: ${MPFR_BREW_NAME} (Mac OSX)])
  AC_MSG_NOTICE([])
  AC_MSG_NOTICE([If ${MPFR_NAME} is already installed, check that 'pkg-config' is in])
  AC_MSG_NOTICE([your PATH and PKG_CONFIG_PATH contains a ${MPFR_CONFIG_NAME}.pc file.])
  AC_MSG_NOTICE([])
  AC_MSG_ERROR([ERROR: Installation failed])
fi

## clean up
rm -f mpfr_test errors.txt mpfr_test.cpp

# Export settings
## store all compilations flags
PKG_CPPFLAGS="${CPPFLAGS} ${GDAL_CPPFLAGS} ${CGAL_CPPFLAGS} ${GMP_CFLAGS} ${MPFR_CFLAGS}"
PKG_LIBS="${LIBS} ${GDAL_LIBS} ${GMP_LIBS} ${GDAL_DEP_LIBS} ${MPFR_LIBS}"

## print message indicating success
AC_MSG_NOTICE([Package CPP flags: ${PKG_CPPFLAGS}])
AC_MSG_NOTICE([Package LIBS: ${PKG_LIBS}])
AC_MSG_NOTICE([configuration successful!])

## save settings to Makevars
AC_SUBST([PKG_LIBS], ["${PKG_LIBS}"])
AC_SUBST([PKG_CPPFLAGS],["${PKG_CPPFLAGS}"])
AC_CONFIG_FILES([src/Makevars])

## finish
AC_OUTPUT
