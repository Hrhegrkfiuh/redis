/etc/rsyslog.conf:
  file.managed:
    - source: salt://haproxy/files/rsyslog.conf
    
stop-rsyslog:
  service.dead:
    - name: rsyslog.service
    - enable: false
    
rsyslog.service:
  service.running:
    - enable: true
