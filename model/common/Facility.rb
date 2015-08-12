#!/usr/bin/env ruby
$: << File.dirname( __FILE__ )
require 'mongo'

module Facility

  class MONGO
    
    def initialize()
      Mongo::Logger.logger.level = Logger::WARN
    end

    def getConn( _server, _db )
      # pp get_options( @config[ 'mongo' ][ _server ], _db )
      #'mongodb://127.0.0.1:27017,127.0.0.1:27018/mydb?replicaSet=myapp'
      return Mongo::Client.new( get_options( _server, _db ) )
    end
    
    def get_options( server, _db )

      if server[ 'replica_set' ]
        replica_set = "?replicaSet#{server[ 'replica_set' ]}"
      end
      uri = "mongodb://#{server[ 'hosts' ].join(',')}/#{_db}#{replica_set}"

    end
  end

end
