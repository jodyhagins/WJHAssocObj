#!/usr/bin/env sh
binDir="$(dirname "$0")"
binName="$(basename "$0")"

export PATH="${binDir}:${PATH}:/usr/libexec"
plistBuddy="$(which PlistBuddy)"
if [ -z "${plistBuddy}" ]; then
  echo "No path to PlistBuddy" 1>&2
  exit 1
fi

# TODO - use tmp directory for appledoc output...
# Need to use the .plist file to generate another one... allow for customization...
# Add the tempdir to --include so we don't have to copy it into a project folder...
# OR maybe just add it on the command line in addition to the .plist file
tempDir="$(mktemp -dt $(basename $0))" || exit 1
trap 'rm -rf "${tempDir}"' EXIT
set -e

: ${PROJECT_DIR:?}

function changeVersionBadge() {
  cat "${1}" | sed -e "s^https://badge.fury.io/gh/jodyhagins%2FWJHAssocObj.svg^https://img.shields.io/badge/Version-${WJH_RELEASE_VERSION}-blue.svg^" > "${2}"
}


# Copy supplementary documentation as appledoc templates, to be parsed and converted into HTML.  These documents will be listed in the "Programming Guides" section of the generated documentation.
docsDir="${tempDir}/Extra"
mkdir -p "${docsDir}"
changeVersionBadge "${PROJECT_DIR}/README.md" "${docsDir}/README-template.md"
cp "${PROJECT_DIR}/LICENSE.md" "${docsDir}/LICENSE-template.md"


# Update the appledoc settings used to create the documentation
cp "${binDir}/AppledocSettings.plist" "${tempDir}/AppledocSettings.plist"
changeVersionBadge "${PROJECT_DIR}/scripts/INDEX.md" "${tempDir}/INDEX.md"
"${plistBuddy}" -c "Set ":--index-desc" "${tempDir}/INDEX.md"" "${tempDir}/AppledocSettings.plist"
"${plistBuddy}" -c "Set ":--project-version" "${WJH_RELEASE_VERSION}"" "${tempDir}/AppledocSettings.plist"


# Create the directory in which appledoc will deposit all its files
appledocDir="${tempDir}/appledoc"
mkdir -p "${appledocDir}"

# Generate te documentation
echo "Running appledoc"
/Users/jody/bin/appledoc --include "${docsDir}" --output "${appledocDir}" "${tempDir}/AppledocSettings.plist" "${PROJECT_DIR}"
cat "${appledocDir}/docset-installed.txt"

# Copy the generated documentation back into the project repository, so we can keep a version of the documentation with the code.
echo "Copying generated documentation to local repository"
localDocsDir="${PROJECT_DIR}/Documentation"
mkdir -p "${localDocsDir}"

rm -rf "${localDocsDir}/html"
cp -r "${appledocDir}/html" "${localDocsDir}/."

rm -rf "${localDocsDir}/docset"
cp -r "${appledocDir}/docset" "${localDocsDir}/."
