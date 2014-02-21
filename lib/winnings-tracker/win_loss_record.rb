
class WinLossRecord
  attr_accessor :total_buy_in, :total_cash_out

  def net
    total_cash_out.to_f - total_buy_in.to_f
  end

  def initialize( total_buy_in, total_cash_out )
    self.total_buy_in = total_buy_in
    self.total_cash_out = total_cash_out
  end

  def self.for_user(user_id)
    b,c = TrackedVisit.all(user_id: user_id).aggregate( :buy_in.sum, :cash_out.sum )
    WinLossRecord.new( b, c )
  end 
end