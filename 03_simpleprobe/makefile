SHELL := /bin/bash
MAKEFLAGS += --no-builtin-rules

PROJECT_NAME=Plasma-03
include ../basic.make

# Uncomment the following line to force Make to use a specific shell
# SHELL := /bin/bash
MAKEFLAGS += --no-builtin-rules
ifneq (,$(shell which latexmk 2> /dev/null))
	LATEX := latexmk --pdf
else
	LATEX := pdflatex
endif

.PHONY: all
all: protokol.pdf

figs = $(shell echo plots/vac-{1..7}.{eps,tex})

tex_resources = build/plots ${figs}

build/plots:
	mkdir -p build/plots

plots/vac-%.tex plots/vac-%.eps: ../plotsettings.gp main.m export.m
	octave --norc export.m

.PHONY: tex_resources
tex_resources: makefile ${tex_resources}
	@echo Successfully updated prerequisities for protokol.tex

protokol.pdf : protokol.tex ${tex_resources}
	TEXINPUTS=.:..: ${LATEX} protokol.tex && touch protokol.pdf

.PHONY: clean
clean:
	rm -rf plots
	rm -rf build
