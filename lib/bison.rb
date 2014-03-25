require_relative 'bison/symbols'
require_relative 'bison/token'
require_relative 'bison/scanner'

def unitTests

	# Test creation of symbol table & addition of a token
	symbols = Symbols.new(0) # crate new hash for each scope (0 in this case)
	symbols.add("num", "name", "value")
	if symbols.has "name"
		puts "Table creation:      Passed"
	else
		puts "Table creation:      Failed"
	end

	# Test collision detection for adding tokens
	unless symbols.add("string", "name", "value")
		puts "Collision detection: Passed" 
	else
		puts "Collision detection: Failed" 
	end

	# Test token detection
	unless symbols.has("test")
		puts "Token detection:     Passed" 
	else
		puts "Token detection:     Failed" 
	end

	# Test token retreval
	newToken = symbols.get("name")
	unless newToken == nil
		puts "Token retreval:      Passed" 
	else
		puts "Token retreval:      Failed" 
	end

	# Test token type detection
	if symbols.get("name").type == "num" && symbols.get("name").type != "string"
		puts "Type detection:      Passed" 
	else
		puts "Type detection:      Failed"
	end

end

# Run unit tests
unitTests

scanner = Scanner.new(ARGV[0]) # Test scanner by passing simple program.

puts scanner.nextToken()

puts ""