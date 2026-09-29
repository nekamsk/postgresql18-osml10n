
PG_CONFIG ?= pg_config
PGPATH    ?= $(shell $(PG_CONFIG) --includedir-server)

override CPPFLAGS += -I$(PGPATH)
override CFLAGS   += -fPIC -fno-exceptions

LIBS = -lkakasi -lutf8proc

all: osml10n_kanjitranscript.so

%.o: %.c
	$(CC) $(CPPFLAGS) $(CFLAGS) -c $< -o $@

osml10n_kanjitranscript.so: kanjitranscript.o
	$(CC) $(LDFLAGS) -shared -o $@ $^ $(LIBS)

install: osml10n_kanjitranscript.so
	install -D -m 755 osml10n_kanjitranscript.so \
		$(DESTDIR)$(shell $(PG_CONFIG) --pkglibdir)/osml10n_kanjitranscript.so

clean:
	rm -f *.o *.so

.PHONY: all install clean
