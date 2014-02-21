require 'grape'
require 'dm-core'
require 'dm-migrations'
require 'dm-serializer'
require 'dm-aggregates'
require_relative 'win_loss_record.rb'

DataMapper::Logger.new($stdout, :debug)
uri = (ENV["DB_URL"] || "sqlite3://#{Dir.pwd}/winnings-test.db")

DataMapper.setup(:default, uri)

require_relative 'tracked_visit.rb'
require_relative 'location.rb'
require_relative 'user.rb'

DataMapper.finalize
DataMapper.auto_migrate!


module WinningsTracker
  class APIv1 < Grape::API
    logger = Logger.new($stdout)

    version 'v1', using: :path
    format :json
    default_format :json

    resources :locations do

      desc 'Create a location'
      params do
        requires :name, type: String, desc: 'Name of the location'
      end
      post do
        logger.info "Trying to create location for #{params[:name]}"
        Location.create({ :name => params[:name]})
      end

      desc 'List known locations'
      get do
        Location.all
      end

      desc 'Find a specific location by id'
      get '/:id' do
        Location.first(id: params[:id])
      end

    end

    resources :visits do

      desc 'Track a visit'
      params do
        requires :user_id, type: Integer
        requires :location_id, type: Integer
        # FIXME: make these mandatory - what type do they need to be?
        # requires :buy_in, type: Double
        # requires :cash_out, type: float
        optional :visit_date, type: DateTime
      end
      post do
        logger.info "Would track a visit for user_id #{params['user_id']} and location_id #{params['location_id']}"
        TrackedVisit.create! ({
          user_id: params["user_id"],
          location_id: params["location_id"],
          buy_in: params["buy_in"],
          cash_out: params["cash_out"]
        })
      end
    end

  end
end
