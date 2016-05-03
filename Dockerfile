FROM debian:jessie

RUN groupadd -r memcache && useradd -r -g memcache memcache
RUN apt-get update && apt-get install -y --no-install-recommends \
                libevent-2.0-5 \
                curl gcc libc6-dev libevent-dev make perl git libtool automake autoconf \
        && rm -rf /var/lib/apt/lists/*

ADD . /arcus-memcached
WORKDIR /arcus-memcached

# touch all files to avoid 'Clock skew detected' during make.
RUN set -x \
        && find . -exec touch {} \; \
        && ./config/autorun.sh \
        && ./configure \
        && make && make install

USER memcache
EXPOSE 11211
CMD ["memcached", "-E", "/usr/local/lib/default_engine.so"]
