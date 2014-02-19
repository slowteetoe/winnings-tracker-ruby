class TrackedVisit
  include DataMapper::Resource
  property :id, Serial
  property :visit_date, DateTime, required: true, default: ->(p,s) { DateTime.now }
  property :buy_in, Decimal, default: 0.00
  property :cash_out, Decimal, default: 0.00
  belongs_to :location
end