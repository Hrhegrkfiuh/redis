include:
  - cluster.keepalived.install

master-conf:
  file.managed:
    - name: /etc/keepalived/keepalived.conf
    - source: salt://cluster/keepalived/files/master.conf.j2
    - template: jinja


start-master:
  service.running:
    - name: keepalived
    - neable: true
    
