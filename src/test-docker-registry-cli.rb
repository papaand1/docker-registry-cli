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

		cli = DockerResitryCLI.new(URL)
		res = cli.getAllImage()
		assert_equal(res,["image1","image2"])
	end

	def test_getAllTag
    WebMock.stub_request(:get, URL + "/v2/image1/tags/list").to_return(
			body: '{"tags": ["v1","v2"]}',
			status: 200,
			headers: { 'Content-Type' =>  'application/json' }
    )
		
		cli = DockerResitryCLI.new(URL)
    res = cli.getAllTag("image1")
    assert_equal(res,["v1","v2"])
	end

	def test_deleteTag
		WebMock.stub_request(:get, URL + "/v2/image1/manifests/v1").to_return(
			status: 200,
			headers: {
				'Content-Type' =>  'application/vnd.docker.distribution.manifest.v1',
				'Docker-Content-Digest' => 'digest1'
			}
    )

    WebMock.stub_request(:delete, URL + "/v2/image1/manifests/digest1").to_return(
			status: 200,
			headers: { 'Content-Type' =>  'application/json' }
    )
		
		cli = DockerResitryCLI.new(URL)
		assert_nothing_raised RuntimeError do
      cli.delete("image1",["v1"])
    end    
  end
end