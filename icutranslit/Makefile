
PG_CONFIG ?= pg_config
PGPATH    ?= $(shell $(PG_CONFIG) --includedir-server)

override CPPFLAGS += -I$(PGPATH)
override CXXFLAGS += -fPIC -fno-exceptions

LIBS = -licui18n

all: osml10n_translit.so

osml10n_translit.o: osml10n_translit.cpp
	$(CXX) $(CPPFLAGS) $(CXXFLAGS) -c $< -o $@

osml10n_translit.so: osml10n_translit.o
	$(CXX) $(LDFLAGS) -shared -o $@ $^ $(LIBS)

install: osml10n_translit.so
	install -D -m 755 osml10n_translit.so \
		$(DESTDIR)$(shell $(PG_CONFIG) --pkglibdir)/osml10n_translit.so

clean:
	rm -f *.o *.so

.PHONY: all install clean
