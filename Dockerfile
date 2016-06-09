FROM cs494/arcus-memcached-base

RUN mkdir -p /etc/service/arcus-memcached
ADD arcus-memcached.sh /etc/service/arcus-memcached/run

EXPOSE 11211

CMD ["/sbin/my_init"]

