#!/usr/bin/env ruby

require "net/http"
require "uri"
require "json"
require __dir__ + "/cmdline-option-parser"

# APIs
# https://github.com/docker/distribution/blob/master/docs/spec/api.md
#
# Method URL                            FunctionName
# GET    /v2/<image>/tags/list          getAllTags
# GET    /v2/<image>/manifests/<tag>    getDigest
# DELETE /v2/<image>/manifests/<digest> deleteImage
# GET    /v2/_catalog                   getImages

class DockerResitryCLI
  def initialize(url)
    # todo(url check)
    @url = url
  end

  def getAllImage()
    u = URI.parse(@url + "/v2/_catalog")
  
    req = Net::HTTP::Get.new(u.path)
    res = query(u, req)
  
    return JSON.parse(res.body)["repositories"]
  end

  def getAllTag(image)
    u = URI.parse(@url + "/v2/" + image + "/tags/list")
  
    req = Net::HTTP::Get.new(u.path)
    res = query(u, req)
  
    tags = JSON.parse(res.body)
    raise "There is no tags in image = " + image if !tags.has_key?("tags")
    return tags["tags"]
  end

  def delete(image, tags)
    tags.each do |tag|
      digest = getDigest(image, tag)
      raise image + "has no such tag (" + tag + ")" if !digest

      u = URI.parse(@url + "/v2/" + image + "/manifests/" + digest)
      req = Net::HTTP::Delete.new(u.path)
      query(u, req)
    end
  end

  private
    def query(url, request)
      res = Net::HTTP.start(url.host, url.port) do |http|
        http.request(request)
      end
    
      if !(200 <= res.code.to_i && res.code.to_i < 300)
        raise "failed to request: status code = " + res.code.to_s
      end
    
      return res
    end

    def getDigest(image, tag)
      u = URI.parse(@url + "/v2/" + image + "/manifests/" + tag)
    
      req = Net::HTTP::Get.new(u.path)
      req["Accept"] = "application/vnd.docker.distribution.manifest.v2+json"
      res = query(u, req)
    
      return res.header["Docker-Content-Digest"]
    end
end

# Main Process
if __FILE__ == $0 then
  val = OptionParser(ARGV)
  if val[:err]
    $stderr.puts val[:err]
    exit 1
  else
    url = val[:option][:url]
    # if do not set --url option
    if !url
      # see environment
      if ENV["DOCKER_REGISTRY_URL"]
        url = ENV["DOCKER_REGISTRY_URL"]
      else
        url = "http://localhost:5000"
      end
    end

    cli = DockerResitryCLI.new(url)

    begin
      case val[:command]
      when "getImages"
        cli.getAllImage().each do |image|
          puts image
        end
      when "getTags"
        image = val[:args][0]
        tags = cli.getAllTag(image)

        tags.each do |tag|
          puts tag
        end
      when "delete"
        image = val[:args][0]
        tags = Array.new
        if val[:option][:tags]
          tags = val[:option][:tags]
        else
          tags = cli.getAllTag(image)
        end
        cli.delete(image, tags)
      end
    rescue => e
      puts "ERROR: " + e.to_s
    end
  end
end
