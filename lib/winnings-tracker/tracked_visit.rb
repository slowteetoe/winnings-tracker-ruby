class TrackedVisit
  include DataMapper::Resource
  property :id, Serial
  property :visit_date, DateTime, required: true, default: ->(p,s) { DateTime.now }
  property :buy_in, Decimal, required: true, default: 0.00
  property :cash_out, Decimal, required: true, default: 0.00
  belongs_to :location
  belongs_to :user
end