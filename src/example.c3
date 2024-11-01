// Simple HTTP example in C3
//
// How to compile:
// c3c compile example.c3 client.c3
//
// How to run:
// ./simplehttp www.google.com
module http::example;

import std::io;
import std::net::tcp;
import libc;

import http::url;
import http::request;

fn void! main(String[] args) {
    if(args.len < 2) {
        io::printn("Usage:");
        io::printfn("    %s URL", args[0]);
        return;
    }

    Url url = url::parse_url(args[1]);
    String method = "GET";

    TcpSocket soc = tcp::connect(url.host, url.port)!;
    soc.set_keepalive(false)!;

    HttpRequest req = {
        .method = "GET",
        .host = url.host,
        .resource = url.path,
    };


    io::printn("Request:");
    io::printn(req.generate_str());

    usz len = soc.write(req.generate_str())!;
    io::printfn("Request sent to: %s:%d (len: %d)", url.host, url.port, len);

    char[] buf = mem::new_array(char, 255);

    io::printn("Response:");
    // while((len = soc.read(buf)!) != 0) {
    //     io::print(buf[:len]);
    // }
    io::printn();
}
