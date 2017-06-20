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
web-certificate-file:
    file.managed:
        - name: /etc/certificates/certificate.crt
        - source: salt://redirects/config/etc-certificates-redirects-certificate.crt
        - makedirs: True
        - require:
            - web-certificates-dir

web-private-key:
    file.managed:
        - name: /etc/certificates/privkey.pem
        - source: salt://redirects/config/etc-certificates-redirects-privkey.pem
        - makedirs: True
        - require:
            - web-certificates-dir

web-fullchain-key:
    file.managed:
        - name: /etc/certificates/fullchain.pem
        - source: salt://redirects/config/etc-certificates-redirects-fullchain.pem
        - makedirs: True
        - require:
            - web-certificates-dir
{% endif %}
