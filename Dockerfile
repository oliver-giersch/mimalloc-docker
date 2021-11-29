# A utility container for compiling and providing mimalloc as a shared library

FROM docker.io/alpine:3.14 as builder

ARG VER
ARG URL=https://github.com/microsoft/mimalloc/archive/refs/tags/v${VER}.tar.gz

WORKDIR /usr/local/src/mimalloc
# install build dependencies
RUN apk add --update --no-cache cmake g++ gcc make
# download sources & build
RUN wget -O - $URL | tar -xz --strip-components 1 \
  && mkdir -p out/releases && cd out/releases \
  && cmake ../.. \
  -DMI_BUILD_OBJECT=OFF \
  -DMI_BUILD_STATIC=OFF \
  -DMI_BUILD_TESTS=OFF \
  && make

FROM scratch
COPY --from=builder /usr/local/src/mimalloc/out/releases/libmimalloc.so* /mimalloc/