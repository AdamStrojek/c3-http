// Simple HTTP example in C3
//
// How to compile:
// c3c compile simplehttp
//
// How to run:
// ./simplehttp www.google.com

import std::io;
import std::net::tcp;
import libc;

fn void! main(String[] args) {
    if(args.len < 2) {
        io::printn("Usage:");
        io::printfn("    %s HOST [PORT]", args[0]);
        return;
    }

    String method = "GET";
    String path   = "/";
    String host   = args[1];
    int    port   = 80;
    if(args.len == 3) port = libc::atoi(args[2]);

    TcpSocket soc = tcp::connect(host, port)!;
    soc.set_keepalive(false)!!;

    DString req;
    req.appendf("%s %s HTTP/1.1\r\n", method, path);
    req.appendf("Host: %s\r\n", host);
    req.append("Connection: close\r\n");
    req.append("\r\n");

    usz len = soc.write(req.str_view())!;
    io::printfn("Request sent to: %s:%d (len: %d)", host, port, len);

    char[] buf = mem::new_array(char, 255);

    io::printn("Response:");
    while((len = soc.read(buf)!) != 0) {
        io::print(buf[:len]);
    }
    io::printn();
}
