FROM ruby:2.4.3-alpine3.7

RUN mkdir -p /myapp
WORKDIR /myapp
ADD src /myapp

