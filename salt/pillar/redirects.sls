redirects:
    host: localhost

elife:
    webserver:
        app: caddy

    # use the 'redirects' certificates rather than the default 'elife' ones
    certificates:
        app: redirects

    swap:
        size: 1024 # MB
