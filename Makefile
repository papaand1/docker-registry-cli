drCLIImage := "docker-registry-cli"
drCLIVersion := "1.0"

all:
	

build:
	docker build -t $(drCLIImage):$(drCLIVersion) .

install:
	cp src/cmdline-option-parser.rb /usr/local/bin/cmdline-option-parser.rb
	cp src/docker-registry-cli.rb /usr/local/bin/docker-registry-cli
	chmod 755 /usr/local/bin/docker-registry-cli

uninstall:
	rm -f /usr/local/bin/cmdline-option-parser.rb
	rm -f /usr/local/bin/docker-registry-cli

test:
	cd src; \
	bundle install; \
	ruby test-cmdline-option-parser.rb; \
	ruby test-docker-registry-cli.rb
