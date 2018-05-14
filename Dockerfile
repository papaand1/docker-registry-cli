FROM ruby:2.4.3-alpine3.7

ADD src/cmdline-option-parser.rb /usr/bin/cmdline-option-parser.rb
ADD src/docker-registry-cli.rb /usr/bin/docker-registry-cli
RUN chmod 755 /usr/bin/docker-registry-cli

