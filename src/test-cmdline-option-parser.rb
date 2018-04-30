require 'test/unit'
require './cmdline-option-parser'

class TestCmdOption < Test::Unit::TestCase
  def test_empty_option
    assert(Array.new, true)
  end

  def test_getImages
    # use no option
    args = ["getImages"]
    assert(args, false)

    # use --url option
    args = ["getImages", "--url=http://example.com"]
    assert(args, false)

    # use invalied option
    args = ["getImages", "--test"]
    assert(args, true)

    # use image name
    args = ["getImages", "image-name"]
    assert(args, true)
  end

  def test_getTags
    # use no args
    args = ["getTags"]
    assert(args, true) 

    # use --url option and image name
    args = ["getTags", "test-image", "--url=http://example.com"]
    assert(args, false)

    # change order
    args = ["getTags", "--url=http://example.com", "test-image"]
    assert(args, false)
  end

  def test_delete
    # use no args
    args = ["delete"]
    assert(args, true) 

    # use --url option and image name
    args = ["delete", "test-image", "--url=http://example.com"]
    assert(args, false)

    # change order
    args = ["delete", "--url=http://example.com", "test-image"]
    assert(args, false)
  end

  private
    def assert(args, req_failed)
      ret = OptionParser(args)
      if req_failed then
        assert_not_nil ret[:err]
      else
        assert_nil ret[:err]
      end
    end
end 
