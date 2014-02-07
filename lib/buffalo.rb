require_relative 'buffalo/symbols'
require_relative 'buffalo/token'

symbols = Symbols.new(0) # crate new hash for each scope (function)
symbols.add("num", "name", "value")

puts "name already exists!" if symbols.add("string", "name", "value") == false

puts "test exists" if symbols.has("test")
puts "test does not exist" unless symbols.has("test")

#newToken = hash["i"]
#newToken.display_details
