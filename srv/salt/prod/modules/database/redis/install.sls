dep-pkg-redis-install:
  pkg.installed:
    - pkg:
      - systemd-devel
      - tcl-devel
      - gcc
      - gcc-c++
      - make

unzip-redis:
  archive.extracted:
    - source: salt://modules/database/redis/files/redis-6.0.6.tar.gz
    - if_missing: /usr/src/redis-6.0.6

redis-compile:
  cmd.run:
    - name: cd /usr/src/redis-6.0.6;make
    - unless: test -f /usr/bin/redis-server
    - require:
      - archive: unzip-redis

provide-program-file:
  file.managed:
    - names: 
      - /usr/bin/redis-sentinel:
        - source: /usr/src/redis-6.0.6/srcredis-sentinel
        - mode: '0755'
      - /usr/bin/redis-server:
        - source: /usr/src/redis-6.0.6/redis-server
        - mode: '0755'
      - /usr/bin/redis-benchmark:
        - source: /usr/src/redis-benchmark
        - mode: '0755'
      - /usr/bin/redis-check-aof:
        - source: /usr/src/redis-check-aof
        - mode: '0755'
      - /usr/bin/redis-check-rdb:
        - source: /usr/src/redis-check-rdb
        - mode: '0755'
      - /usr/bin/redis-cli:
        - source: /usr/src/redis-cli
        - mode: '0755'
      - /etc/redis.conf:
        - source: salt://modules/database/redis/files/redis.conf.j2
        - template: jinja
      - /usr/lib/systemd/system/redis_server.service:
        - source: salt://modules/database/redis/files/redis_server.service

redis_server.service:
  service.running:
    - enable: true
    - reload: true
    - watch:
      - file: provide-program-file

