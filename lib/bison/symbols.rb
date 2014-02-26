# symbols.rb

class Symbols

	attr_reader :scope
	attr_accessor :hash

	def initialize (scope)

		@hash = Hash.new
		@scope = scope

	end

	# Returns true is token is added to the table, else returns fasle
  def add (type, name, value)
        
		return false unless self.has(name) == false # return false if element already exists

  	token = Token.new(type, name, value) # Create the new entry
  	self.hash[name] = token # Add the entry to the hash
  	true # TODO: Is this necessary?

  end
    
  def get (name)

  	return false if self.has(name) == false # return false if element already exists

		token = hash[name] # Retuns the token automatically, or returns nil

  end

  def delete (name)
        
  	# TODO: Null out existing entry

  end

  # Returns true or false if the element is contained in the hash
  def has (name)

  	token = hash[name]

  	return false if token == nil # Return false if it does not exist
  	true # else return true

  end

end