require 'grape'
require 'dm-core'
require 'dm-migrations'
require 'dm-serializer'

DataMapper::Logger.new($stdout, :debug)
uri = (ENV["DB_URL"] || "sqlite3://#{Dir.pwd}/winnings-test.db")

DataMapper.setup(:default, uri)

require_relative 'tracked_visit.rb'
require_relative 'location.rb'

DataMapper.finalize
DataMapper.auto_migrate!


module WinningsTracker
  class APIv1 < Grape::API
    logger = Logger.new($stdout)

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

      desc "List known locations"
      get do
        Location.all
      end

      desc "Find a specific location by id"
      get '/:id' do
        Location.first(id: params[:id])
      end

    end

  end
end
