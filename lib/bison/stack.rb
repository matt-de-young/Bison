class Stack

	def initialize

		@stack = Array.new
		@stack.push(0)

	end

	# Push(State), Push(Token)
	def push(state, token)

		@stack.push(token)	# Push with token on bellow state
		@stack.push(state)

	end

	def pop

		state = @stack.pop()
		token = @stack.pop()	# Returns token

	end

	def peek

		state = @stack.pop()

		@stack.push(state)

		return state 

	end

	def print

		puts @stack

	end

end