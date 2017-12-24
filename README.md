docker-registry-cli
====

# Overview
docker-registry-cli is command line tool of docker distribution.  
docker-registry-cli provides easy operation from a command line.

## Usage
If you want to use docker-registry-cli right away there are two options:
##### You have a working [Ruby environment].
```
cd src
ruby docker-registry-cli.rb <command> [options] 
```
##### You have a working [Docker environment].
```
./run.sh <command> [options]
```

## Program commands and options
This program has following 3 commands.  
\* If you set DOCKER_REGISTRY_URL in your OS environment variable, you don't have to use --url option.  
(Ex. export DOCKER_REGISTRY_URL="http://localhost:5000")

- ```getImages```: This command gets image list from docker distribution.  
  - options:  
    --url=<url> (default: http://localhost:5000)
- ```getTags```: This command gets tags of docker image  
  - options:  
    --url=<url> (default: http://localhost:5000)  
    --image=<image> (\*This value is necessary)  
- ```delete```: This command delete image  
  - options:  
    --url=<url> (default: http://localhost:5000)  
    --image=<image> (\*This value is necessary)  
    --tags=<deleting tag list> (delete all tag if you do not set this option)  

## TODO
error handling

## Author
Shunsuke Miyoshi

## License
This software is released under the MIT License, see [LICENSE.txt](./LICENSE.txt).