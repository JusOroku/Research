require 'mongo'
include Mongo


class Mongo_connect
    #Connect to MongoDB port 27017
    def connect_mongo()
    client = Mongo::Client.new([ '127.0.0.1:27017' ], :database => 'myinfo', :connect => :direct)
    return client
    end

end
