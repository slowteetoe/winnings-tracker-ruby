require 'grape'
require 'dm-core'
require 'dm-migrations'
require 'dm-serializer'

DataMapper::Logger.new($stdout, :debug)
logger = Logger.new($stdout)

uri = "sqlite3://#{Dir.pwd}/winnings.db"

DataMapper.setup(:default, uri)

class Location
  include DataMapper::Resource
  property :id,    Serial
  property :name,  String, unique: true
  has n, :tracked_visit
end

class TrackedVisit
  include DataMapper::Resource
  property :id, Serial
  property :visit_date, DateTime, required: true, default: ->(p,s) { DateTime.now }
  property :buy_in, Decimal, default: 0.00
  property :cash_out, Decimal, default: 0.00
  belongs_to :location
end

DataMapper.finalize
DataMapper.auto_migrate!

module WinningsTracker
  class APIv1 < Grape::API

    version 'v1', using: :path
    format :json
    default_format :json

    resources :locations do

      desc "Create a location."
      params do
        requires :name, type: String, desc: "Name of the location"
      end
      post do
        logger.info "Trying to create location for #{params[:name]}"
        Location.create({ :name => params[:name]})
      end
      get do
        Location.all
      end
    end

  end
end
