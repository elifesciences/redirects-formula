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
