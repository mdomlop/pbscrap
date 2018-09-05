PREFIX = '/usr'
DESTDIR = ''
DOCS = BUGS INFO ChangeLog
COMPILED_DOCS = README.md AUTHORS
PROGRAM_NAME := $(shell grep ^PROGRAM_NAME INFO | cut -d= -f2)
EXECUTABLE_NAME := $(shell grep ^EXECUTABLE_NAME INFO | cut -d= -f2)
AUTHOR := $(shell grep ^AUTHOR INFO | cut -d= -f2)
SOURCE := $(shell grep ^SOURCE INFO | cut -d= -f2)
VERSION := $(shell grep ^VERSION INFO | cut -d= -f2)
LICENSE := $(shell grep ^LICENSE INFO | cut -d= -f2)
MAIL := $(shell grep ^MAIL INFO | cut -d= -f2 | tr '[A-Za-z]' '[N-ZA-Mn-za-m]')
TIMESTAMP = $(shell LC_ALL=C date '+%a, %d %b %Y %T %z')
YEAR = 2018

dist: docs

docs: $(COMPILED_DOCS) $(DOCS)
	
AUTHORS: authors.in
	sed s/@mail@/$(MAIL)/g $^ > $@

README.md: README USAGE INSTALL
	cat README USAGE INSTALL >> README.md
	sed -i "s|@executable_name@|$(EXECUTABLE_NAME)|g" $@
	sed -i "s|@version@|$(VERSION)|g" $@
	
install_executables:
	install -Dm 755 src/$(EXECUTABLE_NAME).py $(DESTDIR)/$(PREFIX)/bin/$(EXECUTABLE_NAME)

install_docs:
	install -dm 755 $(DESTDIR)$(PREFIX)/share/doc/$(EXECUTABLE_NAME)
	install -Dm 644 $(DOCS) $(COMPILED_DOCS) $(DESTDIR)$(PREFIX)/share/doc/$(EXECUTABLE_NAME)
	install -Dm 644 LICENSE $(DESTDIR)$(PREFIX)/share/licenses/$(EXECUTABLE_NAME)/COPYING

install: install_executables install_docs

uninstall:
	rm -f $(PREFIX)/bin/$(EXECUTABLE_NAME)
	rm -rf $(PREFIX)/share/licenses/$(EXECUTABLE_NAME)/
	rm -rf $(PREFIX)/share/doc/$(EXECUTABLE_NAME)/

clean: arch_clean
	rm -f AUTHORS *.md

arch_pkg: clean ChangeLog
	sed -i "s|pkgname=.*|pkgname=$(EXECUTABLE_NAME)|" PKGBUILD
	sed -i "s|pkgver=.*|pkgver=$(VERSION)|" PKGBUILD
	makepkg
	@echo Package done!
	@echo You can install it as root with:
	@echo pacman -U $(EXECUTABLE_NAME)-$(VERSION)-1-any.pkg.tar.xz

arch_clean:
	rm -rf pkg $(EXECUTABLE_NAME)-$(VERSION)-1-any.pkg.tar.xz

