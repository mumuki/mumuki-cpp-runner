FROM ubuntu
MAINTAINER Franco Leonardo Bulgarelli
RUN apt-get update
RUN apt-get install build-essential -y
RUN apt-get install g++ -y
RUN apt-get install libcppunit-dev -y
