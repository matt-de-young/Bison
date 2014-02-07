# symbols.rb

class Symbols

	attr_reader :scope
	attr_accessor :hash

	def initialize(scope)

		@hash = Hash.new
		@scope = scope

	end

	# Returns true is token is added to the table, else returns fasle
  def add(type, name, value)
        
  	if self.has(name) != nil
  		return false
  	end

  	token = Token.new(type, name, value) # Create the new entry
  	self.hash[name] = token # Add the entry to the hash
  	return true # TODO: Is this necessary?

  end
    
  def delete (name)
        
  	# TODO: Null out existing entry

  end

  def has (name)

  	token = hash[name] # Retuns the token automatically, or returns nil

  end

end