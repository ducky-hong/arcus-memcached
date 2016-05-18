FROM debian:jessie

RUN groupadd -r memcache && useradd -r -g memcache memcache
RUN apt-get update && apt-get install -y --no-install-recommends \
                libevent-2.0-5 \
                curl gcc libc6-dev libevent-dev make perl git libtool automake autoconf python-dev python-pip \
        && rm -rf /var/lib/apt/lists/*

RUN pip install kazoo

ADD . /arcus-memcached
WORKDIR /arcus-memcached

RUN set -x && tar xzf zookeeper-3.4.5.tar.gz && cd /arcus-memcached/zookeeper-3.4.5/src/c && ./configure && make clean && make && make install

# touch all files to avoid 'Clock skew detected' during make.
RUN set -x \
        && find . -exec touch {} \; \
        && ./config/autorun.sh \
        && ./configure --enable-zk-integration \
        && make && make install \
        && chown -R memcache:memcache .

USER memcache
EXPOSE 11211
CMD ["memcached", "-E", "/usr/local/lib/default_engine.so"]
