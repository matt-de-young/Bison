class Token

	attr_accessor :type, :name, :value, :scope

	def initialize(type, name, value, scope)
		@type = type
		@name = name
		@value = value
		@scope = scope
	end
		
	def display_details()
		puts "Type: #@type"
		puts "Token: #@name"
		puts "Value: #@value"
	end
		
end