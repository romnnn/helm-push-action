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

if [ ! -z "$CHART_VERSION" ]; then
  CHART_VERSION=$(echo "${CHART_VERSION}" | sed -e 's|refs/tags||' | sed -e 's/^v//')
  CHART_VERSION="--version ${CHART_VERSION}"
fi

if [ ! -z "$APP_VERSION" ]; then
  APP_VERSION=$(echo "${APP_VERSION}" | sed -e 's|refs/tags||' | sed -e 's/^v//' | sed -e 's/+.*//')
  APP_VERSION="--version ${APP_VERSION}"
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
helm package ${APP_VERSION} ${CHART_VERSION} .
helm dependency update .
helm push ${CHART}-* ${REGISTRY} -u ${USER} -p ${PASSWORD} ${FORCE}
