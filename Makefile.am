AUTOMAKE_OPTIONS     = 1.4 foreign
MAINTAINERCLEANFILES = Makefile.in

INCLUDES = -I$(top_srcdir) @EROCKS_CFLAGS@

bin_PROGRAMS      = erocks

erocks_SOURCES = \
	src/main.vala \
	src/db.vala \
	src/player.vala \
	src/song.vala \
	src/album.vala \
	src/artist.vala \
	src/ui.vala \
	src/fso.vala
	
erocks_LDADD = @EROCKS_LIBS@
erocks_CFLAGS =
VALAFLAGS = @EROCKS_PACKAGES@ @EROCKS_VALAFLAGS@

desktopdir = $(datadir)/applications
desktop_DATA = data/erocks.desktop


#EDJE:
filesdir = $(datadir)/erocks/
files_DATA = data/erocks.edj

clean-local:
	rm -f data/*.edj


data/erocks.edj: data/default.edc data/playerview.edc data/images.edc
	@edje_cc@ data/default.edc data/erocks.edj
