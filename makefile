name='pbscrap'
binary=$(name).py

install:
	install -m 755 src/$(binary) /usr/bin/$(name)
uninstall:
	rm /usr/bin/$(name)
togit:
	git add .
	git commit -m "Updated from makefile"
	git push origin
