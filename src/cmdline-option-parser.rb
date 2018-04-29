require "optparse"

URL_DESC = "target URL of docker distribution(default: http://localhost:5000)"
IMAGE_DESC = "target docker image name"
TAG_DESC = "taget tags of docker image(Ex. --tags='v1.0','v1.3' *target is all tag if you do not set this)"

def OptionParser(args)
  banner = <<"EOS"
Usage: ruby #{File.basename($0)} <command> [options]

Command:
  getImages: get image of docker distribution
  getTags:   get tags of docker image
  delete:    delete tag of image

Global options:
EOS

  command = args.shift
  option = Hash.new
  opts = OptionParser.new(banner)
  opts.on("--url=VALUE", URL_DESC) { |v| option[:url] = v }
  required_args_num = -1

  case command
  when "getImages"
    opts.banner = <<"EOS"
Usage: ruby #{File.basename($0)} getImages [options]

Options:
EOS
    required_args_num = 0
  when "getTags"
    opts.banner = <<"EOS"
Usage: ruby #{File.basename($0)} getTags <container-image-name> [options]

Options:
EOS
    required_args_num = 1
  when "delete"
    opts.banner = <<"EOS"
Usage: ruby #{File.basename($0)} delete <container-image-name> [options]

Options:
EOS
    opts.on("--tags=VALUE", Array, TAG_DESC) { |v| option[:tags] = v }
    required_args_num = 1
  end

  begin
    opts.parse!(args)
  rescue OptionParser::InvalidOption => e
    return {err: e.to_s}
  end

  if args.length != required_args_num
    return {err: opts.help}
  else
    return {err: nil, command: command, option: option, args: args}
  end
end
