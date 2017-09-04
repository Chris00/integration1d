WEB = integration1d.forge.ocamlcore.org:/home/groups/integration1d/htdocs/

TESTS=$(wildcard examples/*.ml)

build:
	jbuilder build @install $(TESTS:.ml=.exe) #--dev

tests: build
	for t in $(TESTS:.ml=.exe); do \
	  echo  "### Executing test $$t ###"; \
	  ./_build/default/$$t; \
	done

install uninstall:
	jbuilder $@

doc:
	sed -e 's/%%VERSION%%/$(PKGVERSION)/' src/moss.mli \
	  > _build/default/src/moss.mli
	jbuilder build @doc
	echo '.def { background: #f0f0f0; }' >> _build/default/_doc/odoc.css

upload-doc: doc
	scp -C -r _build/default/_doc/root1d/integration1d $(WEB)/doc
	scp -C _build/default/_doc/odoc.css $(WEB)/

clean::
	jbuilder clean

.PHONY: build tests install uninstall doc upload-doc clean
