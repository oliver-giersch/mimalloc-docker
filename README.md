# mimalloc-docker

Dockerfile for downloading the [mimalloc](https://github.com/microsoft/mimalloc)
and builds it as a shared library with GCC. The resulting image should be used as a build container, from which the resulting lib can then be copied into the target container like so:

```docker
FROM mimalloc:2.0.3 as lib
COPY --from=lib /mimalloc/ /usr/local/lib
ENV LD_PRELOAD=/usr/local/lib/libmimalloc.so
```

By setting `LD_PRELOAD`, mimalloc will be used as default allocator for all applications that dynamically link `libc`. The image can be built as follows:

```shell
$ docker build --build-arg VER=2.0.3 -t mimalloc:2.0.3 .
```