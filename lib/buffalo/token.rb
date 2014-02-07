class Token

	attr_accessor :type, :name, :value

	def initialize(type, name, value)
		@type = type
		@name = name
		@value = value
	end
		
	# TODO: Remove this 
	def display_details()
		puts "Type: #@type"
		puts "Token: #@name"
		puts "Value: #@value"
	end
		
end