[![Build Status](https://travis-ci.org/alexmitic/is-sl-late-again.svg?branch=master)](https://travis-ci.org/alexmitic/is-sl-late-again)
# is-sl-late-again

`is-sl-late-again` is a webapp that keeps track of how often the trains in Stockholm are late. I am building this mainly to try out the rust framework `actix-web` along with `redis`, `Travis CI` and `AWS EC2`.

## Roadmap (will be updated continually)
- [x] Setup `Travis CI` to test build on each push
- [x] Initial deploy to test `rust` and `actix-web` on `AWS EC2` [demo](http://ec2-18-130-97-250.eu-west-2.compute.amazonaws.com:8080)
- [ ] Implement a `redis` primary storage
- [ ] Set up a service to regularly request SL API and check the status of train trafic 
