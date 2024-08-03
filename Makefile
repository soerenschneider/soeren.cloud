.PHONY: diagrams
diagrams:
	find diagrams -iname '*.d2' -print0 | xargs -0 -I {} d2 "{}"
