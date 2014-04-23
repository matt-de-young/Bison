class Scanner
		
	attr_reader :breakers, :source

	def initialize(file)

		if file.nil?

			puts "Please specify a source file."

		else

			@source = File.read(file)
			
			@breakers = ['(', ')', ';', '$', ':', ':=', '<', '<=', '=', '<>', '<=', '<', '"', " ", "\n", "\t"]

		end

		@declarations = false	# Flag used to mark declaration block
		@assignment = false	# Flag used to mark declaration statement
		@flag = nil	# Signals what the next token will signify

		@num = 101	# Tracks the user defined symbols added to the table
		@name
		@type
		@size
		@value

		# Contains all user defined variables
		@symbols = Symbols.new(0)

		@words = Hash.new

		# Terminals
		@words["BOOLEAN"] = 23
		@words["NUMBER"] = 24
		@words["INT"] = 25
		@words["SMALLINT"] = 26
		@words["POSITIVE"] = 27
		@words["CHAR"] = 28
		@words["BEGIN"] = 29
		@words["DECLARE"] = 30
		@words["END"] = 31
		@words["IF"] = 32
		@words["THEN"] = 33
		@words["WHILE"] = 34
		@words["LOOP"] = 35
		@words["TRUE"] = 36
		@words["FALSE"] = 37
		@words["NULL"] = 38
		@words["NOT"] = 39
		@words["DBMS_OUTPUT.PUT"] = 40
		@words["DBMS_OUTPUT.PUT_LINE"] = 41
		@words["DBMS_OUTPUT.NEW_LINE"] = 42
		@words["&"] = 43
		@words["$"] = 44
		@words["+"] = 45
		@words["-"] = 46
		@words["*"] = 47
		@words["/"] = 48
		@words["MOD"] = 49
		@words["("] = 50
		@words[")"] = 51
		@words[">"] = 52
		@words[">="] = 53
		@words["="] = 54
		@words["<="] = 55
		@words["<"] = 56
		@words["<>"] = 57
		@words["ID"] = 58
		@words[":="] = 59
		@words[";"] = 60
		@words["NUM"] = 61
		@words["C"] = 62
		@words[","] = 63

	end

	def nextToken

		begin 

			token = self.nextTokenMain

		end while token.eql? "\n" or token.eql? "\t" or token.eql? " "	# Do not return whitespace

		@declarations = true if token.eql? "DECLARE"
		@declarations = false if token.eql? "BEGIN"

		if (token =~ /^[-+]?[0-9]+$/)	== 0	# This is a number
			@value = token if @flag.eql? "value"
			@size = token if @flag.eql? "size"
			@flag = nil
			return "NUM"

		elsif @declarations == true and @words.has_key?(token) == false # This is a symbol

			@assignment = true
			@name = token

			@flag = "type"
			#puts "flag set to 'type'"	# REMOVE
			return "ID"	# Return the placeholder for the grammar

		elsif token.eql? ":=" and @declarations == true	# This is ':='
			@flag = "value"
			#puts "flag set to 'value'"	# REMOVE
			return token

		elsif token.eql? "(" and @declarations == true and @assignment == true	# This is '('
			@flag = "size"
			#puts "flag set to 'value'"	# REMOVE
			return token

		elsif token.eql? ";" and @declarations == true	# This is ';'

			@symbols.add(@num, @name, @type, @size, @value)	# Add token to symbol table
			#puts "Added #{@num}, #{@name}, #{@type}, #{@size}, #{@value} to symbols"	# REMOVE
			@assignment = false	# The assignemnt (if there is one) is over
			@flag = nil
			#puts "flag set to 'nil'"	# REMOVE
			@num += 1	# The next value will be one higher

			#testtoken = @symbols.get(@name)	# REMOVE
			#testtoken.display_details	# REMOVE
			#puts	# REMOVE

			@name = @type = @size = @value = nil	# The next variable will start with all nil

			return token

		elsif @flag != nil and @assignment == true

			@type = token if @flag.eql? "type"
			
			@value = token if @flag.eql? "value"

			@flag = nil
			return token

		else
			return token	# Not a user defined symbol
		end

	end

	# Returns next full token
	def nextTokenMain

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

   					if source[0].eql? '/' # If a '/' is seen DIRECTLY after it
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

					if token.eql? ":"	# Special case for if the token is ':='
						token << source[0]
						source[0] = ''
					end

					return token 

				else	# Returns to parser

						return token

				end

			else
				token << source[0]	# Append current char to token
  			source[0] = ''	# Remove the first char of the source string

  		end

		end 
	
	end
		
end