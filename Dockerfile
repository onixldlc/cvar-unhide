FROM registry.gitlab.steamos.cloud/steamrt/scout/sdk:latest

RUN set -ex && \
    mkdir -p /opt && \
    LIBGCC_PATH="$(gcc -m32 -print-file-name=libgcc_s.so.1)" && \
    echo "scout SDK reports libgcc_s.so.1 at: $LIBGCC_PATH" && \
    test -f "$LIBGCC_PATH" && \
    cp "$LIBGCC_PATH" /opt/libgcc_s.so.1 && \
    sha256sum /opt/libgcc_s.so.1

RUN { \
      echo '#!/bin/bash'; \
      echo 'set -e'; \
      echo '[ -f /work/libgcc_s.so.1 ] || cp /opt/libgcc_s.so.1 /work/libgcc_s.so.1'; \
      echo 'exec "$@"'; \
    } > /usr/local/bin/build-entry && chmod +x /usr/local/bin/build-entry

RUN g++ --version

WORKDIR /work
ENTRYPOINT ["/usr/local/bin/build-entry"]
CMD ["make", "plugin"]
