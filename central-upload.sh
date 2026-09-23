#!/usr/bin/env bash
#
# Manual upload of an already built Maven Central bundle via the Central
# Publisher Portal API - fallback if the central-publishing-maven-plugin
# upload of a release failed (e.g. timeout at the end of a long build).
#
# Required environment variables:
#   CENTRAL_USER   Central Portal user token name
#   CENTRAL_TOKEN  Central Portal user token password
#                  (generate at https://central.sonatype.com/account ;
#                   same values as <username>/<password> of the "central"
#                   server in ~/.m2/settings.xml - if the password there is
#                   Maven-encrypted ({...}), take the plain token instead)
#
# Optional environment variables:
#   BUNDLE           path to the bundle ZIP
#                    (default: target/checkout/target/central-publishing/central-bundle.zip)
#   DEPLOYMENT_NAME  name shown in the Portal UI (default: derived from the bundle content)
#   PUBLISHING_TYPE  USER_MANAGED (default; requires pressing "Publish" in the UI)
#                    or AUTOMATIC (publishes right away after validation)
#
# Usage: ./central-upload.sh [path-to-bundle.zip]

set -euo pipefail

BASE_DIR="$(cd "$(dirname "$0")" && pwd)"
BUNDLE="${1:-${BUNDLE:-$BASE_DIR/target/checkout/target/central-publishing/central-bundle.zip}}"
PUBLISHING_TYPE="${PUBLISHING_TYPE:-USER_MANAGED}"

: "${CENTRAL_USER:?not set - export CENTRAL_USER with the Central Portal token name}"
: "${CENTRAL_TOKEN:?not set - export CENTRAL_TOKEN with the Central Portal token password}"

if [ ! -s "$BUNDLE" ]; then
  echo "ERROR: bundle not found or empty: $BUNDLE" >&2
  exit 1
fi

if [ -z "${DEPLOYMENT_NAME:-}" ]; then
  # Entries look like "com/helger/phive/rules/phive-rules-all/4.6.0/phive-rules-all-4.6.0.pom"
  ENTRIES="$(unzip -Z1 "$BUNDLE")"
  ENTRY="$(printf '%s\n' "$ENTRIES" | grep -m 1 -- '-parent-pom/' || true)"
  [ -n "$ENTRY" ] || ENTRY="$(printf '%s\n' "$ENTRIES" | sed -n '1p')"
  DEPLOYMENT_NAME="$(printf '%s\n' "$ENTRY" | awk -F/ '{
    g = $1;
    for (i = 2; i <= NF - 3; i++) g = g "." $i;
    print g ":" $(NF - 2) ":" $(NF - 1);
  }')"
fi

echo "Bundle          : $BUNDLE ($(du -h "$BUNDLE" | cut -f1))"
echo "Deployment name : $DEPLOYMENT_NAME"
echo "Publishing type : $PUBLISHING_TYPE"
echo

# "base64 -w0" is GNU only - macOS base64 has no -w, so strip newlines instead
AUTH="$(printf '%s:%s' "$CENTRAL_USER" "$CENTRAL_TOKEN" | base64 | tr -d '\n')"

DEPLOYMENT_ID="$(curl --fail-with-body --retry 5 --retry-all-errors --retry-delay 30 \
  --connect-timeout 30 \
  --progress-bar \
  -X POST \
  -H "Authorization: Bearer $AUTH" \
  -F bundle=@"$BUNDLE" \
  "https://central.sonatype.com/api/v1/publisher/upload?name=${DEPLOYMENT_NAME}&publishingType=${PUBLISHING_TYPE}")"

echo
echo "Deployment ID   : $DEPLOYMENT_ID"
echo
echo "Check the state in the UI  : https://central.sonatype.com/publishing/deployments"
echo "or via the API             :"
echo "  curl --fail-with-body -X POST \\"
echo "    -H \"Authorization: Bearer \$(printf '%s:%s' \"\$CENTRAL_USER\" \"\$CENTRAL_TOKEN\" | base64 | tr -d '\\n')\" \\"
echo "    \"https://central.sonatype.com/api/v1/publisher/status?id=$DEPLOYMENT_ID\""
