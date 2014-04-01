class Parser
		
	attr_accessor :scanner, :words, :symbols

	def initialize()

		@scanner = Scanner.new(ARGV[0])

		# Contains all reserved words
		@words = Hash.new
		self.populate(@words)

		puts self.words["INT"]

		# Contains all user defined variables
		@symbols = Symbols.new(0)

		@stack = Stack.new

	end
		
	def populate(words)

		# For now, the string is the key. It may make more sence in the future to switch this
		self.words["BOOLEAN"] = 1
		self.words["NUMBER"] = 2
		self.words["INT"] = 3
		self.words["SMALLINT"] = 4
		self.words["POSITIVE"] = 5
		self.words["CHAR"] = 6
		self.words["BEGIN"] = 7
		self.words["DECLARE"] = 8
		self.words["END"] = 9
		self.words["IF"] = 10
		self.words["THEN"] = 11
		self.words["WHILE"] = 12
		self.words["LOOP"] = 13
		self.words["TRUE"] = 14
		self.words["FALSE"] = 15
		self.words["NULL"] = 16
		self.words["NOT"] = 17
		self.words["DBMS_OUTPUT"] = 18
		self.words["PUT"] = 19
		self.words["PUT_LINE"] = 20
		self.words["NEW_LINE"] = 21
		self.words["&"] = 22
		self.words["$"] = 23
		self.words["+"] = 24
		self.words["-"] = 25
		self.words["*"] = 26
		self.words["/"] = 27
		self.words["MOD"] = 28
		self.words["."] = 29
		self.words["("] = 30
		self.words[")"] = 31
		self.words[">"] = 32
		self.words[">="] = 33
		self.words["="] = 34
		self.words["<="] = 35
		self.words["<"] = 36
		self.words["<>"] = 37

	end

end