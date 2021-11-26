include:
  - cluster.keepalived.install

backup-conf:
  file.managed:
    - name: /etc/keepalived/keepalived.conf
    - source: salt://cluster/keepalived/files/backup.conf.j2
    - template: jinja

start-backup:
  service.running:
    - name: keepalived
    - neable: true


