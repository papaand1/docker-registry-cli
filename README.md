docker-registry-cli
====

# Overview
This program is command line tool of docker distribution.

## Usage

install ruby

```
cd src
ruby docker-registry-cli.rb <command> [options] 
```

or if you installed docker

```
./run.sh <command> [options]
```

## Program commands and options
* getImages
  This command gets image list from docker distribution.
  options:
    --url=<url> (default: http://localhost:5000)
* getTags
  This command gets tags of docker image
  options:
    --url=<url> (default: http://localhost:5000)
    --image=<image> (\*This value is necessary)
* delete
  This command delete image
  options:
    --url=<url> (default: http://localhost:5000)
    --image=<image> (\*This value is necessary)
    --tags=<deleting tag list> (delete all tag if you do not set this option)

## TODO
error handling
