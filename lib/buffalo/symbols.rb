# symbols.rb

class Symbols

	attr_reader :scope

	def initialize(scope)

		hash = Hash.new
		@scope = scope

	end

  def addToken(type, name, value)
        
  	# TODO: Use 'has' to check if token of same name exists
  	token = Token.new(type, name, value) # Create the new entry
  	hash[name] = token # Add the entry to the hash

  end
    
  def deleteToken (name)
        
  	# TODO: Null out existing entry

  end

  def has (name)

  	# TODO: Use 'has' to check if token of same name exists

  end

end