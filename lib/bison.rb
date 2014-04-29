require_relative 'bison/symbols'
require_relative 'bison/token'
require_relative 'bison/scanner'
require_relative 'bison/parser'
require_relative 'bison/stack'
require_relative 'bison/generator'

puts ""

def unitTests

	# Test creation of symbol table & addition of a token
	symbols = Symbols.new(0) # crate new hash for each scope (0 in this case)
	symbols.add("num", "name", "type", "size", "value")
	puts "Table creation:      Failed" unless symbols.has "name"

	# Test collision detection for adding tokens
	puts "Collision detection: Failed" if symbols.add("num", "name", "type", "size", "value")

	# Test token detection
	puts "Token detection:     Failed" if symbols.has("test")

	# Test token retreval
	newToken = symbols.get("name")
	puts "Token retreval:      Failed" if newToken == nil

	# Test token type detection
	puts "Type detection:      Failed" unless symbols.get("name").type == "type" && symbols.get("name").type != "string"

end

# Run unit tests
unitTests

#Test scanner by reading the first 20 tokens of an input. 
#scanner = Scanner.new(ARGV[0])
#puts ""
#i = 0
#while i < 30
#	puts scanner.nextToken()
#	i += 1
#end 

parser = Parser.new
if parser.parse == false
	puts "Source code not syntactially correct"
else
	puts "Source code accepted"
end

puts ""