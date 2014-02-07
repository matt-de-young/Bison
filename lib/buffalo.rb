require_relative 'buffalo/symbols'
require_relative 'buffalo/token'

token = Token.new("int", "i", "7", "0")

hash = Hash.new
hash[token.name] = token

newToken = hash["i"]
newToken.display_details
