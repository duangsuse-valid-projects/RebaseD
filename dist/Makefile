RPM_ARGS = -ba SPECS/rebased.spec
SOURCE = ../Rakefile ../rebased.cr ../rebased-unit.cr ../shard.yml
VERSION = 0.1.0
SERVER = rebase-server-$(VERSION)
RPM_DIRS = SPECS $(SERVER)

rpm:
	rm -rf $(RPM_DIRS)
	mkdir $(RPM_DIRS)
	cp rebased.spec SPECS/
	cp $(SOURCE) $(SERVER)
	mkdir $(SERVER)/dist
	cp Makefile rebased-version.incl rebased.tex $(SERVER)/dist
	tar -cf ~/rpmbuild/SOURCES/RebaseD $(SERVER)
	rpmbuild $(RPM_ARGS)

manpage:
	makeinfo --plaintext rebased.tex -o rebased.1

clean:
	rm -rf rebased.1 ~/rpmbuild/SOURCES/RebaseD
	rm -rf $(RPM_DIRS)
	rm -rf ~/rpmbuild/BUILD/$(SERVER)

.PHONY: rpm manpage clean
