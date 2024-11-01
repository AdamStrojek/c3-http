// Simple HTTP example in C3
//
// How to compile:
// c3c compile example.c3 client.c3
//
// How to run:
// ./simplehttp www.google.com
module http::example;

import std::io;
import libc;

import http::url;
import http::request;
import http::client;


fn void! main(String[] args) {
    if(args.len < 2) {
        io::printn("Usage:");
        io::printfn("    %s URL", args[0]);
        return;
    }

    Url url = url::parse_url(args[1]);
    String method = "GET";

    HttpRequest req = {
        .method = HttpMethod.GET,
        .url = url,
    };

    HttpClient client;

    io::printn("Request:");
    io::printn(req.generate_str());
    io::printn();

    io::printn("Response:");
    io::printn(client.request(req)!);
    io::printn();
}
