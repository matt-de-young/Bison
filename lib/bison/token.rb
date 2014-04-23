class Token

	attr_accessor :num, :name, :type, :size, :value

	def initialize(num, name, type, size, value)
		@num = num
		@name = name
		@type = type
		@size = size
		@value = value
	end
		
	# TODO: Remove this 
	def display_details()
		puts "Token: #@name"
		puts "Num: #@num"
		puts "Type: #@type"
		puts "Size: #@size"
		puts "Value: #@value"
	end
		
end