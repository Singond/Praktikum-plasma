PROJECT_NAME=Plasma-01
include ../basic.make

# Uncomment the following line to force Make to use a specific shell
SHELL := /bin/bash
MAKEFLAGS += --no-builtin-rules
ifneq (,$(shell which latexmk 2> /dev/null))
	LATEX := latexmk --pdf
else
	LATEX := pdflatex
endif

.PHONY: all
all: protokol.pdf

tex_resources = build/plots \
$(shell echo plots/fit-{rec,log}-{10,20,50,100,200,300,380}.{eps,tex}) \
$(shell echo plots/{density,recomb,diffuse}-pres.{eps,tex}) \
$(shell echo plots/{density,freq}.{eps,tex}) \
results/summary.tsv

build/plots:
	mkdir -p build/plots

plots/%.eps plots/%.tex: export_%.m main.m
	octave --norc $<

plots/%-pres.eps plots/%-pres.tex: export_%_pres.m main.m
	octave --norc $<

plots/%.eps plots/%.tex: main.m export.m
	octave --norc export.m

results/summary.tsv: export_results.m main.m
	octave --norc $<

.PHONY: tex_resources
tex_resources: makefile ${tex_resources}
	@echo Successfully updated prerequisities for protokol.tex

protokol.pdf : protokol.tex ${tex_resources}
	TEXINPUTS=.:..: ${LATEX} protokol.tex && touch protokol.pdf

.PHONY: clean
clean:
	rm -rf plots
	rm -rf build
