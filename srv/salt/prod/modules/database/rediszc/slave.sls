include:
  - redis.install

slave_confing:
  cmd.run:
    - name: redis-cli -h 192.168.172.143 slaveof 192.168.172.142 6379
    - require:
      - service: redis-service
