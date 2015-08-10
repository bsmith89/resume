output := resume.html
PANDOC_OPTS := --smart --standalone 

include local.mk

.POSIX:
.DELETE_ON_ERROR:

.PHONY: all
all: ${output}

resume.html: resume.html5
	cp $< $@

resume.%: resume.md resume.%.template
	pandoc ${PANDOC_OPTS} --to=$* --template=resume.$*.template --output=$@ $<

upload: resume.html
	rsync -e "ssh -p ${SSH_PORT}" -P -vzc $< ${SSH_USER}@${SSH_HOST}:${SSH_TARGET_DIR}

