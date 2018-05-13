docker-registry-cli
====

# Overview
docker-registry-cli is command line tool of docker registry.  
docker-registry-cli provides easy operation from a command line.  
Please see samples in Program commands and options section.

## Usage
If you want to use docker-registry-cli right away there are two options:
##### You have a working [Ruby environment].
```
cd src
ruby docker-registry-cli.rb <command> [options] 
```
##### You have a working [Docker environment].
```
docker pull smiyoshi/docker-registry-cli  
docker run -it --rm smiyoshi/docker-registry-cli ruby docker-registry-cli.rb <command> [options]  
```

## Program commands and options
This program has following 3 commands.  
\* If you set DOCKER_REGISTRY_URL in your OS environment variable, you don't have to use --url option.  
(Ex. export DOCKER_REGISTRY_URL="http://localhost:5000")

- ```getImages```: This command gets image list from docker registry.  
  - options:  
    --url=\<url\> (default: http://localhost:5000)
  - sample:
```
$ ruby docker-registry-cli.rb getImages --url="http://192.168.0.1:5000"
sample
myruby
```
- ```getTags```: This command gets tags of docker image  
  - options:  
    --url=\<url\> (default: http://localhost:5000)  
  - sample:
```
$ ruby docker-registry-cli.rb getTags sample --url="http://192.168.0.1:5000"
v1.0
v2.0
```
- ```delete```: This command delete image  
  - options:  
    --url=\<url\> (default: http://localhost:5000)  
    --tags=\<deleting tag list\> (delete all tag if you do not set this option)
  - sample:
```
$ ruby docker-registry-cli.rb delete sample --url="http://192.168.0.1:5000"
```

## TODO
error handling

## Author
Shunsuke Miyoshi

## License
This software is released under the MIT License, see [LICENSE.txt](./LICENSE.txt).
