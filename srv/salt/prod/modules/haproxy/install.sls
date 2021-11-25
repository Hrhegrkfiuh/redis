include:
  - haproxy.rsyslog
  
unzip-pkg:
  archive.extracted:
    - name: /usr/local
    - source: salt://haproxy/files/haproxy-{{ pillar['haproxy_version'] }}.tar.gz

install-haproxy: 
  pkg.installed: 
    - pkgs:
      - make
      - gcc
      - gcc-c++
      - pcre-devel
      - bzip2-devel
      - openssl-devel
      - systemd-devel


haproxy-user:
  user.present:
    - name: haproxy
    - shell: /sbin/nologin
    - createhome: false
    - system: true
    
    
salt://haproxy/files/install.sh.j2:
  cmd.script:
    - template: jinja
    - require:
      - archive: unzip-pkg
    - unless: test -d {{ pillar['haproxy_install_path'] }}
       
       
set-variable:
  file.managed:
    - name: /etc/profile.d/haproxy.sh
    - source: salt://haproxy/files/haproxy.sh
    
    
/usr/bin/haproxy:
  file.symlink:
    - target: {{ pillar['haproxy_install_path'] }}/sbin/haproxy


/etc/sysctl.conf:
  file.append:
    - text:
      - 'net.ipv4.ip_nonlocal_bind = 1'
      - 'net.ipv4.ip_forward = 1'
  cmd.run:
    - name: sysctl -p


{{ pillar['haproxy_install_path'] }}/conf: 
  file.directory: 
    - user: root 
    - group: root 
    - mode: 755
    - makedirs: true


{{ pillar['haproxy_install_path'] }}/conf/haproxy.cfg:
  file.managed:
    - source: salt://haproxy/files/haproxy.cfg.j2
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    

/usr/lib/systemd/system/haproxy.service:
  file.managed:
    - source: salt://haproxy/files/haproxy.service.j2
    - user: root
    - group: root
    - mode: 644
    - template: jinja
    
start-haproxy:
  service.running:
    - name: haproxy.service
    - enable: true
    - reload: true
    - watch: 
      - file: {{ pillar['haproxy_install_path'] }}/conf/haproxy.cfg  
