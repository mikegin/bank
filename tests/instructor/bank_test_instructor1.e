note
	description: "Summary description for {BANK_TEST_INSTRUCTOR1}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	BANK_TEST_INSTRUCTOR1

inherit
	ES_TEST

create
	make

feature {NONE} -- Initialization

	make
			-- Initialization for `Current'.
		do
			add_boolean_case (agent t1)
			add_boolean_case (agent t2)
			add_boolean_case (agent t3)
			add_boolean_case (agent t4)
			add_boolean_case (agent t5)
		end

feature -- queries
	equal_values_with_across(v1,v2: VALUE): BOOLEAN
		local
			l_across: BOOLEAN
		do
			Result := v1.precise_out.count = v2.precise_out.count
			if Result then
				l_across :=
					across 1 |..| v1.precise_out.count as i all
						v1.precise_out[i.item] = v2.precise_out[i.item]
					end
			end
			Result := Result and l_across
		ensure
			same_count: Result implies (v1.precise_out.count = v2.precise_out.count)
			same_characters: Result implies
				across 1 |..| v1.precise_out.count as i all
					v1.precise_out[i.item] = v2.precise_out[i.item]
				end
		end

	equal_values(v1,v2: VALUE): BOOLEAN
			-- Is `v1' equal to `v2' at the string level?
			-- There might be a problem with this query
		local
			l_equal: BOOLEAN
			i: INTEGER
		do
			-- do they have the same length?
			Result := v1.precise_out.count = v2.precise_out.count
			if Result then
				from
				l_equal := true
					i := 1
				until
					i > v1.precise_out.count or l_equal = false
				loop
					l_equal := v1.precise_out[i] ~ v2.precise_out[i]
					i := i + 1
				end
			end
			Result := Result and l_equal
		ensure
			values_are_equal:
				Result = equal_values_with_across (v1, v2)
		end

feature -- tests

	t1: BOOLEAN
		local
			v1, v2: VALUE
		do
			comment("t1: test expanded class VALUE;")
			v1 := "0.1"
			v2 := "2.8"
			Result := v1 + v2 = "2.9"

			-- sub-comments from the new ESpec
			sub_comment ("Due to expanded VALUE, can use = rather than ~, e.g.: v1 + v2 = %"2.9%"")
			sub_comment("v1.out ~ %"-42.85%" and v1.precise_out ~ %"-42.8451%"")

			check Result end
			v1 := "0"
			v2 := "1"
			Result := v1 = v1.zero and v2 = v2.one
			check Result end
			v1 := "-42.8451"
			Result := v1.out ~ "-42.85" and v1.precise_out ~ "-42.8451"
		end

	t2: BOOLEAN
		local
			v1,v2,v3, v4, v5: VALUE
		do
			comment("t2: using a contract with 'across' to check value equality")
			v1 := "123"; v2 := "124"; v3 := "1234"; v4 := "123"; v5 := "213"
			Result := not equal_values (v1,v2)
			check Result end
			Result := not equal_values (v1,v3)
			check Result end
			Result := equal_values (v1,v4)
			check Result end
			Result := not equal_values (v1,v5)

			-- see what happens if you change v4 to v5
			assert_equal ("should be equal:", v1.precise_out, v4.precise_out)
		end

	t3: BOOLEAN
		local
			a, b: ACCOUNT
		do
			comment("t3: deposit and withdraw from an ACCOUNT")
			create a.make_with_name ("Steve")
			Result := a.balance = a.balance.zero
			a.deposit ("121.455")
			a.withdraw("1.00")
			Result := a.balance.out ~ "120.46"
				and a.balance.precise_out ~ "120.455"
			check Result end
			sub_comment("a.balance.out is rounded to two decimal places")
			create b.make_with_name ("Steve")
			b.deposit ("120.455")
			Result := a /= b and a ~ b
			sub_comment("Also checks account reference and object equality via is_equal")
		end

	t4: BOOLEAN
		local
			c: CUSTOMER
			a: ACCOUNT
			zero, one: VALUE
		do
			comment ("t4: test CUSTOMER name and balances")
			zero := "0"; one := "1"
			create c.make ("Steve")
			a := c.account

			-- try the assert with one rather than zero
			assert ("Is Steve's account ok?",
				a.name ~ "Steve" and a.balance = zero, c)

			Result := c.name ~ "Steve" and c.balance = zero
		end

	t5: BOOLEAN
		local
			c1,c2, c3: CUSTOMER
			zero, one: VALUE
		do
			comment ("t5: test CUSTOMER object equality")
			zero := "0"; one := "1"
			create c1.make ("Steve")
			create c2.make ("Steve")
			c2.account.deposit ("1425.50")
			create c3.make ("Steve")
			Result := c1 /~ c2
			check Result end
			Result := c1 ~ c3 and c1 /= c3
		end

end
