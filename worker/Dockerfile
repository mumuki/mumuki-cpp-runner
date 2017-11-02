FROM alpine
MAINTAINER Franco Leonardo Bulgarelli

RUN apk add --no-cache build-base
RUN apk add --no-cache cppunit-dev

COPY runcppunit.sh /bin/runcppunit
RUN chmod u+x /bin/runcppunit
