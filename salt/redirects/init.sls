{% if salt['grains.get']('osrelease') == '18.04' %}
# just a test. this problem only affects redirects so far
# if it works, I'll roll it out to builder-base in a nicer fashion
# https://bugs.launchpad.net/ubuntu/+source/nginx/+bug/1581864
nginx-systemd-hack:
    cmd.run:
        - name: |
            set -e
            mkdir -p /etc/systemd/system/nginx.service.d
            printf "[Service]\nExecStartPost=/bin/sleep 0.1\n" > /etc/systemd/system/nginx.service.d/override.conf
            systemctl daemon-reload
        - unless: # override exists
            - test -e /etc/systemd/system/nginx.service.d/override.conf
        - require_in:
            - nginx-server-service
{% endif %}

nginx-configuration:
    file.managed:
        - name: /etc/nginx/sites-enabled/redirects.conf
        - source: salt://redirects/config/etc-nginx-sites-enabled-redirects.conf
        - template: jinja
        - require:
            - nginx-config
            - nginx-error-pages
        - listen_in:
            - service: nginx-server-service


{% if salt['elife.only_on_aws']() %}
redirects-web-certificate-file:
    file.managed:
        - name: /etc/certificates/redirects/certificate.crt
        - source: salt://redirects/config/etc-certificates-redirects-certificate.crt
        - makedirs: True
        - require:
            - web-certificates-dir

redirects-web-private-key:
    file.managed:
        - name: /etc/certificates/redirects/privkey.pem
        - source: salt://redirects/config/etc-certificates-redirects-privkey.pem
        - makedirs: True
        - require:
            - web-certificates-dir

redirects-web-fullchain-key:
    file.managed:
        - name: /etc/certificates/redirects/fullchain.pem
        - source: salt://redirects/config/etc-certificates-redirects-fullchain.pem
        - makedirs: True
        - require:
            - web-certificates-dir

redirects-web-complete-cert:
    cmd.run:
        - name: cat certificate.crt fullchain.pem > certificate.chained.crt
        - cwd: /etc/certificates/redirects/
        - require:
            - redirects-web-fullchain-key
            - redirects-web-certificate-file

{% endif %}
