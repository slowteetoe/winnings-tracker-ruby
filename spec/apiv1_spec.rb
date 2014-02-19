require 'spec_helper'

describe  WinningsTracker::APIv1 do
  include Rack::Test::Methods

  def app
    WinningsTracker::APIv1
  end

  before(:all) do
    Location.create! name: "Station's Casino"
  end

  it "should serve up a 404 for a link that doesn't exist" do
    get '/locations'
    last_response.status.should eql 404
  end

  it "should list locations" do
    get '/v1/locations'
    last_response.status.should eql 200
    last_response.headers["Content-type"].should eql "application/json"
    locations = JSON.parse(last_response.body)
    locations.size.should > 0
  end

  it "should create a new location" do
    get '/v1/locations'
    starting = JSON.parse(last_response.body).size

    post '/v1/locations', { name: "Smith's" }

    get '/v1/locations'
    JSON.parse(last_response.body).size.should eql starting + 1
  end

  it "should retrieve information about a specific location" do
    get '/v1/locations/1'
    last_response.status.should == 200
    loc = JSON.parse last_response.body
    loc.fetch("id").should == 1
    loc.fetch("name").should eql "Station's Casino"
  end

end