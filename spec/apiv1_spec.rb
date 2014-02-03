require 'spec_helper'

describe  WinningsTracker::APIv1 do
  include Rack::Test::Methods

  def app
    WinningsTracker::APIv1
  end

  it "should run" do
    get '/locations'
    last_response.should eql "wtf"
  end
end