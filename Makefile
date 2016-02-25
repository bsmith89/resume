SITE_DIR := site
SITE_INDEX := resume.html
SITE_CONTENT :=
OUTPUT := resume.html resume.pdf
CLEANUP := ${SITE_DIR} ${OUTPUT}

VENV=./.venv
export VIRTUAL_ENV := $(abspath ${VENV})
export PATH := ${VIRTUAL_ENV}/bin:${PATH}

include local.mk

.POSIX:
.DELETE_ON_ERROR:

.PHONY: all site
all: ${OUTPUT}
site: $(addprefix ${SITE_DIR}/,index.html ${SITE_CONTENT})

${SITE_DIR}/index.html: ${SITE_INDEX}
	@mkdir -p ${@D}
	cp $< $@

${SITE_DIR}/%: %
	@mkdir -p ${@D}
	cp $< $@

resume.html: resume.md resume.html5.template header.html
	pandoc --smart --standalone --to=html5 --template=$(word 2,$^) \
           --include-in-header $(word 3,$^) --output=$@ $(word 1,$^)

resume.pdf: resume.md resume.latex.template
	pandoc --to=latex --template=$(word 2,$^) --output=$@ $(word 1,$^)

upload: ${OUTPUT}
	rsync -e "ssh -p ${SSH_PORT}" -P -vzc $^ ${SSH_USER}@${SSH_HOST}:${SSH_TARGET_DIR}

gh-pages: site
	ghp-import -b gh-pages -m "`date`" -p ${SITE_DIR}

clean:
	rm -rf ${CLEANUP}
