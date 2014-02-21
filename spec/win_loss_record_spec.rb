require 'spec_helper'

describe "tallying wins and losses" do
  before(:all) do
    @l1 = Location.create! name: "The Rio"
    @l2 = Location.create! name: "The D"
  end

  it "should handle winning" do
    u = User.create! name: "Ima Win"
    TrackedVisit.create! user_id: u.id, location_id: @l1.id, buy_in: 20.00, cash_out: 20.00
    TrackedVisit.create! user_id: u.id, location_id: @l1.id, buy_in: 20.00, cash_out: 100.00
    TrackedVisit.create! user_id: u.id, location_id: @l2.id, buy_in: 20.00, cash_out: 0.00
    
    rec = WinLossRecord.for_user u.id
    rec.total_buy_in.should == 60.00
    rec.total_cash_out.should == 120.00
    rec.net.should == 60.00
  end

  it "should handle losing" do
    u = User.create! name: "Whata Loser"
    TrackedVisit.create! user_id: u.id, location_id: @l1.id, buy_in: 100.00, cash_out: 0.00
    TrackedVisit.create! user_id: u.id, location_id: @l1.id, buy_in: 20.00, cash_out: 20.00
    TrackedVisit.create! user_id: u.id, location_id: @l2.id, buy_in: 20.00, cash_out: 0.00
    
    rec = WinLossRecord.for_user u.id
    rec.total_buy_in.should == 140.00
    rec.total_cash_out.should == 20.00
    rec.net.should == -120.00
  end

end