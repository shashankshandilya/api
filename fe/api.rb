#!/usr/bin/env ruby

$:<<  File.dirname( File.expand_path( __FILE__ ) )

require 'sinatra'
require 'json'
require 'service/BirdsService'

get '/birds' do
  begin
    code, response = BirdsService.new().getBirds()
    status code
    content_type :json
    response
  rescue Exception => e
    status 500
    content_type :text
    e.message
  end
  
end

get '/birds/:id' do
  begin
    code, response = BirdsService.new().getBird( params['id'] )
    status code
    content_type :json
    response
  rescue Exception => e
    status 500
    content_type :text
    e.message
  end
end

# add new birds to DB
post '/birds' do
  begin
    code, response = BirdsService.new().post( request.env["rack.input"].read )
    status code
    content_type :json
    response
  rescue Exception => e
    status 500
    content_type :text
    e.message
  end
  

end

delete '/birds/:id' do
  begin
    code = BirdsService.new().delById( params['id'] )
    status code
  rescue Exception => e
    status 500
    content_type :text
    e.message
  end
end

