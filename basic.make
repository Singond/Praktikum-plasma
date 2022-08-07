.DEFAULT_GOAL = protokol.pdf

# Calculation results
%-result.csv: %.m %.csv
	@mkdir -p plots
	octave $*.m
# Plots (actual rule is selected based on available inputs)
plots/%.eps plots/%.tex: %.csv %.gp
	@mkdir -p plots
	gnuplot -c $*.gp
plots/%.eps plots/%.tex: %.csv %.m
	@mkdir -p plots
	octave $*.m
plots/%.eps plots/%.tex: %.tsv %.gp
	@mkdir -p plots
	gnuplot -c $*.gp
plots/%.eps plots/%.tex: %.tsv %.m
	@mkdir -p plots
	octave $*.m

ifneq ($(wildcard .templates),)
templatedir = .templates
else
templatedir = ../templates
endif

# Initialize an Eclipse project.
# The optional ".template" suffix on template names will be stripped.
.PHONY: eclipse
eclipse:
	@echo "Initializing Eclipse project..."
	@for file in $$(find ${templatedir}/eclipse/ -type f); do \
		frel="$${file#${templatedir}/eclipse/}"; \
		case "$$frel" in \
			*/*) mkdir -p "$${frel%/*}" ;; \
			*) ;; \
		esac; \
		target="$${frel%.template}"; \
		m4 -D "VAR_PROJECTNAME=${PROJECT_NAME}" "$$file" > "$${target}"; \
	done
	@echo "Success"
