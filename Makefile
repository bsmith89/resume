SITE_DIR := site
SITE_INDEX := vitae.html
SITE_CONTENT :=
OUTPUT := vitae.html vitae.pdf resume.html resume.pdf
CLEANUP := ${SITE_DIR} ${OUTPUT}

VENV=./.venv
export VIRTUAL_ENV := $(abspath ${VENV})
export PATH := ${VIRTUAL_ENV}/bin:${PATH}

# include local.mk

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

%.html: %.md %.html5.template
	pandoc --standalone --to=html5 --template=$(word 2,$^) \
           --output=$@ $(word 1,$^)

%.pdf: %.md %.latex.template
	pandoc --to=latex --pdf-engine=lualatex -V fontsize=12pt --template=$(word 2,$^) --output=$@ $(word 1,$^)

%.docx: %.md
	pandoc $< -o $@

website: ${OUTPUT}
	rsync -e "ssh -p ${SSH_PORT}" -P -vzc $^ ${SSH_USER}@${SSH_HOST}:${SSH_TARGET_DIR}

gh-pages: site
	ghp-import -b gh-pages -m "`date`" -p ${SITE_DIR}

upload: website gh-pages

clean:
	rm -rf ${CLEANUP}
