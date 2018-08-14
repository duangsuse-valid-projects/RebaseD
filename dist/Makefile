RPM_DIRS = SPECS SOURCES SOURCES/RebaseD
RPM_ARGS = -ba SPECS/rebased.spec --buildroot SOURCES

.PHONY: rpm manpage
rpm:
	rm -Rf $(RPM_DIRS)
	mkdir  $(RPM_DIRS)
	cp rebased.spec SPECS/
	cp ../Rakefile ../rebased.cr ../rebased-unit.cr ../shard.yml SOURCES/RebaseD
	rpmbuild $(RPM_ARGS)

manpage:
	makeinfo --plaintext rebased.tex -o rebased.1

clean:
	rm -f rebased.1
	rm -rf $(RPM_DIRS)
