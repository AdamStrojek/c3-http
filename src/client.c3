module http::client;

import std::net::tcp;

import http::request;


struct HttpClient {
    TcpSocket socket;
}

fn String! HttpClient.request(client, HttpRequest request) {
    client.socket = tcp::connect(request.url.host, request.url.port)!;
    client.socket.set_keepalive(false)!;

    usz len = client.socket.write(request.generate_str())!;

    DString response;

    char[] buf = mem::new_array(char, 255);
    while((len = client.socket.read(buf)!) != 0) {
        response.append(buf[:len]);
    }

    return response.copy_str();
}
