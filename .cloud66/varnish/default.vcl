vcl 4.0;

# Currently, there's a Varnish instance in each app server sitting in front of
# nginx.
#
# nginx runs on port 80, Varnish on 8080, and ELB is set up to route traffic
# to port 8080.
#
# Varnish is configured to have an 'eternal' grace period, meaning cache refresh
# always happens in the background.
#
# Cache is set to expire every 5 minutes.
#
# In addition, Varnish is redirecting all non-HTTPS trafic to HTTPS, and
# redirecting all requests to unbounded.org (without www) to www.unbounded.org.

# Our backend is running on port 80.
backend default {
    .host = "127.0.0.1";
    .port = "80";
}

# Happens before we check if we have this in cache already.
sub vcl_recv {
    # If this isn't requesting www and/or isn't HTTPS, redirect to the proper
    # location (https + www).
    if (req.http.host !~ "www.unbounded.org" ||
        req.http.X-Forwarded-Proto !~ "https") {
        return (synth(750, ""));
    }

    # If this is going to /admin, /users or /downloads, skip the cache.
    # /admin and /users need session cookies.
    # /downloads will result in a redirect and will collect cookies as well.
    if (req.url ~ "^/admin(.*)" ||
        req.url ~ "^/users(.*)" ||
        req.url ~ "^/downloads(.*)" ||
        req.url ~ "^/assets(.*)") {
        return (pass);
    }

    # Skip the cache if there's a session set.
    if (req.http.Cookie ~ "_content_session") {
        return (pass);
    }

    # Otherwise, cache it!

    # Disregard cookies and the Authorization header, which might prevent caching.
    unset req.http.Cookie;
    unset req.http.Authorization;
    return (hash);
}

# Handle the synthetic response we generated for redirecting the user to
# https+www.
sub vcl_synth {
    if (resp.status == 750) {
        set resp.status = 301;
        set resp.http.Location = "https://www.unbounded.org" + req.url;
        return(deliver);
    }
}

# Happens after we have read the response headers from the backend, while
# the response is being set.
sub vcl_backend_response {
    # Don't touch the response if it's coming from one of the exceptions in
    # vcl_recv.
    if (bereq.url ~ "^/admin(.*)" ||
        bereq.url ~ "^/users(.*)" ||
        bereq.url ~ "^/downloads(.*)" ||
        bereq.url ~ "^/assets(.*)") {
        return (deliver);
    }

    # Don't touch it either if the user is logged in.
    if (beresp.http.Set-Cookie ~ "_content_session" ||
        beresp.http.Cookie ~ "_content_session") {
        return (deliver);
    }

    # Otherwise...

    # Cache everything for 5 minutes, ignoring any cache headers.
    set beresp.ttl = 5m;

    # Set a very long grace period.
    set beresp.grace = 365d;

    # Disregard all cookies.
    unset beresp.http.Set-Cookie;

    return (deliver);
}
