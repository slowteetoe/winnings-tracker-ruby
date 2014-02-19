ENV["DB_URL"] = "sqlite3://#{Dir.pwd}/winnings.db"
require 'grape'
require './lib/winnings-tracker/APIv1.rb'

run WinningsTracker::APIv1