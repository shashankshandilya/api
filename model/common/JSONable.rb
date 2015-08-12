#!/usr/bin/env ruby

class JSONable

  def to_json
    begin
      hash = {}
      self.instance_variables.each do |var|
        next if var.to_s.sub("@", '') ==  'mongoBirdsDb' 
        hash[ var.to_s.sub("@", '') ] = self.instance_variable_get var
      end
      hash.to_json
    rescue Exception => e
      return false
    end
  end

  def clearObject
    self.instance_variables.each do |var|
      remove_instance_variable var
    end
  end

  def from_json! string
    begin
      JSON.load(string).each do |var, val|
        raise if false == self.method("set#{var}").call(val)
        # self.instance_variable_set var, val
      end
    rescue Exception => e
      clearObject()
      return false
    end
  end

end