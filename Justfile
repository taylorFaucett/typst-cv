# Help message 
default:
    @just --list

# Compile everything
all: cv

# Compile CV
cv:
    typst compile cv.typ taylor-faucett-cv.pdf

# Watch CV and recompile on changes
watch:
    typst watch cv.typ taylor-faucett-cv.pdf

# Compile targeted CV for cadflow.ai application
cv-cadflow:
    typst compile cv.typ taylor-faucett-cv-cadflow.pdf --input data=cadflow.yml

# Watch cadflow CV and recompile on changes
watch-cadflow:
    typst watch cv.typ taylor-faucett-cv-cadflow.pdf --input data=cadflow.yml

# Remove compiled PDFs
clean:
    rm -f taylor-faucett-cv.pdf taylor-faucett-statement.pdf taylor-faucett-cv-cadflow.pdf
