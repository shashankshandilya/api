#!/usr/bin/env ruby

$:<<  File.dirname( File.expand_path( __FILE__ ) )

require 'sinatra'
require 'json'
require 'service/BirdsService'

get '/birds' do
  code, response = BirdsService.new().getBirds()
  status code
  content_type :json
  response
end

get '/birds/:id' do
  code, response = BirdsService.new().getBird( params['id'] )
  status code
  content_type :json
  response
end

# add new birds to DB
post '/birds' do

  code, response = BirdsService.new().post( request.env["rack.input"].read )
  status code
  content_type :json
  response

end

delete '/birds/:id' do
  code = BirdsService.new().delById( params['id'] )
  status code
end

