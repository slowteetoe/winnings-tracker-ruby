class User
  include DataMapper::Resource
  property :id, Serial
  property :name, String
  has n, :tracked_visit
end