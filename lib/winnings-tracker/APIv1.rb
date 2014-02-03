module WinningsTracker
  class APIv1 < Grape::API
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
    end

    DataMapper.finalize
    DataMapper.auto_upgrade!
    
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
