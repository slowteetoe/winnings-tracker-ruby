require 'spec_helper'

describe  WinningsTracker::APIv1 do
  include Rack::Test::Methods

  def app
    WinningsTracker::APIv1
  end

  it "should serve up a 404 for a link that doesn't exist" do
    get '/locations'
    last_response.status.should eql 404
  end

  it "should run" do
    get '/v1/locations'
    last_response.status.should eql 200
    last_response.headers["Content-type"].should eql "application/json"
  end
end