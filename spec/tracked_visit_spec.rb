require 'spec_helper'

describe "tracking visits" do

  before(:all) do
    @loc = Location.create! name: 'The Palms'
  end

  it 'should record a visit' do
    
    u = User.create! name: 'blah'

    TrackedVisit.create! user_id: u.id, location_id: @loc.id, buy_in: 20.00, cash_out: 43.21
    
    t = TrackedVisit.all(user_id: u.id)
    
    p t
    
    t.size.should == 1
    
    t[0]['buy_in'].should eql 20.00
    
    t[0]['cash_out'].should eql 43.21
    
    # not the best test, but roughly ok
    (DateTime.now.to_i - t[0]['visit_date'].to_i).should == 0
  end

  it "should return all visits for a given user and location" do
    u = User.create! name: 'Jane Doe'
    3.times do |x|
      TrackedVisit.create! user_id: u.id, location_id: @loc.id, buy_in: 20.00, cash_out: x * 1.0
    end
    TrackedVisit.all( user_id: u.id, location_id: @loc.id).size.should == 3
  end

end