class Location
  include DataMapper::Resource

  property :id,    Serial
  property :name,  String, unique: true
  has n, :tracked_visit

end