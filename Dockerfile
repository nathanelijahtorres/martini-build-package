ARG MARTINI_VERSION=latest

FROM lontiplatform/martini-server-runtime:${MARTINI_VERSION}

ARG PACKAGE_DIR=packages
RUN mkdir -p /data/packages
COPY ${PACKAGE_DIR} /data/packages/
COPY conf /data/conf/