backend default {
    .host = "127.0.0.1";
    .port = "80";
}

sub vcl_recv {
    if (req.url ~ "^/static") {
        unset req.http.cookie;
    }
}
