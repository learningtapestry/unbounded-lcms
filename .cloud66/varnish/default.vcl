vcl 4.0;

# Default backend definition. Set this to point to your content server.
backend default {
    .host = "127.0.0.1";
    .port = "80";
}

# Happens before we check if we have this in cache already.
sub vcl_recv {
    if (req.http.host !~ "www.unbounded.org" || req.http.X-Forwarded-Proto !~ "https") {
        return (synth(750, ""));
    }
    if (req.url ~ "^/admin(.*)" || req.url ~ "^/users(.*)" || req.url ~ "^/downloads(.*)") {
        return (pass);
    }
    unset req.http.Cookie;
    unset req.http.Authorization;
    return (hash);
}

sub vcl_synth {
    if (resp.status == 750) {
        set resp.status = 301;
        set resp.http.Location = "https://www.unbounded.org" + req.url;
        return(deliver);
    }
}

# Happens after we have read the response headers from the backend.
sub vcl_backend_response {
    if (bereq.url ~ "^/admin(.*)" || bereq.url ~ "^/users(.*)" || bereq.url ~ "^/downloads(.*)") {
        return (deliver);
    }

    # Cache everything for 5 minutes, ignoring any cache headers.
    set beresp.ttl = 5m;
    set beresp.grace = 365d;
    unset beresp.http.Set-Cookie;
    return (deliver);
}
