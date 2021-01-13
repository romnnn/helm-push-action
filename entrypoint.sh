#!/bin/bash
set -e

if [ -z "$CHART" ]; then
  echo "missing helm chart name"
  exit 1
fi

if [ -z "$REGISTRY" ]; then
  echo "missing helm registry url"
  exit 1
fi

if [ -z "$USER" ]; then
  echo "missing helm registry user"
  exit 1
fi

if [ -z "$PASSWORD" ]; then
  echo "missing helm registry password"
  exit 1
fi

if [ -z "$CHART_DIR" ]; then
  CHART_DIR="."
fi

# make lowercase
FORCE=$(echo "$FORCE" | tr '[:upper:]' '[:lower:]')
if [ "$FORCE" == "1" ] || [ "$FORCE" == "y" ] || [ "$FORCE" == "yes" ] || [ "$FORCE" == "true" ]; then
  FORCE="-f"
else
  FORCE=""
fi

cd ${CHART_DIR}/${CHART}
helm inspect chart .
helm package .
helm dependency update .
helm push ${CHART_DIR}-* ${REGISTRY} -u ${USER} -p ${PASSWORD} ${FORCE}
