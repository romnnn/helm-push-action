FROM alpine:latest

LABEL maintainer="romnn <contact@romnn.com>" \
  org.label-schema.name="helm chart push" \
  org.label-schema.vendor="romnnn" \
  org.label-schema.schema-version="1.0"

ENV HELM_VERSION v3.4.2
ENV HELM_PLUGIN_PUSH_VERSION v0.9.0

ENV XDG_DATA_HOME=/opt/xdg
ENV XDG_CACHE_HOME=/opt/xdg

RUN apk add curl tar bash --no-cache
RUN set -ex \
    && curl -sSL https://get.helm.sh/helm-${HELM_VERSION}-linux-amd64.tar.gz | tar xz \
    && mv linux-amd64/helm /usr/local/bin/helm \
    && rm -rf linux-amd64 

RUN apk add --virtual .helm-build-deps git make \
    && helm plugin install https://github.com/chartmuseum/helm-push.git --version ${HELM_PLUGIN_PUSH_VERSION} \
    && apk del --purge .helm-build-deps

COPY entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
