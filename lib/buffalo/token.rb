class Token
    def initialize(type, token, value, scope)
        @type = type
        @token = token
        @value = value
        @scope = scope
    end
    
    def display_details()
        puts "Type: #@type"
        puts "Token: #@token"
        puts "Value: #@value"
    end
    
end