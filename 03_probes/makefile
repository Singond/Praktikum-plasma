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

figs = $(shell echo plots/simple1-vac-{1..7}.{eps,tex})
figs += $(shell echo plots/simple1-vac-log-{1..7}.{eps,tex})
figs += $(shell echo plots/simple2-vac-{1..3}.{eps,tex})
figs += $(shell echo plots/simple2-vac-log-{1..3}.{eps,tex})
figs += $(shell echo plots/simple2-eedf-{1..3}.{eps,tex})
figs += $(shell echo plots/double-vac-{1..4}.{eps,tex})
figs += $(shell echo plots/separation.{eps,tex})

octave_deps = ../plotsettings.gp common.m

tex_resources = build/plots ${figs} results/comparison.tsv

build/plots:
	mkdir -p build/plots

plots/simple1-%.tex plots/simple1-%.eps: export_simple1.m probesimple1.m \
${octave_deps}
	octave --norc export_simple1.m

plots/simple2-%.tex plots/simple2-%.eps: export_simple2.m probesimple2.m \
${octave_deps}
	octave --norc export_simple2.m

plots/double-%.tex plots/double-%.eps: export_double.m probedouble.m \
octave/plasmaprops_double.m ${octave_deps}
	octave --norc export_double.m

plots/separation.tex plots/separation.eps: export_separation.m probesimple2.m \
${octave_deps}
	octave --norc export_separation.m

results/comparison.tsv: export_comparison.m probesimple1.m probesimple2.m \
${octave_deps}
	octave --norc export_comparison.m

.PHONY: tex_resources
tex_resources: makefile ${tex_resources}
	@echo Successfully updated prerequisities for protokol.tex

protokol.pdf : protokol.tex ${tex_resources}
	TEXINPUTS=.:..: ${LATEX} protokol.tex && touch protokol.pdf

.PHONY: clean
clean:
	rm -rf plots
	rm -rf build
