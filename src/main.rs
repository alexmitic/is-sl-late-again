extern crate actix_web;
use actix_web::{server, App, HttpRequest};

fn hello(_req: &HttpRequest) -> &'static str {
    "Hello World"
}

fn main() {
    server::new(|| App::new().resource("/", |r| r.f(hello)))
        .bind("127.0.0.1:8088")
        .unwrap()
        .run();
}

#[cfg(test)]
mod tests {

    use actix_web::test::TestRequest;
    use actix_web::Body;
    use actix_web::Binary;
    use hello;
    use std::str;

    #[test]
    fn _hello() {
        let resp = TestRequest::default().run(&hello).unwrap();
        
        if let Body::Binary(Binary::Slice(content)) = resp.body() {
            assert_eq!(str::from_utf8(content).unwrap(), "Hello World");
        }
    }
}