class Scanner
		
	attr_reader :file
	attr_accessor :source

	def initialize(file)

		if file.nil?

			puts "Please specify a source file."

		else

			@source = File.read(file)
			puts source
			source = self.source.scan(/./)
			puts source

			# This should probably be put in with the parser whenever that is built.
			reserved = ['--', '/*', '*/', 'BOOLEAN', 'INT', 'NUMBER', 'SMALLINT', 'POSITIVE', 'CHAR', 'BEGIN', 'DECLARE', 'END', 'IF', 'THEN', 'WHILE', 'LOOP', 'TRUE', 'FALSE', 'NULL', 'NOT', 'DBMS_OUTPUT', 'PUT_LINE', 'PUT', 'NEW_LINE', '&', '$', '+', '-', '*', '/', 'MOD','(', ')', '>', '>=', '=', '<=', '<', '<>', ]
			breakers = ['.', '(', ')', '"']

		end

	end

	# Returns next full token
	#def nextToken()
	#
	#	loop do 
  #		# some code here
  #		nextChar =  # Get the next char of the program. 
  #		break if <breakers.includes?(nextChar)> # If nextChar is a breaker or some kind of white space
	#	end 
	#
	#end
		
end