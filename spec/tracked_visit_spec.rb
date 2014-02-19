require 'spec_helper'

describe "tracking visits" do

  before(:all) do
    User.create! name: "john doe"
    Location.create! name: "The Palms"
  end

  it "should record a visit" do
    u = User.first
    TrackedVisit.create! user_id: u.id, location_id: 1, buy_in: 20.00, cash_out: 43.21
    t = TrackedVisit.all(user_id: u.id)
    t.size.should == 1
    t[0]["buy_in"].should eql 20.00
    t[0]["cash_out"].should eql 43.21
    # not the best test, but roughly ok
    (DateTime.now.to_i - t[0]["visit_date"].to_i).should == 0
  end

end