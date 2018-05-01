require 'webmock'
require 'test/unit'
require './docker-registry-cli'

WebMock.enable!
URL = "http://localhost:5000"

class TestDockerRegistryCLI < Test::Unit::TestCase
	def test_getAllImage
		WebMock.stub_request(:get, URL + "/v2/_catalog").to_return(
			body: '{"repositories": ["image1","image2"]}',
			status: 200,
			headers: { 'Content-Type' =>  'application/json' }
		)

		res = getAllImage(URL)
		assert_equal(res["repositories"],["image1","image2"])
	end

	def test_getAllTag
    WebMock.stub_request(:get, URL + "/v2/image1/tags/list").to_return(
			body: '{"tags": ["v1","v2"]}',
			status: 200,
			headers: { 'Content-Type' =>  'application/json' }
    )
    
    res = getAllTag(URL,"image1")
    assert_equal(res["tags"],["v1","v2"])
	end

  def test_deleteTag
    WebMock.stub_request(:delete, URL + "/v2/image1/manifests/digest1").to_return(
			status: 200,
			headers: { 'Content-Type' =>  'application/json' }
    )
    
    assert_nothing_raised RuntimeError do
      deleteTag(URL,"image1","digest1")
    end    
  end
end