$:<< File.join(File.dirname(__FILE__), '..', 'lib')

require 'json'
require 'rack/test'
require 'winnings-tracker/APIv1.rb'
require 'winnings-tracker/location.rb'
require 'winnings-tracker/tracked_visit.rb'
require 'winnings-tracker/user.rb'

DataMapper.auto_migrate!