require_relative 'buffalo/symbols'
require_relative 'buffalo/token'

token = Token.new("int", "i", "7")

hash = Hash.new # crate new hash for each scope (function)
hash[token.name] = token

newToken = hash["i"]
newToken.display_details
