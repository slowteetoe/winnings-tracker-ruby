
class WinLossRecord
  attr_accessor :total_buy_in, :total_cash_out

  def net
    total_cash_out.to_f - total_buy_in.to_f
  end

  def initialize( total_buy_in, total_cash_out )
    self.total_buy_in = total_buy_in.to_f
    self.total_cash_out = total_cash_out.to_f
  end

  def self.for_user(user_id)
    buy_in, cash_out = TrackedVisit.all(user_id: user_id).aggregate( :buy_in.sum, :cash_out.sum )
    WinLossRecord.new( buy_in, cash_out )
  end 
end