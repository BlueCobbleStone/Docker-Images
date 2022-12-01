## Dockerfile.public - Bundle a Traefik plugin from a public git repository
FROM alpine:3
ARG PLUGIN_NAME=sablier
ARG PLUGIN_MODULE=github.com/acouvreur/sablier
ARG PLUGIN_GIT_REPO=https://github.com/acouvreur/sablier.git
ARG PLUGIN_GIT_BRANCH=main
RUN apk update && \
    apk add git && \
    git clone ${PLUGIN_GIT_REPO} /plugins-local/src/${PLUGIN_MODULE} \
      --depth 1 --single-branch --branch ${PLUGIN_GIT_BRANCH}

FROM traefik:latest
COPY --from=0 /plugins-local /plugins-local
