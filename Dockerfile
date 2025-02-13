ARG ALPINE_VERSION=latest

FROM alpine:${ALPINE_VERSION}

ARG BUILD_DATE
ARG BUILD_REVISION
ARG SOURCE_DIR="/github/workspace"

ENV INPUT_SUBDIR=""
ENV INPUT_MAXWIDTH=1920
ENV INPUT_MAXHEIGHT=1080
ENV INPUT_IMAGE=""
ENV DEBUG=false

LABEL org.opencontainers.image.title="TheGroundZero/image-shrinker"
LABEL org.opencontainers.image.description="GitHub action to shrink images to a maximum widthxheight maintaining aspect ratio "
LABEL org.opencontainers.image.authors="2406013+TheGroundZero@users.noreply.github.com"
LABEL org.opencontainers.image.vendor="TheGroundZero"
LABEL org.opencontainers.image.url="https://github.com/TheGroundZero/image-shrinker"
LABEL org.opencontainers.image.source="https://github.com/TheGroundZero/image-shrinker/blob/main/Dockerfile"
LABEL org.opencontainers.image.licenses="GPL-3.0"
# labels using arguments, changing with every build
LABEL org.opencontainers.image.created=${BUILD_DATE}
LABEL org.opencontainers.image.revision=${BUILD_REVISION}

RUN apk add --no-cache file rsvg-convert imagemagick gifsicle

COPY --chmod=755 src/shrinkImages.sh /usr/src/

WORKDIR ${SOURCE_DIR}

ENTRYPOINT /usr/src/shrinkImages.sh "./${INPUT_SUBDIR}" ${INPUT_MAXWIDTH} ${INPUT_MAXHEIGHT} "${INPUT_IMAGE}"
