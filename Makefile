.PHONY: all cv cover-letter clean watch

# Default target: compile both CV and cover letter
all: cv cover-letter

# Compile CV
cv:
	typst compile cv.typ

# Compile cover letter
cover-letter:
	typst compile cover-letter.typ

# Watch mode for CV (auto-recompile on changes)
watch:
	typst watch cv.typ

# Clean generated PDFs
clean:
	rm -f cv.pdf cover-letter.pdf
