.PHONY: all cv statement

# Default target: compile CV + statement
all: cv statement

# Compile CV
cv:
	typst compile cv.typ taylor-faucett-cv.pdf

prep-pdf:
	cd prep && mdbook build