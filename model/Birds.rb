#!/usr/bin/env ruby

$:<< File.dirname( File.expand_path( __FILE__ ) )
require 'common/Base'
require 'json'
require 'pp'

class Birds < Base
	
	# attr_reader :name, :family, :continents, :added, :visible
	BIRDS_DB   = 'zoo'
	BIRDS_COLL = 'birds'

	def initialize()
		begin
			@mongoBirdsDb = Facility::MONGO.new().getConn({ 'hosts' => ["127.0.0.1"] }, BIRDS_DB)
			pp @mongoBirdsDb
			setvisible( false )
			setadded()
		rescue Exception => e
			pp "#{e.message}"
			raise e.message
		end
	end

	def validateSave()
		if true == checkNilOrEmpty( @continents ) && true == checkNilOrEmpty( @family ) && true == checkNilOrEmpty( @name )
			return true
		end
		return false
	end

	def setadded( date = Date.today.strftime() )
		return false if false == checkNilOrEmpty( date )
		@added = date
	end

	def setvisible( isVisible )
		return false if true == isVisible.nil?
		if isVisible.class == TrueClass || isVisible.class == FalseClass
			@visible = isVisible
		else
			return false
		end
		return true
	end

	def setfamily( family )
		return false if false == checkNilOrEmpty( family )
		return false if family.class != String
		@family = family
	end

	def checkNilOrEmpty( val )
		return false if val.nil? or val.empty?
		return true 
	end

	def setname( name )
		return false if false == checkNilOrEmpty( name )
		return false if name.class != String
		@name = name
	end

	def setcontinents( continents )
		return false if false == checkNilOrEmpty( continents )
		return false if continents.class != Array
		continents.each{|f|
			if f.class != String 
				return false
			end
		}
		@continents = continents.uniq
	end

	def save()
		begin
			raise if false == self.validateSave()
			obj = JSON.load( self.to_json )
			id  = @mongoBirdsDb[ BIRDS_COLL ].insert_one( obj )
			obj[ :id ] = id.inserted_id.to_s
			return obj
		rescue Exception => e
			pp "save #{e.message}"
		end
		return false
	end

	def get( id )
		begin
			record = nil
			raise  if true == id.nil?
			@mongoBirdsDb[ BIRDS_COLL ].find( :_id => BSON::ObjectId.from_string( id.to_s ) ).each{|doc|
				doc[ :id ]  = doc[ :_id ].to_s
				doc.delete( "_id" )
				record = doc
			}
		rescue Exception => e
			pp "get #{e.message}"
			return record
		end
		record

	end

	def getList()
		begin
			record = []
			@mongoBirdsDb[ BIRDS_COLL ].find().projection( :_id => 1 ).each{|doc|
				record.push( doc[ :_id ].to_s )
			}
		rescue Exception => e
			pp "getList #{e.message}"
		end
		record
	end

	def del( id )
		begin
			record = nil
			raise  if true == id.nil?
			id = @mongoBirdsDb[ BIRDS_COLL ].find( :_id => BSON::ObjectId.from_string( id.to_s ) ).delete_one
			if id.documents[0]["n"] == 0 
				return nil 
			else
				return id.documents[0]["n"]
			end
		rescue Exception => e
			pp "del #{e.message}"
		end
		record
	end
end

# inputJson = '{ "name" : "owl", "family" : "1232", "continents" : ["Asia", "China"], "visible" : false }'

# obj = Birds.new()

# val = obj.from_json!( inputJson )

# # pp obj.get("55cb18b2696e670f25000000")

# data = obj.save()

# puts data


# isVisible = false
# if isVisible.class == TrueClass || isVisible.class == FalseClass
# 	pp "works"
# else
# 	pp "false"
# end