#!/usr/bin/env ruby

$:<< File.dirname( File.dirname( File.dirname( File.expand_path( __FILE__ ) ) ) )


require 'model/Birds'

class BirdsService

  attr_accessor :birdObj

  def initialize()
  end

  def post( jsonString )
    birdObj = Birds.new()
    if false != birdObj.from_json!( jsonString )
      response = birdObj.save()
      if false != response
        return 201, response.to_json
      end
    end
    return 400
  end

  def getBirds()
    birdObj  = Birds.new()
    response = birdObj.getList()
    return 200, response.to_json
  end

  def getBird( id )
    birdObj = Birds.new()
    response = birdObj.get( id )
    if true == response.nil?
      return 404
    else
      return 200, response.to_json
    end
  end 

  def delById( id )
    birdObj = Birds.new()
    response = birdObj.del( id )
    if true == response.nil?
      return 404
    else
      return 200
    end
  end

end
