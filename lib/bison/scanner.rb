class Scanner
		
	attr_reader :breakers
	attr_accessor :source

	def initialize(file)

		if file.nil?

			puts "Please specify a source file."

		else

			@source = File.read(file)

			# This should probably be put in with the parser whenever that is built.
			reserved = ['--', '/*', '*/', 'BOOLEAN', 'INT', 'NUMBER', 'SMALLINT', 'POSITIVE', 'CHAR', 'BEGIN', 'DECLARE', 'END', 'IF', 'THEN', 'WHILE', 'LOOP', 'TRUE', 'FALSE', 'NULL', 'NOT', 'DBMS_OUTPUT', 'PUT_LINE', 'PUT', 'NEW_LINE', '&', '$', '+', '-', '*', '/', 'MOD','(', ')', '>', '>=', '=', '<=', '<', '<>', ]
			@breakers = ['.', '(', ')', '"', " ", "\n"]

		end

	end

	# Returns next full token
	def nextToken()

		token = ''
	
		while source.length > 0

			if breakers.include? source[0]
				return token
			else
				token << source[0] # append current char to token
  			source[0] = '' # Remove the first char of the string
  		end

		end 
	
	end
		
end