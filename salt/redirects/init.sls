{% if pillar.elife.webserver.app == "nginx" %}
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

{% else %}

caddy-configuration:
    file.managed:
        - name: /etc/caddy/sites.d/redirects
        - source: salt://redirects/config/etc-caddy-sites.d-redirects
        - makedirs: True
        - template: jinja
        - require_in:
            - caddy-validate-config
        - listen_in:
            - service: caddy-server-service
{% endif %}
