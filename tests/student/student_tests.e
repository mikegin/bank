note
	description: "Studenst write their tessts here"
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	STUDENT_TESTS

inherit
	ES_TEST

create
	make

feature {NONE} -- Initialization
	zero: VALUE
	make
			-- Initialization for `Current'.
		do
			zero := "0"
			add_boolean_case (agent t1)
			add_boolean_case (agent t2)
			add_boolean_case (agent t3)
		end

feature -- tests
	t1: BOOLEAN
		local
			b: BANK
			l_cst: LIST[CUSTOMER]
		do
			comment("t1: test 'new' bank operation on more scrambled inputs")
			create b.make
			b.new ("Steve")
			Result := b.count = 1 and b.total = zero
			check Result end
			b.new ("Ben")
			Result := b.count = 2 and b.total = zero
			check Result end
			b.new ("Roger")
			Result := b.count = 3 and b.total = zero
			check Result end
			b.new ("Tom")
			Result := b.count = 4 and b.total = zero
			check Result end
			l_cst := b.customers
			Result := l_cst[1].name ~ "Ben"
				and l_cst[2].name ~ "Roger"
				and l_cst[3].name ~ "Steve"
				and l_cst[4].name ~ "Tom"
				and l_cst[1].balance = zero
				and l_cst[2].balance = zero
				and l_cst[3].balance = zero
				and l_cst[4].balance = zero
			sub_comment("<br>Customers are sorted by name")
		end

	t2_string: STRING = "[
name: Ben, balance: 203.05
name: Pam, balance: 450.57
name: Steve, balance: 666.66

						]"
	t2: BOOLEAN
		local
			b: BANK
		do
			comment("t2: test 3-way 'transfer' bank operation where bank accounts end up the same as they started")
			create b.make
			b.new ("Steve")
			b.new ("Ben")
			b.new ("Pam")
			b.deposit ("Ben", "203.05")
			b.deposit ("Pam", "450.57")
			b.deposit ("Steve", "666.66")
			b.transfer ("Ben", "Pam", "72.22")
			b.transfer ("Pam", "Steve", "72.22")
			b.transfer ("Steve", "Ben", "72.22")
			sub_comment(b.out.count.out + " chars, actual: <br>" + b.out)
			sub_comment(t2_string.count.out + " chars, expected: <br>" + t2_string)
			Result := b.out ~ t2_string
		end

t3_string: STRING = "[
name: Ben, balance: 99.99
name: Steve, balance: 100.00

					]"
	t3: BOOLEAN
		local
			b: BANK
		do
			comment("t3: test decimal place rounding")
			create b.make
			b.new ("Ben")
			b.deposit ("Ben", "99.99")
			b.new ("Steve")
			b.deposit ("Steve", "99.9999")
			sub_comment(b.out.count.out + " chars, actual: <br>" + b.out)
			sub_comment(t3_string.count.out + " chars, expected: <br>" + t3_string)
			Result := b.out ~ t3_string
		end

end
