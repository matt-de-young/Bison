class Parser

	attr_accessor :scanner, :words, :table, :grammar

	def initialize()

		@scanner = Scanner.new(ARGV[0])

		@words = Hash.new # Contains codes for all terminal & non terminal symbols

		@table = Array.new(105) {Array.new(65) }	# The parse table in a three dimensional array [state][input]

		@grammar = Array.new(58)	# The grammar table

		build(words, table, grammar)

		@stack = Stack.new

		filename = ARGV[0].split('.')	# Get file name of source
		@generator = Generator.new(filename[0])

	end

	def parse

		state, input, action = 0, scanner.nextToken(), 99

		action = table[@stack.peek()][words[input[0]]] # lookup action in the table
		token = [nil,nil]

		#puts "State: #{@stack.peek}"	#REMOVE
		#puts "Input: #{input[0]}"	#REMOVE

		while action != nil	# Error

			if action > 0	# the action is positive (shift)

				token = [words[input[0]], input[1]]
				@stack.push(action, token)
				input = scanner.nextToken
				#puts "#{input}"	# REMOVE

			elsif action < 0	# The action is negative (reduce)

				rule = grammar[action.abs]	# Get the rule at the absolute value of action
				i = 1	# Index to traverse the rule.

				#puts 	#REMOVE
				#puts "Reducing using rule #{action.abs}"	#REMOVE

				reduction = Array.new	# array to be sent to generator

				while i <= rule[0]

					token = @stack.pop

					#puts "Grammar: #{rule[i]}, Token: #{token}"	#REMOVE

					if rule[i] != token[0]	# What is on the stack does not match the grammar
						puts "Parse Error: Invalid input #{token[1]}" 
						return false
					end

					reduction << token	# Append token to reduction
					i += 1

				end

				if action.abs == 33 and reduction.any?

					if scanner.typeCheck(reduction[0][1], reduction[2][1])
						@generator.gen(action.abs, reduction) 
					else
						return false
					end
				elsif reduction.any?
					@generator.gen(action.abs, reduction)# Send to generator unless the array is empty
				end

				holdState = @stack.peek	# Get state from top of stack
				newState = table[holdState][rule[i]]	# lookup action coresponding to table[state from top of stack][LHS of grammar]

				token = [rule[i], token[1]]	# What to push onto the stack
				j = reduction.length - 1	# Iterate thorugh reduction
				while token[1].nil? and j>-1	# Until we find something that isn't nil
					token = [rule[i], reduction[j][1]]	# Try the tokens that were higher on the stack
					j-=1
				end

				@stack.push(newState, token)	# Put LHS & new state on top of stack

			elsif action == 0	# Accept the source
				@generator.close	# Write everything in the buffer to output file
				return true

			end	# If block

			#puts 	#REMOVE
			#puts "State: #{@stack.peek}"	#REMOVE
			#puts "Input: #{input[0]}"	#REMOVE

			action = table[@stack.peek()][words[input[0]]] # lookup action in the table before checking for nil at the begining of the loop

		end	# While block

		puts "Parse Error: Invalid input" 
		return false	# Table returned nil

	end	# parse

	def build(words, table, grammar)

		# Non-terminals
		words["block"] = 1
		words["declarations"] = 2
		words["declare_rest"] = 3
		words["default"] = 4
		words["data_type"] = 5
		words["characters"] = 6
		words["size"] = 7
		words["size_option"] = 8
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
		words["DBMS_OUTPUT.PUT"] = 40
		words["DBMS_OUTPUT.PUT_LINE"] = 41
		words["DBMS_OUTPUT.NEW_LINE"] = 42
		words["&"] = 43
		words["$"] = 44
		words["+"] = 45
		words["-"] = 46
		words["*"] = 47
		words["/"] = 48
		words["MOD"] = 49
		words["("] = 50
		words[")"] = 51
		words[">"] = 52
		words[">="] = 53
		words["="] = 54
		words["<="] = 55
		words["<"] = 56
		words["<>"] = 57
		words["ID"] = 58
		words[":="] = 59
		words[";"] = 60
		words["NUM"] = 61
		words["C"] = 62
		words[","] = 63

		# Grammar table
		grammar[1] = [3, '$', words["compound_statement"], words["declarations"], words["block"]]
		grammar[2] = [2, words["declare_rest"], words["DECLARE"],	words["declarations"]]
		grammar[3] = [0, words["declarations"]]
		grammar[4] = [5, words["declare_rest"], words[";"], words["default"], words["data_type"], words["ID"], words["declare_rest"]]
		grammar[5] = [0, words["declare_rest"]]
		grammar[6] = [2, words["righthandside"], words[":="], words["default"]]
		grammar[7] = [0, words["default"]]
		grammar[8] = [1, words["characters"], words["data_type"]]
		grammar[9] = [1, words["numbers"], words["data_type"]]
		grammar[10] = [1, words["BOOLEAN"], words["data_type"]]
		grammar[11] = [1, words["CHAR"], words["characters"]]
		grammar[12] = [2, words["size_option"], words["NUM"], words["size"]]
		grammar[13] = [0, words["size"]]
		grammar[14] = [2, words["NUM"], words[","], words["size_option"]]
		grammar[15] = [0, words["size_option"]]
		grammar[16] = [4, words[")"], words["size"], words["("], words["NUMBER"], words["numbers"]]
		grammar[17] = [4, words[")"], words["size"], words["("], words["INT"], words["numbers"]]
		grammar[18] = [4, words[")"], words["size"], words["("], words["SMALLINT"], words["numbers"]]
		grammar[19] = [4, words[")"], words["size"], words["("], words["POSITIVE"], words["numbers"]]
		grammar[20] = [4, words[";"], words["END"], words["optional_statements"], words["BEGIN"], words["compound_statement"]]
		grammar[21] = [2, words[";"], words["NULL"], words["optional_statements"]]
		grammar[22] = [1, words["statement_list"], words["optional_statements"]]
		grammar[23] = [1, words["statement"], words["statement_list"]]
		grammar[24] = [3, words["statement"], words[";"], words["statement_list"], words["statement_list"]]
		grammar[25] = [1, words["lefthandside"], words["statement"]]
		grammar[26] = [1, words["compound_statement"], words["statement"]]
		grammar[27] = [4, words[")"], words["ID"], words["("], words["DBMS_OUTPUT.PUT_LINE"], words["statement"]]
		grammar[28] = [4, words[")"], words["ID"], words["("], words["DBMS_OUTPUT.PUT"], words["statement"]]
		grammar[29] = [1, words["DBMS_OUTPUT.NEW_LINE"], words["statement"]]
		grammar[30] = [2, words["ID"], words["&"], words["statement"]]
		grammar[31] = [6, words["IF"], words["END"], words["statement"], words["THEN"], words["expression"], words["IF"], words["statement"]]
		grammar[32] = [6, words["LOOP"], words["END"], words["statement"], words["LOOP"], words["expression"], words["WHILE"], words["statement"]]
		grammar[33] = [3, words["righthandside"], words[":="], words["ID"], words["lefthandside"]]
		grammar[34] = [1, words["expression"], words["righthandside"]]
		grammar[35] = [1, words["C"], words["righthandside"]]
		grammar[36] = [1, words["simple_expression"], words["expression"]]
		grammar[37] = [3, words["simple_expression"], words["relop"], words["simple_expression"], words["expression"]]
		grammar[38] = [1, words["term"], words["simple_expression"]]
		grammar[39] = [3, words["term"], words["addop"], words["simple_expression"], words["simple_expression"]]
		grammar[40] = [1, words["factor"], words["term"]]
		grammar[41] = [3, words["factor"], words["mulop"], words["term"], words["term"]]
		grammar[42] = [1, words["ID"], words["factor"]]
		grammar[43] = [1, words["NUM"], words["factor"]]
		grammar[44] = [1, words["TRUE"], words["factor"]]
		grammar[45] = [1, words["FALSE"], words["factor"]]
		grammar[46] = [1, words["NULL"], words["factor"]]
		grammar[47] = [2, words["factor"], words["NOT"], words["factor"]]
		grammar[48] = [1, words[">"], words["relop"]]
		grammar[49] = [1, words[">="], words["relop"]]
		grammar[50] = [1, words["="], words["relop"]]
		grammar[51] = [1, words["<="], words["relop"]]
		grammar[52] = [1, words["<"], words["relop"]]
		grammar[53] = [1, words["<>"], words["relop"]]
		grammar[54] = [1, words["+"], words["addop"]]
		grammar[55] = [1, words["-"], words["addop"]]
		grammar[56] = [1, words["*"], words["mulop"]]
		grammar[57] = [1, words["/"], words["mulop"]]
		grammar[58] = [1, words["MOD"], words["mulop"]]


		# Parse table
		table[0][words["DECLARE"]] = 1
		table[0][words["BEGIN"]] = -3
		table[0][words["block"]] = 2
		table[0][words["declarations"]] = 3

		table[1][words["ID"]] = 4
		table[1][words["BEGIN"]] = -5
		table[1][words["declare_rest"]] = 5

		table[2][words["$"]] = 0	# This means 'accept' Originally this was "$end"

		table[3][words["BEGIN"]] = 6
		table[3][words["compound_statement"]] = 7

		table[4][words["BOOLEAN"]] = 8
		table[4][words["CHAR"]] = 9
		table[4][words["NUMBER"]] = 10
		table[4][words["INT"]] = 11
		table[4][words["SMALLINT"]] = 12
		table[4][words["POSITIVE"]] = 13
		table[4][words["data_type"]] = 14
		table[4][words["characters"]] = 15
		table[4][words["numbers"]] = 16

		table[5].each_with_index {|val, index| table[5][index] = -2 }	# Iterates thorugh the array & fills each space with the commands

		table[6][words["ID"]] = 17
		table[6][words["BEGIN"]] = 6
		table[6][words["NULL"]] = 18
		table[6][words["DBMS_OUTPUT.PUT_LINE"]] = 19
		table[6][words["DBMS_OUTPUT.PUT"]] = 20
		table[6][words["DBMS_OUTPUT.NEW_LINE"]] = 21
		table[6][words["IF"]] = 22
		table[6][words["WHILE"]] = 23
		table[6][words["&"]] = 24
		table[6][words["compound_statement"]] = 25
		table[6][words["optional_statements"]] = 26
		table[6][words["statement_list"]] = 27
		table[6][words["statement"]] = 28
		table[6][words["lefthandside"]] = 29

		table[7][words["$"]] = 0	# was 30

		table[8].each_with_index {|val, index| table[8][index] = -10 }

		table[9].each_with_index {|val, index| table[9][index] = -11 }

		table[10][words["("]] = 31

		table[11][words["("]] = 32

		table[12][words["("]] = 33

		table[13][words["("]] = 34

		table[14][words[":="]] = 35
		table[14][words[";"]] = -7
		table[14][words["default"]] = 36

		table[15].each_with_index {|val, index| table[15][index] = -8 }

		table[16].each_with_index {|val, index| table[16][index] = -9 }

		table[17][words[":="]] = 37

		table[18][words[";"]] = 38

		table[19][words["("]] = 39

		table[20][words["("]] = 40

		table[21].each_with_index {|val, index| table[21][index] = -29 }

		table[22][words["ID"]] = 41
		table[22][words["NUM"]] = 42
		table[22][words["NULL"]] = 43
		table[22][words["TRUE"]] = 44
		table[22][words["FALSE"]] = 45
		table[22][words["NOT"]] = 46
		table[22][words["expression"]] = 47
		table[22][words["simple_expression"]] = 48
		table[22][words["term"]] = 49
		table[22][words["factor"]] = 50

		table[23][words["ID"]] = 41
		table[23][words["NUM"]] = 42
		table[23][words["NULL"]] = 43
		table[23][words["TRUE"]] = 44
		table[23][words["FALSE"]] = 45
		table[23][words["NOT"]] = 46
		table[23][words["expression"]] = 51
		table[23][words["simple_expression"]] = 48
		table[23][words["term"]] = 49
		table[23][words["factor"]] = 50

		table[24][words["ID"]] = 52

		table[25].each_with_index {|val, index| table[25][index] = -26 }

		table[26][words["END"]] = 53

		table[27][words[";"]] = 54
		table[27][words["END"]] = -22

		table[28].each_with_index {|val, index| table[28][index] = -23 }

		table[29].each_with_index {|val, index| table[29][index] = -25 }

		table[30].each_with_index {|val, index| table[30][index] = -1 }

		table[31][words["NUM"]] = 55
		table[31][words[")"]] = -13
		table[31][words["size"]] = 56

		table[32][words["NUM"]] = 55
		table[32][words[")"]] = -13
		table[32][words["size"]] = 57

		table[33][words["NUM"]] = 55
		table[33][words[")"]] = -13
		table[33][words["size"]] = 58

		table[34][words["NUM"]] = 55
		table[34][words[")"]] = -13
		table[34][words["size"]] = 59

		table[35][words["ID"]] = 41
		table[35][words["NUM"]] = 42
		table[35][words["NULL"]] = 43
		table[35][words["TRUE"]] = 44
		table[35][words["FALSE"]] = 45
		table[35][words["NOT"]] = 46
		table[35][words["C"]] = 60
		table[35][words["righthandside"]] = 61
		table[35][words["expression"]] = 62
		table[35][words["simple_expression"]] = 48
		table[35][words["term"]] = 49
		table[35][words["factor"]] = 50

		table[36][words[";"]] = 63

		table[37][words["ID"]] = 41
		table[37][words["NUM"]] = 42
		table[37][words["NULL"]] = 43
		table[37][words["TRUE"]] = 44
		table[37][words["FALSE"]] = 45
		table[37][words["NOT"]] = 46
		table[37][words["C"]] = 60
		table[37][words["righthandside"]] = 64
		table[37][words["expression"]] = 62
		table[37][words["simple_expression"]] = 48
		table[37][words["term"]] = 49
		table[37][words["factor"]] = 50

		table[38].each_with_index {|val, index| table[38][index] = -21 }

		table[39][words["ID"]] = 65

		table[40][words["ID"]] = 66

		table[41].each_with_index {|val, index| table[41][index] = -42 }

		table[42].each_with_index {|val, index| table[42][index] = -43 }

		table[43].each_with_index {|val, index| table[43][index] = -46 }

		table[44].each_with_index {|val, index| table[44][index] = -44 }

		table[45].each_with_index {|val, index| table[45][index] = -45 }

		table[46][words["ID"]] = 41
		table[46][words["NUM"]] = 42
		table[46][words["NULL"]] = 43
		table[46][words["TRUE"]] = 44
		table[46][words["FALSE"]] = 45
		table[46][words["NOT"]] = 46
		table[46][words["factor"]] = 67

		table[47][words["THEN"]] = 68

		table[48][words[">"]] = 69
		table[48][words[">="]] = 70
		table[48][words["="]] = 71
		table[48][words["<="]] = 72
		table[48][words["<"]] = 73
		table[48][words["<>"]] = 74
		table[48][words["+"]] = 75
		table[48][words["-"]] = 76
		table[48][words["END"]] = -36
		table[48][words["THEN"]] = -36
		table[48][words["LOOP"]] = -36
		table[48][words[";"]] = -36
		table[48][words["relop"]] = 77
		table[48][words["addop"]] = 78

		table[49][words["MOD"]] = 79
		table[49][words["*"]] = 80
		table[49][words["/"]] = 81
		table[49][words["END"]] = -38
		table[49][words["THEN"]] = -38
		table[49][words["LOOP"]] = -38
		table[49][words[";"]] = -38
		table[49][words[">"]] = -38
		table[49][words[">="]] = -38
		table[49][words["="]] = -38
		table[49][words["<="]] = -38
		table[49][words["<"]] = -38
		table[49][words["<>"]] = -38
		table[49][words["+"]] = -38
		table[49][words["-"]] = -38
		table[49][words["mulop"]] = 82

		table[50].each_with_index {|val, index| table[50][index] = -40 }

		table[51][words["LOOP"]] = 83

		table[52].each_with_index {|val, index| table[52][index] = -30 }

		table[53][words[";"]] = 84

		table[54][words["ID"]] = 17
		table[54][words["BEGIN"]] = 6
		table[54][words["DBMS_OUTPUT.PUT_LINE"]] = 19
		table[54][words["DBMS_OUTPUT.PUT"]] = 20
		table[54][words["DBMS_OUTPUT.NEW_LINE"]] = 21
		table[54][words["IF"]] = 22
		table[54][words["WHILE"]] = 23
		table[54][words["&"]] = 24
		table[54][words["compound_statement"]] = 25
		table[54][words["statement"]] = 85
		table[54][words["lefthandside"]] = 29

		table[55][words[","]] = 86
		table[55][words[")"]] = -15
		table[55][words["size_option"]] = 87

		table[56][words[")"]] = 88

		table[57][words[")"]] = 89

		table[58][words[")"]] = 90

		table[59][words[")"]] = 91

		table[60].each_with_index {|val, index| table[60][index] = -35 }

		table[61].each_with_index {|val, index| table[61][index] = -6 }

		table[62].each_with_index {|val, index| table[62][index] = -34 }

		table[63][words["ID"]] = 4
		table[63][words["BEGIN"]] = -5
		table[63][words["declare_rest"]] = 92

		table[64].each_with_index {|val, index| table[64][index] = -33 }

		table[65][words[")"]] = 93

		table[66][words[")"]] = 94

		table[67].each_with_index {|val, index| table[67][index] = -47 }

		table[68][words["ID"]] = 17
		table[68][words["BEGIN"]] = 6
		table[68][words["DBMS_OUTPUT.PUT_LINE"]] = 19
		table[68][words["DBMS_OUTPUT.PUT"]] = 20
		table[68][words["DBMS_OUTPUT.NEW_LINE"]] = 21
		table[68][words["IF"]] = 22
		table[68][words["WHILE"]] = 23
		table[68][words["&"]] = 24
		table[68][words["compound_statement"]] = 25
		table[68][words["statement"]] = 95
		table[68][words["lefthandside"]] = 29

		table[69].each_with_index {|val, index| table[69][index] = -48 }

		table[70].each_with_index {|val, index| table[70][index] = -49 }

		table[71].each_with_index {|val, index| table[71][index] = -50 }

		table[72].each_with_index {|val, index| table[72][index] = -51 }

		table[73].each_with_index {|val, index| table[73][index] = -52 }

		table[74].each_with_index {|val, index| table[74][index] = -53 }

		table[75].each_with_index {|val, index| table[75][index] = -54 }

		table[76].each_with_index {|val, index| table[76][index] = -55 }

		table[77][words["ID"]] = 41
		table[77][words["NUM"]] = 42
		table[77][words["NULL"]] = 43
		table[77][words["TRUE"]] = 44
		table[77][words["FALSE"]] = 45
		table[77][words["NOT"]] = 46
		table[77][words["simple_expression"]] = 96
		table[77][words["term"]] = 49
		table[77][words["factor"]] = 50

		table[78][words["ID"]] = 41
		table[78][words["NUM"]] = 42
		table[78][words["NULL"]] = 43
		table[78][words["TRUE"]] = 44
		table[78][words["FALSE"]] = 45
		table[78][words["NOT"]] = 46
		table[78][words["term"]] = 97
		table[78][words["factor"]] = 50

		table[79].each_with_index {|val, index| table[79][index] = -58 }

		table[80].each_with_index {|val, index| table[80][index] = -56 }

		table[81].each_with_index {|val, index| table[81][index] = -57 }

		table[82][words["ID"]] = 41
		table[82][words["NUM"]] = 42
		table[82][words["NULL"]] = 43
		table[82][words["TRUE"]] = 44
		table[82][words["FALSE"]] = 45
		table[82][words["NOT"]] = 46
		table[82][words["factor"]] = 98

		table[83][words["ID"]] = 17
		table[83][words["BEGIN"]] = 6
		table[83][words["DBMS_OUTPUT.PUT_LINE"]] = 19
		table[83][words["DBMS_OUTPUT.PUT"]] = 20
		table[83][words["DBMS_OUTPUT.NEW_LINE"]] = 21
		table[83][words["IF"]] = 22
		table[83][words["WHILE"]] = 23
		table[83][words["&"]] = 24
		table[83][words["compound_statement"]] = 25
		table[83][words["statement"]] = 99
		table[83][words["lefthandside"]] = 29

		table[84].each_with_index {|val, index| table[84][index] = -20 }

		table[85].each_with_index {|val, index| table[85][index] = -24 }

		table[86][words["NUM"]] = 100

		table[87].each_with_index {|val, index| table[87][index] = -12 }

		table[88].each_with_index {|val, index| table[88][index] = -16 }

		table[89].each_with_index {|val, index| table[89][index] = -17 }

		table[90].each_with_index {|val, index| table[90][index] = -18 }

		table[91].each_with_index {|val, index| table[91][index] = -19 }

		table[92].each_with_index {|val, index| table[92][index] = -4 }

		table[93].each_with_index {|val, index| table[93][index] = -27 }

		table[94].each_with_index {|val, index| table[94][index] = -28 }

		table[95][words["END"]] = 101

		table[96][words["+"]] = 75
		table[96][words["-"]] = 76
		table[96][words["END"]] = -37
		table[96][words["THEN"]] = -37
		table[96][words["LOOP"]] = -37
		table[96][words[";"]] = -37
		table[96][words["addop"]] = 78

		table[97][words["MOD"]] = 79
		table[97][words["*"]] = 80
		table[97][words["/"]] = 81
		table[97][words["END"]] = -39
		table[97][words["THEN"]] = -39
		table[97][words["LOOP"]] = -39
		table[97][words[";"]] = -39
		table[97][words[">"]] = -39
		table[97][words[">="]] = -39
		table[97][words["="]] = -39
		table[97][words["<="]] = -39
		table[97][words["<"]] = -39
		table[97][words["<>"]] = -39
		table[97][words["+"]] = -39
		table[97][words["-"]] = -39
		table[97][words["mulop"]] = 82

		table[98].each_with_index {|val, index| table[98][index] = -41 }

		table[99][words["END"]] = 102

		table[100].each_with_index {|val, index| table[100][index] = -14 }

		table[101][words["IF"]] = 103

		table[102][words["LOOP"]] = 104

		table[103].each_with_index {|val, index| table[103][index] = -31 }

		table[104].each_with_index {|val, index| table[104][index] = -32 }

	end

end
