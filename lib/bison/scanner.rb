class Scanner
		
	attr_reader :breakers, :source

	def initialize(file)

		if file.nil?

			puts "Please specify a source file."

		else

			@source = File.read(file)
			
			@breakers = ['(', ')', '"', " ", "\n"]

		end

	end

	# Returns next full token
	def nextToken()

		token = ''
	
		while source.length > 0

			if token.eql? '--'	# If this is a single line comment
				token = ''	# Ignore the '--'
				until source[0].eql? "\n" # Until the next ine
   				source[0] = ''
				end

			elsif token.eql? '/*'	# If this is a multi line comment
				token = ''	# Ignore the '/*'
				until token.eql? '*/' # Until '*/'
   				
   				if source[0].eql? '*'	# If a '*' is seen
   					token << source[0]
   					source[0] = ''

   					if source[0].eql? '/' # If a / is seen DIRECTLY after it
   						token << source[0]
   						source[0] = ''

   					else
   						token = ''

   					end

   				else
   					source[0] = ''

   				end

				end
				token = ''	# Ignore the '*/'

			elsif breakers.include? source[0]	# If this char is a breaker

				if token.eql? ''	# If this is the first char
					token << source[0]
					source[0] = ''
					return token

				else
					return token

				end

			else
				token << source[0]	# Append current char to token
  			source[0] = ''	# Remove the first char of the source string

  		end

		end 
	
	end
		
end