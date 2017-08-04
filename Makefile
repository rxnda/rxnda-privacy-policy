COMMONFORM=node_modules/.bin/commonform

all: privacy.pdf privacy.json privacy.manifest

%.pdf: %.docx
	unoconv $<

privacy.docx: privacy.cform blanks.json | $(COMMONFORM)
	$(COMMONFORM) render -f docx -t "Privacy Policy" -b blanks.json --left-align-title --indent-margins --number outline $< > $@

privacy.json: privacy.cform | $(COMMONFORM)
	$(COMMONFORM) render -f native $< > $@

privacy.manifest: privacy.json mappings.json
	./make-manifest > $@

.INTERMEDIATE: mappings.json

mappings.json: privacy.cform | $(COMMONFORM)
	$(COMMONFORM) directions < $< > $@

$(COMMONFORM):
	npm i
