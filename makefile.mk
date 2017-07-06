NAME='pbscrap'
PREFIX='/usr'
DESTDIR=''
TEMPDIR := $(shell mktemp -u --suffix .$(NAME))

all:
	@echo Nothing to build
	@echo You can execute make install now

togit: purge doc
	git add .
	git commit -m "Update from makefile"
	git push origin

install:
	install -Dm 755 src/$(NAME).py $(DESTDIR)/$(PREFIX)/bin/$(NAME)
	install -Dm 644 LICENSE $(DESTDIR)/$(PREFIX)/share/licenses/$(NAME)/COPYING
	install -Dm 644 BUGS $(DESTDIR)/$(PREFIX)/share/doc/$(NAME)/BUGS
	install -Dm 644 ChangeLog $(DESTDIR)/$(PREFIX)/share/doc/$(NAME)/ChangeLog
	install -Dm 644 README $(DESTDIR)/$(PREFIX)/share/doc/$(NAME)/README
	install -Dm 644 USAGE $(DESTDIR)/$(PREFIX)/share/doc/$(NAME)/USAGE

uninstall:
	rm -f $(PREFIX)/bin/$(NAME)
	rm -f $(PREFIX)/share/licenses/$(NAME)/COPYING
	rm -f $(PREFIX)/share/doc/$(NAME)/*
clean:
	rm -rf $(NAME)-*.pkg.tar.xz *.md

purge: clean
	rm -rf /tmp/tmp.*.$(NAME) makefile
	@echo makefile deleted. Execute configure script to generate it again.

pacman-remote: clean
	mkdir $(TEMPDIR)
	cp packages/pacman/git/* ChangeLog $(TEMPDIR)/
	cd $(TEMPDIR); makepkg
	cp $(TEMPDIR)/$(NAME)-*.pkg.tar.xz .
	@echo Package done!
	@echo You can install it as root with:
	@echo pacman -U $(NAME)-*.pkg.tar.xz

pacman: clean
	mkdir $(TEMPDIR)
	tar cf $(TEMPDIR)/$(NAME).tar ../$(NAME)
	cp packages/pacman/local/* ChangeLog $(TEMPDIR)/
	cd $(TEMPDIR); makepkg
	cp $(TEMPDIR)/$(NAME)-*.pkg.tar.xz .
	@echo Package done!
	@echo You can install it as root with:
	@echo pacman -U $(NAME)-*.pkg.tar.xz
