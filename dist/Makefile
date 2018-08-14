RPM_DIRS = SPECS
RPM_ARGS = -ba SPECS/rebased.spec

rpm:
	rm -rf $(RPM_DIRS)
	mkdir $(RPM_DIRS)
	cp rebased.spec SPECS/
	tar -cf ~/rpmbuild/SOURCES/RebaseD ../Rakefile ../rebased.cr ../rebased-unit.cr ../shard.yml
	rpmbuild $(RPM_ARGS)

manpage:
	makeinfo --plaintext rebased.tex -o rebased.1

clean:
	rm -rf rebased.1 ~/rpmbuild/SOURCES/RebaseD
	rm -rf $(RPM_DIRS)

.PHONY: rpm manpage clean
