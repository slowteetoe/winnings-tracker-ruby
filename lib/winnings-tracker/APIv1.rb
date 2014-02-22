require 'grape'
require 'dm-core'
require 'dm-migrations'
require 'dm-serializer/to_json'
require 'dm-aggregates'
require_relative 'win_loss_record.rb'

DataMapper::Logger.new($stdout, :debug)
uri = (ENV["DATABASE_URL"] || "sqlite3://#{Dir.pwd}/winnings-test.db")

DataMapper.setup(:default, uri)

require_relative 'tracked_visit.rb'
require_relative 'location.rb'
require_relative 'user.rb'

DataMapper.finalize
DataMapper.auto_upgrade!


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

    resources :visit do
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
        TrackedVisit.create! ({
          user_id: params["user_id"],
          location_id: params["location_id"],
          buy_in: params["buy_in"],
          cash_out: params["cash_out"]
        })
      end
    end

    resources :user do
      desc 'Create a user'
      params do
        requires :name, type: String
      end
      post do
        User.first_or_create ({
          name: params["name"]
        })
      end

      desc 'get win/loss record'
      get '/:user_id' do
        r = WinLossRecord.for_user params["user_id"]
        # FIXME: why do I have to do this?  is requiring JSON from the spec helper stomping on #to_json?
        { total_cash_out: r.total_cash_out, total_buy_in: r.total_buy_in, net: r.net }
      end
    end
  end
end
