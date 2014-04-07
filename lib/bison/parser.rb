class Parser
		
	attr_accessor :scanner, :words, :symbols, :table

	def initialize()

		@scanner = Scanner.new(ARGV[0])

		@words = Hash.new # Contains codes for all terminal & non terminal symbols

		@table = Array.new(105) {Array.new(65) {Array.new(2) } }	# The parse table in a three dimensional array [state][input]

		build(words, table)

		#puts words['INT']	# Example lookup for terminal
		#table[0][0] = ['GOTO', 2]	# Example adding to table
		#puts table[1][3] # Example returning from table

		# Contains all user defined variables
		@symbols = Symbols.new(0)

		@stack = Stack.new

	end
		
	def build(words, table)

		# For now, the string is the key. It may make more sence in the future to switch this

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

		# Parse table
		table[0][words["DECLARE"]] = ['shift', 1]
		table[0][words["BEGIN"]] = ['reduce', 3]
		table[0][words["block"]] = ['goto', 2]
		table[0][words["declarations"]] = ['goto', 3]

		table[1][words["ID"]] = ['shift', 4]
		table[1][words["BEGIN"]] = ['reduce', 5]
		table[1][words["declare_rest"]] = ['goto', 5]

		table[2][words["$"]] = ['accept', ]	# Originally this was "$end"

		table[3][words["BEGIN"]] = ['shift', 6]
		table[3][words["compound_statement"]] = ['goto', 7]

		table[4][words["BOOLEAN"]] = ['shift', 8]
		table[4][words["CHAR"]] = ['shift', 9]
		table[4][words["NUMBER"]] = ['shift', 10]
		table[4][words["INT"]] = ['shift', 11]
		table[4][words["SMALLINT"]] = ['shift', 12]
		table[4][words["POSITIVE"]] = ['shift', 13]
		table[4][words["data_type"]] = ['goto', 14]
		table[4][words["characters"]] = ['goto', 15]
		table[4][words["numbers"]] = ['goto', 16]

		table[5].each_with_index {|val, index| table[5][index] = ['reduce', 2] }	# Iterates thorugh the array & fills each space with the commands

		table[6][words["ID"]] = ['shift', 17]
		table[6][words["BEGIN"]] = ['shift', 6]
		table[6][words["NULL"]] = ['shift', 18]
		table[6][words["DBMS_OUTPUT.PUT_LINE"]] = ['shift', 19]
		table[6][words["DBMS_OUTPUT.PUT"]] = ['shift', 20]
		table[6][words["DBMS_OUTPUT.NEW_LINE"]] = ['shift', 21]
		table[6][words["IF"]] = ['shift', 22]
		table[6][words["WHILE"]] = ['shift', 23]
		table[6][words["&"]] = ['shift', 24]
		table[6][words["compound_statement"]] = ['goto', 25]
		table[6][words["optional_statements"]] = ['goto', 26]
		table[6][words["statement_list"]] = ['goto', 27]
		table[6][words["statement"]] = ['goto', 28]
		table[6][words["lefthandside"]] = ['goto', 29]

		table[7][words["$"]] = ['shift', 30]

		table[8].each_with_index {|val, index| table[8][index] = ['reduce', 10] }

		table[9].each_with_index {|val, index| table[9][index] = ['reduce', 11] }

		table[10][words["("]] = ['shift', 31]

		table[11][words["("]] = ['shift', 32]

		table[12][words["("]] = ['shift', 33]

		table[13][words["("]] = ['shift', 34]

		table[14][words[":="]] = ['shift', 35]
		table[14][words[";"]] = ['reduce', 7]
		table[14][words["default"]] = ['goto', 36]

		table[15].each_with_index {|val, index| table[15][index] = ['reduce', 8] }

		table[16].each_with_index {|val, index| table[16][index] = ['reduce', 9] }

		table[17][words[":="]] = ['shift', 37]

		table[18][words[";"]] = ['shift', 38]

		table[19][words["("]] = ['shift', 39]

		table[20][words["("]] = ['shift', 40]

		table[21].each_with_index {|val, index| table[21][index] = ['reduce', 29] }

		table[22][words["ID"]] = ['shift', 41]
		table[22][words["NUM"]] = ['shift', 42]
		table[22][words["NULL"]] = ['shift', 43]
		table[22][words["TRUE"]] = ['shift', 44]
		table[22][words["FALSE"]] = ['shift', 45]
		table[22][words["NOT"]] = ['shift', 46]
		table[22][words["expression"]] = ['goto', 47]
		table[22][words["simple_expression"]] = ['goto', 48]
		table[22][words["term"]] = ['goto', 49]
		table[22][words["factor"]] = ['goto', 50]

		table[23][words["ID"]] = ['shift', 41]
		table[23][words["NUM"]] = ['shift', 42]
		table[23][words["NULL"]] = ['shift', 43]
		table[23][words["TRUE"]] = ['shift', 44]
		table[23][words["FALSE"]] = ['shift', 45]
		table[23][words["NOT"]] = ['shift', 46]
		table[23][words["expression"]] = ['goto', 51]
		table[23][words["simple_expression"]] = ['goto', 48]
		table[23][words["term"]] = ['goto', 49]
		table[23][words["factor"]] = ['goto', 50]

		table[24][words["ID"]] = ['shift', 52]

		table[25].each_with_index {|val, index| table[25][index] = ['reduce', 26] }

		table[26][words["END"]] = ['shift', 53]

		table[27][words[";"]] = ['shift', 54]
		table[27][words["END"]] = ['reduce', 22]

		table[28].each_with_index {|val, index| table[28][index] = ['reduce', 23] }

		table[29].each_with_index {|val, index| table[29][index] = ['reduce', 25] }

		table[30].each_with_index {|val, index| table[30][index] = ['reduce', 1] }

		table[31][words["NUM"]] = ['shift', 55]
		table[31][words[")"]] = ['reduce', 13]
		table[31][words["size"]] = ['goto', 56]

		table[32][words["NUM"]] = ['shift', 55]
		table[32][words[")"]] = ['reduce', 13]
		table[32][words["size"]] = ['goto', 57]

		table[33][words["NUM"]] = ['shift', 55]
		table[33][words[")"]] = ['reduce', 13]
		table[33][words["size"]] = ['goto', 58]

		table[34][words["NUM"]] = ['shift', 55]
		table[34][words[")"]] = ['reduce', 13]
		table[34][words["size"]] = ['goto', 59]

		table[35][words["ID"]] = ['shift', 41]
		table[35][words["NUM"]] = ['shift', 42]
		table[35][words["NULL"]] = ['shift', 43]
		table[35][words["TRUE"]] = ['shift', 44]
		table[35][words["FALSE"]] = ['shift', 45]
		table[35][words["NOT"]] = ['shift', 46]
		table[35][words["C"]] = ['shift', 60]
		table[35][words["righthandside"]] = ['goto', 61]
		table[35][words["expression"]] = ['goto', 62]
		table[35][words["simple_expression"]] = ['goto', 48]
		table[35][words["term"]] = ['goto', 49]
		table[35][words["factor"]] = ['goto', 50]

		table[36][words[";"]] = ['shift', 63]

		table[37][words["ID"]] = ['shift', 41]
		table[37][words["NUM"]] = ['shift', 42]
		table[37][words["NULL"]] = ['shift', 43]
		table[37][words["TRUE"]] = ['shift', 44]
		table[37][words["FALSE"]] = ['shift', 45]
		table[37][words["NOT"]] = ['shift', 46]
		table[37][words["C"]] = ['shift', 60]
		table[37][words["righthandside"]] = ['goto', 64]
		table[37][words["expression"]] = ['goto', 62]
		table[37][words["simple_expression"]] = ['goto', 48]
		table[37][words["term"]] = ['goto', 49]
		table[37][words["factor"]] = ['goto', 50]

		table[38].each_with_index {|val, index| table[38][index] = ['reduce', 21] }

		table[39][words["ID"]] = ['shift', 65]

		table[40][words["ID"]] = ['shift', 66]

		table[41].each_with_index {|val, index| table[41][index] = ['reduce', 42] }

		table[42].each_with_index {|val, index| table[42][index] = ['reduce', 43] }

		table[43].each_with_index {|val, index| table[43][index] = ['reduce', 46] }

		table[44].each_with_index {|val, index| table[44][index] = ['reduce', 44] }

		table[45].each_with_index {|val, index| table[45][index] = ['reduce', 45] }

		table[46][words["ID"]] = ['shift', 41]
		table[46][words["NUM"]] = ['shift', 42]
		table[46][words["NULL"]] = ['shift', 43]
		table[46][words["TRUE"]] = ['shift', 44]
		table[46][words["FALSE"]] = ['shift', 45]
		table[46][words["NOT"]] = ['shift', 46]
		table[46][words["factor"]] = ['goto', 67]

		table[47][words["THEN"]] = ['shift', 68]

		table[48][words[">"]] = ['shift', 69]
		table[48][words[">="]] = ['shift', 70]
		table[48][words["="]] = ['shift', 71]
		table[48][words["<="]] = ['shift', 72]
		table[48][words["<"]] = ['shift', 73]
		table[48][words["<>"]] = ['shift', 74]
		table[48][words["+"]] = ['shift', 75]
		table[48][words["-"]] = ['shift', 76]
		table[48][words["END"]] = ['reduce', 36]
		table[48][words["THEN"]] = ['reduce', 36]
		table[48][words["LOOP"]] = ['reduce', 36]
		table[48][words[";"]] = ['reduce', 36]
		table[48][words["relop"]] = ['goto', 77]
		table[48][words["addop"]] = ['goto', 78]

		table[49][words["MOD"]] = ['shift', 79]
		table[49][words["*"]] = ['shift', 80]
		table[49][words["/"]] = ['shift', 81]
		table[49][words["END"]] = ['reduce', 38]
		table[49][words["THEN"]] = ['reduce', 38]
		table[49][words["LOOP"]] = ['reduce', 38]
		table[49][words[";"]] = ['reduce', 38]
		table[49][words[">"]] = ['reduce', 38]
		table[49][words[">="]] = ['reduce', 38]
		table[49][words["="]] = ['reduce', 38]
		table[49][words["<="]] = ['reduce', 38]
		table[49][words["<"]] = ['reduce', 38]
		table[49][words["<>"]] = ['reduce', 38]
		table[49][words["+"]] = ['reduce', 38]
		table[49][words["-"]] = ['reduce', 38]
		table[49][words["mulop"]] = ['goto', 82]

		table[50].each_with_index {|val, index| table[50][index] = ['reduce', 40] }

		table[51][words["LOOP"]] = ['shift', 83]

		table[52].each_with_index {|val, index| table[52][index] = ['reduce', 30] }

		table[53][words[";"]] = ['shift', 84]

		table[54][words["ID"]] = ['shift', 17]
		table[54][words["BEGIN"]] = ['shift', 6]
		table[54][words["DBMS_OUTPUT.PUT_LINE"]] = ['shift', 19]
		table[54][words["DBMS_OUTPUT.PUT"]] = ['shift', 20]
		table[54][words["DBMS_OUTPUT.NEW_LINE"]] = ['shift', 21]
		table[54][words["IF"]] = ['shift', 22]
		table[54][words["WHILE"]] = ['shift', 23]
		table[54][words["&"]] = ['shift', 24]
		table[54][words["compound_statement"]] = ['goto', 25]
		table[54][words["statement"]] = ['goto', 85]
		table[54][words["lefthandside"]] = ['goto', 29]

		table[55][words[","]] = ['shift', 86]
		table[55][words[")"]] = ['reduce', 15]
		table[55][words["size_option"]] = ['goto', 87]

		table[56][words[")"]] = ['shift', 88]

		table[57][words[")"]] = ['shift', 89]

		table[58][words[")"]] = ['shift', 90]

		table[59][words[")"]] = ['shift', 91]

		table[60].each_with_index {|val, index| table[60][index] = ['reduce', 35] }

		table[61].each_with_index {|val, index| table[61][index] = ['reduce', 6] }

		table[62].each_with_index {|val, index| table[62][index] = ['reduce', 34] }

		table[63][words["ID"]] = ['shift', 4]
		table[63][words["BEGIN"]] = ['reduce', 5]
		table[63][words["declare_rest"]] = ['goto', 92]

		table[64].each_with_index {|val, index| table[64][index] = ['reduce', 33] }

		table[65][words[")"]] = ['shift', 93]

		table[66][words[")"]] = ['shift', 94]

		table[67].each_with_index {|val, index| table[67][index] = ['reduce', 47] }

		table[68][words["ID"]] = ['shift', 17]
		table[68][words["BEGIN"]] = ['shift', 6]
		table[68][words["DBMS_OUTPUT.PUT_LINE"]] = ['shift', 19]
		table[68][words["DBMS_OUTPUT.PUT"]] = ['shift', 20]
		table[68][words["DBMS_OUTPUT.NEW_LINE"]] = ['shift', 21]
		table[68][words["IF"]] = ['shift', 22]
		table[68][words["WHILE"]] = ['shift', 23]
		table[68][words["&"]] = ['shift', 24]
		table[68][words["compound_statement"]] = ['goto', 25]
		table[68][words["statement"]] = ['goto', 95]
		table[68][words["lefthandside"]] = ['goto', 29]

		table[69].each_with_index {|val, index| table[69][index] = ['reduce', 48] }

		table[70].each_with_index {|val, index| table[70][index] = ['reduce', 49] }

		table[71].each_with_index {|val, index| table[71][index] = ['reduce', 50] }

		table[72].each_with_index {|val, index| table[72][index] = ['reduce', 51] }

		table[73].each_with_index {|val, index| table[73][index] = ['reduce', 52] }

		table[74].each_with_index {|val, index| table[74][index] = ['reduce', 53] }

		table[75].each_with_index {|val, index| table[75][index] = ['reduce', 54] }

		table[76].each_with_index {|val, index| table[76][index] = ['reduce', 55] }

		table[77][words["ID"]] = ['shift', 41]
		table[77][words["NUM"]] = ['shift', 42]
		table[77][words["NULL"]] = ['shift', 43]
		table[77][words["TRUE"]] = ['shift', 44]
		table[77][words["FALSE"]] = ['shift', 45]
		table[77][words["NOT"]] = ['shift', 46]
		table[77][words["simple_expression"]] = ['goto', 96]
		table[77][words["term"]] = ['goto', 49]
		table[77][words["factor"]] = ['goto', 50]

		table[78][words["ID"]] = ['shift', 41]
		table[78][words["NUM"]] = ['shift', 42]
		table[78][words["NULL"]] = ['shift', 43]
		table[78][words["TRUE"]] = ['shift', 44]
		table[78][words["FALSE"]] = ['shift', 45]
		table[78][words["NOT"]] = ['shift', 46]
		table[78][words["term"]] = ['goto', 97]
		table[78][words["factor"]] = ['goto', 50]

		table[79].each_with_index {|val, index| table[79][index] = ['reduce', 58] }

		table[80].each_with_index {|val, index| table[80][index] = ['reduce', 56] }

		table[81].each_with_index {|val, index| table[81][index] = ['reduce', 57] }

		table[82][words["ID"]] = ['shift', 41]
		table[82][words["NUM"]] = ['shift', 42]
		table[82][words["NULL"]] = ['shift', 43]
		table[82][words["TRUE"]] = ['shift', 44]
		table[82][words["FALSE"]] = ['shift', 45]
		table[82][words["NOT"]] = ['shift', 46]
		table[82][words["factor"]] = ['goto', 98]

		table[83][words["ID"]] = ['shift', 17]
		table[83][words["BEGIN"]] = ['shift', 6]
		table[83][words["DBMS_OUTPUT.PUT_LINE"]] = ['shift', 19]
		table[83][words["DBMS_OUTPUT.PUT"]] = ['shift', 20]
		table[83][words["DBMS_OUTPUT.NEW_LINE"]] = ['shift', 21]
		table[83][words["IF"]] = ['shift', 22]
		table[83][words["WHILE"]] = ['shift', 23]
		table[83][words["&"]] = ['shift', 24]
		table[83][words["compound_statement"]] = ['goto', 25]
		table[83][words["statement"]] = ['goto', 99]
		table[83][words["lefthandside"]] = ['goto', 29]

		table[84].each_with_index {|val, index| table[84][index] = ['reduce', 20] }

		table[85].each_with_index {|val, index| table[85][index] = ['reduce', 24] }

		table[86][words["NUM"]] = ['shift', 100]

		table[87].each_with_index {|val, index| table[87][index] = ['reduce', 12] }

		table[88].each_with_index {|val, index| table[88][index] = ['reduce', 16] }

		table[89].each_with_index {|val, index| table[89][index] = ['reduce', 17] }

		table[90].each_with_index {|val, index| table[90][index] = ['reduce', 18] }

		table[91].each_with_index {|val, index| table[91][index] = ['reduce', 19] }

		table[92].each_with_index {|val, index| table[92][index] = ['reduce', 4] }

		table[93].each_with_index {|val, index| table[93][index] = ['reduce', 27] }

		table[94].each_with_index {|val, index| table[94][index] = ['reduce', 28] }

		table[95][words["END"]] = ['shift', 101]

		table[96][words["+"]] = ['shift', 75]
		table[96][words["-"]] = ['shift', 76]
		table[96][words["END"]] = ['reduce', 37]
		table[96][words["THEN"]] = ['reduce', 37]
		table[96][words["LOOP"]] = ['reduce', 37]
		table[96][words[";"]] = ['reduce', 37]
		table[96][words["addop"]] = ['goto', 78]

		table[97][words["MOD"]] = ['shift', 79]
		table[97][words["*"]] = ['shift', 80]
		table[97][words["/"]] = ['shift', 81]
		table[97][words["END"]] = ['reduce', 39]
		table[97][words["THEN"]] = ['reduce', 39]
		table[97][words["LOOP"]] = ['reduce', 39]
		table[97][words[";"]] = ['reduce', 39]
		table[97][words[">"]] = ['reduce', 39]
		table[97][words[">="]] = ['reduce', 39]
		table[97][words["="]] = ['reduce', 39]
		table[97][words["<="]] = ['reduce', 39]
		table[97][words["<"]] = ['reduce', 39]
		table[97][words["<>"]] = ['reduce', 39]
		table[97][words["+"]] = ['reduce', 39]
		table[97][words["-"]] = ['reduce', 39]
		table[97][words["mulop"]] = ['goto', 82]

		table[98].each_with_index {|val, index| table[98][index] = ['reduce', 41] }

		table[99][words["END"]] = ['shift', 102]

		table[100].each_with_index {|val, index| table[100][index] = ['reduce', 14] }

		table[101][words["IF"]] = ['shift', 103]

		table[102][words["LOOP"]] = ['shift', 104]

		table[103].each_with_index {|val, index| table[103][index] = ['reduce', 31] }

		table[104].each_with_index {|val, index| table[104][index] = ['reduce', 32] }

	end

end