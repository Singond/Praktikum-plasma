PROJECTS := $(shell find . -maxdepth 1 -type d -regextype posix-egrep -regex '\./[0-9]{2}_.*' -printf '%P\n')
TEX_PROJECTS := $(shell find * -maxdepth 1 -regextype posix-egrep -regex '[0-9]{2}_[^/]*/protokol.tex' -printf '%h\n')
PDF_OUTPUT := $(TEX_PROJECTS:%=%.pdf)

.PHONY: all
all: pdf

# PDF output documents in top-level directory
.PHONY: pdf
pdf: ${PDF_OUTPUT}

${PDF_OUTPUT}: %.pdf: %/protokol.pdf
	if [ -f "$^" ]; then ln -fs "$^" "$@"; fi

.PHONY: $(PROJECTS:%=%/protokol.pdf)
$(PROJECTS:%=%/protokol.pdf): %/protokol.pdf : %/protokol.tex %/makefile
	cd "$*" && $(MAKE) protokol.pdf
