class Scanner
		
	def initialize()
		# This should probably be put in with the parser whenever that is built.
		reserved = ['--', '/*', '*/', 'BOOLEAN', 'INT', 'NUMBER', 'SMALLINT', 'POSITIVE', 'CHAR', 'BEGIN', 'DECLARE', 'END', 'IF', 'THEN', 'WHILE', 'LOOP', 'TRUE', 'FALSE', 'NULL', 'NOT', 'DBMS_OUTPUT', 'PUT_LINE', 'PUT', 'NEW_LINE', '&', '$', '+', '-', '*', '/', 'MOD','(', ')', '>', '>=', '=', '<=', '<', '<>', ]
	end
	
enddef

	# Returns next full token
	def nextToken()

	end
		
end