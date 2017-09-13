note
	description: "Summary description for {BANK_TEST_INSTRUCTOR2}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	BANK_TEST_INSTRUCTOR2

inherit
	ES_TEST

create
	make

feature {NONE} -- Initialization and constants 0 and 1
	zero : VALUE
	one: VALUE

	make
			-- Initialization for `Current'.
		do
			zero := "0"; one := "1"
			add_boolean_case (agent t1)
			add_boolean_case (agent t2)
			add_boolean_case (agent t3)
			add_boolean_case (agent t4)
		end

feature -- tests


	t1: BOOLEAN
		local
			b: BANK
			l_cst: LIST[CUSTOMER] 
		do
			comment("t1: test 'new' bank operation")
			create b.make
			b.new ("Steve")
			Result := b.count = 1 and b.total = zero
			check Result end
			b.new ("Ben")
			Result := b.count = 2
			check Result end
			l_cst := b.customers
			Result := l_cst[1].name ~ "Ben"
				and l_cst[2].name ~ "Steve"
				and l_cst[1].balance = zero
				and l_cst[2].balance = zero
			sub_comment("<br>Customers are sorted by name")
		end

	t2_string: STRING = "[
name: Ben, balance: 123.45
name: Pam, balance: 324.42
name: Steve, balance: 0.00

						]"
	t2: BOOLEAN
		local
			b: BANK
			l_string: STRING
		do
			comment("t2: test 'deposit' bank operation")
			create b.make
			b.new ("Steve")
			b.new ("Ben")
			b.new ("Pam")
			b.deposit ("Ben", "123.45")
			b.deposit ("Pam", "324.42")
			sub_comment(b.out.count.out + " chars, actual: <br>" + b.out)
			sub_comment(t2_string.count.out + " chars, expected: <br>" + t2_string)
			l_string := t2_string
			Result := b.out ~ t2_string
		end

	t3_string: STRING = "[
name: Ben, balance: 0.03
name: Pam, balance: 324.44
name: Steve, balance: 1006.99

						]"
	t3: BOOLEAN
		local
			b: BANK
			l_string: STRING
		do
			comment("t3: test 'withdraw' bank operation")
			create b.make
			b.new ("Steve")
			b.new ("Ben")
			b.new ("Pam")
			b.deposit ("Ben", "123.45")
			b.deposit ("Pam", "324.44")
			b.withdraw("Ben", "23.42")
			b.withdraw("Ben", "100.00")
			b.deposit ("Steve", "1006.99")
			sub_comment(b.out.count.out + " chars, actual: <br>" + b.out)
			sub_comment(t2_string.count.out + " chars, expected: <br>" + t3_string)
			l_string := t3_string
			Result := b.out ~ t3_string
		end

	t4_string: STRING = "[
name: Ben, balance: 507.02
name: Pam, balance: 198.94
name: Steve, balance: 625.50

						]"
	t4: BOOLEAN
		local
			b: BANK
			l_string: STRING
		do
			comment("t4: test 'transfer' bank operation")
			create b.make
			b.new ("Steve")
			b.new ("Ben")
			b.new ("Pam")
			b.deposit ("Ben", "123.45")
			b.deposit ("Pam", "324.44")
			b.withdraw("Ben", "23.42")
			b.transfer ("Pam", "Steve", "125.50") -- new
			b.withdraw("Ben", "100.00")
			b.deposit ("Steve", "1006.99")
			b.transfer("Steve", "Ben", "506.99") -- new
			sub_comment(b.out.count.out + " chars, actual: <br>" + b.out)
			sub_comment(t2_string.count.out + " chars, expected: <br>" + t4_string)
			l_string := t3_string
			Result := b.out ~ t4_string
		end

end
