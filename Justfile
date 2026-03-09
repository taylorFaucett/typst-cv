# Help message
default:
    @just --list

# Compile everything (base CV + all roles)
all: cv roles

# Compile CV
cv:
    typst compile cv.typ taylor-faucett-cv.pdf

# Watch CV and recompile on changes
watch:
    typst watch cv.typ taylor-faucett-cv.pdf

# Compile all role-specific CVs
roles:
    #!/usr/bin/env bash
    for dir in roles/*/; do
        role=$(basename "$dir")
        if [ -f "roles/$role/data.yml" ]; then
            echo "Compiling CV for $role..."
            typst compile cv.typ "roles/$role/taylor-faucett-cv.pdf" --input "data=roles/$role/data.yml"
        fi
    done

# Compile CV tailored for a specific role (e.g., just cv-role aperium-ai)
cv-role role:
    typst compile cv.typ roles/{{role}}/taylor-faucett-cv.pdf --input data=roles/{{role}}/data.yml

# Watch a role-specific CV and recompile on changes
watch-role role:
    typst watch cv.typ roles/{{role}}/taylor-faucett-cv.pdf --input data=roles/{{role}}/data.yml

# Remove compiled PDFs
clean:
    rm -f taylor-faucett-cv.pdf
    find roles -name "*.pdf" -delete
