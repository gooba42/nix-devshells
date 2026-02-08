# Common Makefile for template flakes
.PHONY: build test clean clean-artifacts

build:
	echo "No-op: run language-specific build in subtemplate."

clean:
	echo "No-op: run language-specific clean in subtemplate."

test:
	echo "No-op: run language-specific test in subtemplate."

# Remove all build artifacts and cache directories from templates
clean-artifacts:
	@echo "Cleaning build artifacts from all templates..."
	@find . -maxdepth 2 \( \
		-name "target" -o \
		-name "node_modules" -o \
		-name ".venv" -o \
		-name "build" -o \
		-name "dist" -o \
		-name ".direnv" -o \
		-name "result" -o \
		-name "result-*" -o \
		-name "__pycache__" -o \
		-name "*.egg-info" \
	\) -exec rm -rf {} + 2>/dev/null || true
	@echo "✓ Artifacts cleaned"
