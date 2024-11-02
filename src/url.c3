module http::url;

import std::io;
import libc;

struct Url {
    String schema;
    String host;
    int port;
    String path;
    String query;
}

fault UrlError {
    URL_MALFORMED
}

enum UrlPart {
    SCHEMA,
    HOST,
    PORT,
    PATH,
    QUERY
}

fn Url parse_url(String url) {
    Url result;

    DString value;

    StringIterator it = url.iterator();

    UrlPart current_part = UrlPart.SCHEMA;

    while( it.has_next() ) {
        Char32 ch = it.next()!!;

        if( (!it.has_next() || ch == ':') && current_part == UrlPart.SCHEMA) {
            result.schema = value.copy_str();
            value.clear();
            current_part = UrlPart.HOST;
        } else if ( (!it.has_next() || ch == '/' || ch == ':') && current_part == UrlPart.HOST) {
            if( value.len() > 0 ) {
                if(ch != '/' && ch != ':') value.append_char32(ch);
                result.host = value.copy_str();
                value.clear();
                if(ch != ':') value.append_char32(ch);
                current_part = ch == ':' ? UrlPart.PORT : UrlPart.PATH;
            }
        } else if ( (!it.has_next() || ch == '/') && current_part == UrlPart.PORT) {
            result.port = value.str_view().to_int()!!;
            value.clear();
            value.append_char32(ch);
            current_part = UrlPart.PATH;
        } else if ( (!it.has_next() || ch == '?') && current_part == UrlPart.PATH) {
            result.path = value.copy_str();
            value.clear();
            current_part = UrlPart.QUERY;
        } else if ( !it.has_next() && current_part == UrlPart.QUERY) {
            value.append_char32(ch);
            result.query = value.copy_str();
        } else {
            value.append_char32(ch);
        }
    }

    if( result.port == 0 ) {
        result.port = result.schema == "https" ? 443 : 80;
    }

    if( result.path == "" ) {
        result.path = "/";
    }

    return result;
}


fn void! test_parse_url() @test
{
    Url url = parse_url("http://example.com/");
    assert(url.schema == "http", "Wrong protocol, expected http, got %s", url.schema);
    assert(url.host == "example.com", "Wrong host, expected example.com, got %s", url.host);
    assert(url.port == 80, "Wrong port, expected 80, got %d", url.port);
    assert(url.path == "/", "Wrong path, expected /, got %s", url.path);
}

fn void! test_parse_url_no_path() @test
{
    Url url = parse_url("http://example.com");
    assert(url.schema == "http", "Wrong protocol, expected http, got %s", url.schema);
    assert(url.host == "example.com", "Wrong host, expected example.com, got %s", url.host);
    assert(url.port == 80, "Wrong port, expected 80, got %d", url.port);
    assert(url.path == "/", "Wrong path, expected /, got %s", url.path);
}

fn void! test_parse_url_https() @test
{
    Url url = parse_url("https://example.com/");
    assert(url.schema == "https", "Wrong protocol, expected https");
    assert(url.host == "example.com", "Wrong host, expected example.com");
    assert(url.port == 443, "Wrong port, expected 443");
    assert(url.path == "/", "Wrong path, expected /");
}

fn void! test_parse_url_port() @test
{
    Url url = parse_url("http://example.com:8080/");
    assert(url.schema == "http", "Wrong protocol, expected http, got %s", url.schema);
    assert(url.host == "example.com", "Wrong host, expected example.com, got %s", url.host);
    assert(url.port == 8080, "Wrong port, expected 8080, got %d", url.port);
    assert(url.path == "/", "Wrong path, expected /, got %s", url.path);
}


fn void! test_parse_url_path_query() @test
{
    Url url = parse_url("http://example.com/aaa/bbb/ccc?ddd");
    assert(url.schema == "http", "Wrong protocol, expected http, got %s", url.schema);
    assert(url.host == "example.com", "Wrong host, expected example.com, got %s", url.host);
    assert(url.port == 80, "Wrong port, expected 80, got %d", url.port);
    assert(url.path == "/aaa/bbb/ccc", "Wrong path, expected /aaa/bbb/ccc, got %s", url.path);
    assert(url.query == "ddd", "Wrong query, expected ddd, got %s", url.query);
}
