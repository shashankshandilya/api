#!/usr/bin/env ruby

$:<< File.dirname( File.dirname( File.dirname( File.expand_path( __FILE__ ) ) ) )


require 'model/Birds'

class BirdsService

  attr_accessor :birdObj

  DB_ERROR_MESSAGE = '{ "database" : "not able to connect to db" }'
  def initialize()
    begin
      @birdObj = Birds.new()
    rescue Exception => e
      raise DB_ERROR_MESSAGE
    end
  end

  def post( jsonString )
    if false != @birdObj.from_json!( jsonString )
      response = @birdObj.save()
      if false != response
        return 201, response.to_json
      end
    end
    return 400
  end

  def getBirds()
    response = @birdObj.getList()
    return 200, response.to_json
  end

  def getBird( id )
    response = @birdObj.get( id )
    if true == response.nil?
      return 404
    else
      return 200, response.to_json
    end
  end 

  def delById( id )
    response = @birdObj.del( id )
    if true == response.nil?
      return 404
    else
      return 200
    end
  end

end
