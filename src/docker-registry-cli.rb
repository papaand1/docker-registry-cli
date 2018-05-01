require "net/http"
require "uri"
require "json"
require "./cmdline-option-parser"

# APIs
# https://github.com/docker/distribution/blob/master/docs/spec/api.md
#
# Method URL                            FunctionName
# GET    /v2/<image>/tags/list          getAllTags
# GET    /v2/<image>/manifests/<tag>    getDigest
# DELETE /v2/<image>/manifests/<digest> deleteImage
# GET    /v2/_catalog                   getImages

def query(url, request)
  begin
    res = Net::HTTP.start(url.host, url.port) do |http|
      http.request(request)
    end
  rescue => e
    $stderr.puts "ERROR: " + e.to_s
    exit
  end

  if !(200 <= res.code.to_i && res.code.to_i < 300)
    $stderr.puts "ERROR: failed to request: status code = " + res.code.to_s
    exit
  end

  return res
end

def getAllTag(url, image)
  u = URI.parse(url + "/v2/" + image + "/tags/list")

  req = Net::HTTP::Get.new(u.path)
  res = query(u, req)

  return JSON.parse(res.body)
end

def getDigest(url, image, tag)
  u = URI.parse(url + "/v2/" + image + "/manifests/" + tag)

  req = Net::HTTP::Get.new(u.path)
  req["Accept"] = "application/vnd.docker.distribution.manifest.v2+json"
  res = query(u, req)

  return res.header["Docker-Content-Digest"]
end

def getAllImage(url)
  u = URI.parse(url + "/v2/_catalog")

  req = Net::HTTP::Get.new(u.path)
  res = query(u, req)

  return JSON.parse(res.body)
end

def deleteTag(url, image, digest)
  u = URI.parse(url + "/v2/" + image + "/manifests/" + digest)

  req = Net::HTTP::Delete.new(u.path)
  query(u, req)
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

    case val[:command]
    when "getImages"
      images = getAllImage(url)
      images["repositories"].each do |img|
        puts img
      end
    when "getTags"
      image = val[:args][0]
      tags = getAllTag(url, image)
      if !tags.has_key?("tags")
        $stderr.puts "There is no tags in image = " + image
        exit 1
      end
      tags["tags"].each do |tag|
        puts tag
      end
    when "delete"
      image = val[:args][0]
      tags = Array.new
      if val[:option][:tags]
        tags = val[:option][:tags]
      else
        ts = getAllTag(url, image)
        if !ts.has_key?("tags")
          $stderr.puts "There is no tags in image = " + image
          exit 1
        else
          tags = ts["tags"]
        end
      end
      tags.each do |tag|
        digest = getDigest(url, image, tag)
        if !digest
          $stderr.puts image + "has no such tag (" + tag + ")"
          exit 1
        end
        deleteTag(url, image, digest)
      end
    end
  end
end
