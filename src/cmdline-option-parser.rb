require 'optparse'

URL_DESC="target URL of docker distribution(default: http://localhost:5000)"
IMAGE_DESC="target docker image name"
TAG_DESC="taget tags of docker image(Ex. --tags='v1.0','v1.3' *target is all tag if you do not set this)"

def OptionParser(args)
  option = { :url => "http://localhost:5000"}
  scriptName = File.basename($0)
  banner = <<"EOS"
Usage: ruby #{scriptName} <command> [options]

Command:
  getImages: get image of docker distribution
  getTags:   get tags of docker image
  delete:    delete tag of image
EOS

  OptionParser.new(banner) do |opt|
    opt.order!(args)
    if args.empty? then
      return {err: opt.help}
    end
  end

  subparsers = Hash.new do |h,k|
    return {err: "no such subcommand: #{k}"}
  end

  subparsers['getImages'] = OptionParser.new do |opt|
    opt.on("--url=VALUE",URL_DESC){|v| option[:url]=v}
  end

  subparsers['getTags'] = OptionParser.new do |opt|
    opt.on("--url=VALUE",URL_DESC){|v| option[:url]=v}
    opt.on("--image=VALUE",IMAGE_DESC){|v| option[:image]=v}
  end

  subparsers['delete'] = OptionParser.new do |opt|
    opt.on("--url=VALUE",URL_DESC){|v| option[:url]=v}
    opt.on("--image=VALUE",IMAGE_DESC){|v| option[:image]=v}
    opt.on("--tags=VALUE",Array,TAG_DESC){|v| option[:tags]=v}
  end

  command=args[0]
  subparsers[args.shift].parse!(args)

  return {err: nil, command: command, option: option}
end

