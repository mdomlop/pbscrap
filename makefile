NAME='pbscrap'
PREFIX='/usr'
TEMPDIR := $(shell mktemp -u --suffix .$(NAME))

install:
	install -Dm 755 src/$(NAME).py $(PREFIX)/bin/$(NAME)
	install -Dm 644 LICENSE $(PREFIX)/share/licenses/$(NAME)/COPYING
	install -Dm 644 BUGS.md $(PREFIX)/share/doc/$(NAME)/BUGS
	install -Dm 644 ChangeLog.md $(PREFIX)/share/doc/$(NAME)/ChangeLog
	install -Dm 644 README.md $(PREFIX)/share/doc/$(NAME)/README
	install -Dm 644 USAGE.md $(PREFIX)/share/doc/$(NAME)/USAGE

uninstall:
	rm -f $(PREFIX)/bin/$(NAME)
	rm -f $(PREFIX)/share/licenses/$(NAME)/COPYING
	rm -f $(PREFIX)/share/doc/$(NAME)/README

	rm -f $(PREFIX)/bin/$(NAME)
	rm -f $(PREFIX)/share/licenses/$(NAME)/COPYING
	rm -f $(PREFIX)/share/doc/$(NAME)/BUGS
	rm -f $(PREFIX)/share/doc/$(NAME)/ChangeLog
	rm -f $(PREFIX)/share/doc/$(NAME)/README
	rm -f $(PREFIX)/share/doc/$(NAME)/USAGE
clean:
	rm -f packages/pacman/$(NAME)-*.pkg.tar.xz

togit: clean
	git add .
	git commit -m "Updated from makefile"
	git push origin

pacman:
	mkdir $(TEMPDIR)
	cp packages/pacman/PKGBUILD $(TEMPDIR)/
	cd $(TEMPDIR); makepkg -dr
	cp $(TEMPDIR)/$(NAME)-*.pkg.tar.xz packages/pacman/
	rm -rf $(TEMPDIR)
	@echo Package done!
	@echo Package is in `pwd`/packages/pacman/
