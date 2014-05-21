# symbols.rb

class Symbols

	attr_reader :scope
	attr_accessor :hash

	def initialize (scope)

		@hash = Hash.new
		@scope = scope
    @names = Array.new

	end

	# Returns true is token is added to the table, else returns fasle
  def add (num, name, type, size, value)
        
		return false unless self.has(name) == false # return false if element already exists

  	token = Token.new(num, name, type, size, value) # Create the new entry
  	self.hash[num] = token # Add the entry to the hash
    @names << name
  	true # TODO: Is this necessary?

  end
    
  def get (num)

  	#return false if self.has(num) == false # return false if element already exists

		token = hash[num] # Retuns the token automatically, or returns nil

  end

  def delete (num)
        
  	# TODO: Null out existing entry

  end

  # Returns true or false if the element is contained in the hash
  def has (name)

    if @names.include? name
      return true 
    else
      return false
    end

  end

  def getNum(name)

    j = 101
    while 1 != 0
      hold = self.get(j)
      return hold.num if hold.name == name
      j+=1
    end

  end

  def print
    puts hash.keys
  end

end