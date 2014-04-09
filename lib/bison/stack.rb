class Stack

	def initialize

		@stack = Array.new
		@stack.push(0)

	end

	# Push(State), Push(Token)
	def shift(token, state)

		stack.push(token)
		stack.push(state)

	end

	def pop

		state = stack.pop()
		token = stack.pop()

		ary = [token, state]	# Returns ary

	end

	def peek

		state = @stack.pop()

		@stack.push(state)

		return state 

	end

	def push(state)

	@stack.push(state)

	end
		
end