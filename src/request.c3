module http::request;

struct HttpRequest {
    String method;
    String host;
    String resource;
    // String headers;
}

fn String HttpRequest.generate_str(HttpRequest request) {
    DString result;

    result.appendf("%s %s HTTP/1.1\r\n", request.method, request.resource);
    result.appendf("Host: %s\r\n", request.host);
    result.append("Connection: close\r\n");
    result.append("\r\n");

    return result.copy_str();
}
