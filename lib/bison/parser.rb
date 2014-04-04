class Parser
		
	attr_accessor :scanner, :words, :symbols, :table

	def initialize()

		@scanner = Scanner.new(ARGV[0])

		@words = Hash.new # Contains codes for all terminal & non terminal symbols

		@table = Array.new(104) {Array.new(65) {Array.new(2) } }	# The parse table in a three dimensional array [state][input]

		populate(words, table)

		#puts words['INT']	# Example lookup for terminal
		#table[0][0] = ['GOTO', 2]	# Example adding to table
		#puts table[1][3] # Example returning from table

		# Contains all user defined variables
		@symbols = Symbols.new(0)

		@stack = Stack.new

	end
		
	def populate(words, table)

		# For now, the string is the key. It may make more sence in the future to switch this

		# Non-terminals
		words["block"] = 1
		words["declarations"] = 2
		words["declare_rest"] = 3
		words["default"] = 4
		words["data_type"] = 5
		words["characters"] = 6
		words["size"] = 7
		words["size_options"] = 8
		words["numbers"] = 9
		words["compound_statement"] = 10
		words["optional_statements"] = 11
		words["statement_list"] = 12
		words["statement"] = 13
		words["lefthandside"] = 14
		words["righthandside"] = 15
		words["expression"] = 16
		words["simple_expression"] = 17
		words["term"] = 18
		words["factor"] = 19
		words["relop"] = 20
		words["addop"] = 21
		words["mulop"] = 22

		# Terminals
		words["BOOLEAN"] = 23
		words["NUMBER"] = 24
		words["INT"] = 25
		words["SMALLINT"] = 26
		words["POSITIVE"] = 27
		words["CHAR"] = 28
		words["BEGIN"] = 29
		words["DECLARE"] = 30
		words["END"] = 31
		words["IF"] = 32
		words["THEN"] = 33
		words["WHILE"] = 34
		words["LOOP"] = 35
		words["TRUE"] = 36
		words["FALSE"] = 37
		words["NULL"] = 38
		words["NOT"] = 39
		words["DBMS_OUTPUT"] = 40
		words["PUT"] = 41
		words["PUT_LINE"] = 42
		words["NEW_LINE"] = 43
		words["&"] = 44
		words["$"] = 45
		words["+"] = 46
		words["-"] = 47
		words["*"] = 48
		words["/"] = 49
		words["MOD"] = 50
		words["."] = 51
		words["("] = 52
		words[")"] = 53
		words[">"] = 54
		words[">="] = 55
		words["="] = 56
		words["<="] = 57
		words["<"] = 58
		words["<>"] = 59
		words["ID"] = 60

		# Parse table
		table[0][30] = ['shift', 1]
		table[0][29] = ['reduce', 3]
		table[0][1] = ['goto', 2]
		table[0][2] = ['goto', 3]

		table[1][60] = ['shift', 4]
		table[1][29] = ['reduce', 5]
		table[1][3] = ['goto', 5]

	end

end