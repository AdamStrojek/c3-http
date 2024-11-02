module http::request;

import http::url;

struct HttpRequest {
    HttpMethod method;
    Url url;
}

enum HttpMethod {
    GET,
    HEAD,
    POST,
    PUT,
    DELETE,
    CONNECT,
    OPTIONS,
    TRACE,
    PATCH,
}

fn String HttpRequest.generate_str(request) {
    DString result;

    result.appendf("%s %s HTTP/1.1\r\n", request.method, request.url.path);
    result.appendf("Host: %s\r\n", request.url.host);
    result.append("Connection: close\r\n");
    result.append("\r\n");

    return result.copy_str();
}
