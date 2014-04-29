class Generator

	def initialize(name)

		# Create file out output intermediate code

		@code = Array.new
		@line = 0

		name << ".jam"	# append the file extesion
		@file = File.open(name, 'w')

	end

	def gen(rule, token)

		puts "#{rule}, #{token}"	# REMOVE

		case rule

			when 4
				puts "#{@line} STO \##{token[0][1]},, #{token[2][1]}"	# REMOVE
				@code << "#{@line} STO \##{token[0][1]},, #{token[2][1]}"
				@line += 1

			when 33
				puts "#{@line} STO \##{token[0][1]},, #{token[2][1]}"	# REMOVE
				@code << "#{@line} STO \##{token[0][1]},, #{token[2][1]}"
				@line += 1

		end

	end

	def close

		#@file.write(@code)
		@code.each { |line| @file.puts(line) } 

	end

end
