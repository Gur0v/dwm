# dwm version
VERSION = 6.8

# paths
PREFIX = /usr/local
MANPREFIX = ${PREFIX}/share/man

X11INC = /usr/X11R6/include
X11LIB = /usr/X11R6/lib

# Xinerama
XINERAMALIBS  = -lXinerama
XINERAMAFLAGS = -DXINERAMA

# freetype
FREETYPELIBS = -lfontconfig -lXft
FREETYPEINC = /usr/include/freetype2

# includes and libs
INCS = \
	-I${X11INC} \
	-I${FREETYPEINC}

LIBS = \
	-L${X11LIB} \
	-lX11 \
	${XINERAMALIBS} \
	${FREETYPELIBS}

# preprocessor
CPPFLAGS = \
	-D_DEFAULT_SOURCE \
	-D_XOPEN_SOURCE=700L \
	-D_FORTIFY_SOURCE=3 \
	-DVERSION=\"${VERSION}\" \
	${XINERAMAFLAGS}

# optimization + hardening
CFLAGS = \
	-std=c99 \
	-pedantic \
	-Wall \
	-Wextra \
	-Wshadow \
	-Wformat=2 \
	-Wundef \
	-O2 \
	-flto=full \
	-fno-plt \
	-fPIE \
	-fstack-protector-strong \
	-fstack-clash-protection \
	-ftrivial-auto-var-init=zero \
	-ffunction-sections \
	-fdata-sections \
	${INCS} \
	${CPPFLAGS}

# linker optimization + hardening
LDFLAGS = \
	-fuse-ld=lld \
	-flto=full \
	-pie \
	-Wl,--gc-sections \
	-Wl,--icf=safe \
	-Wl,--as-needed \
	-Wl,-z,relro \
	-Wl,-z,now \
	-Wl,-z,noexecstack \
	-Wl,-z,separate-code \
	${LIBS}

# compiler
CC = clang
