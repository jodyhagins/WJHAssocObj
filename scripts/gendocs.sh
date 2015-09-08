#!/usr/bin/env sh
binDir="$(dirname "$0")"
binName="$(basename "$0")"

# TODO - use tmp directory for appledoc output...
# Need to use the .plist file to generate another one... allow for customization...
# Add the tempdir to --include so we don't have to copy it into a project folder...
# OR maybe just add it on the command line in addition to the .plist file
tempDir="$(mktemp -dt $(basename $0))" || exit 1
trap 'rm -rf "${tempDir}"' EXIT
set -e

: ${PROJECT_DIR:?}

# Copy extra documentation as template so it is parsed and generated
##docsDir="${PROJECT_DIR}/docs"

# Copy supplementary documentation as appledoc templates, to be parsed and converted into HTML.  These documents will be listed in the "Programming Guides" section of the generated documentation.
docsDir="${tempDir}/Extra"
mkdir -p "${docsDir}"
cp "${PROJECT_DIR}/README.md" "${docsDir}/README-template.md"
cp "${PROJECT_DIR}/LICENSE.md" "${docsDir}/LICENSE-template.md"

# Create the directory in which appledoc will deposit all its files
appledocDir="${tempDir}/appledoc"
mkdir -p "${appledocDir}"

# Generate te documentation
echo "Running appledoc"
appledoc --include "${docsDir}" --output "${appledocDir}" "${binDir}/AppledocSettings.plist" "${PROJECT_DIR}"
cat "${appledocDir}/docset-installed.txt"

# Copy the generated documentation back into the project repository, so we can keep a version of the documentation with the code.
echo "Copying generated documentation to local repository"
localDocsDir="${PROJECT_DIR}/Documentation"
mkdir -p "${localDocsDir}"

rm -rf "${localDocsDir}/html"
cp -r "${appledocDir}/html" "${localDocsDir}/."

rm -rf "${localDocsDir}/docset"
cp -r "${appledocDir}/docset" "${localDocsDir}/."
