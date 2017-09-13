note
	description: "Summary description for {BANK_TEST}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	BANK_TEST_CONTRACTS1
inherit
	ES_TEST
create
	make

feature
	make
		do
			-- precondition violations of new
			add_violation_case_with_tag ("customer_not_already_present", agent t_new_pre_1)

			-- precondition violations of deposit
			add_violation_case_with_tag ("customer_exists", agent t_deposit_pre_1)
			add_violation_case_with_tag ("customer_exists", agent t_deposit_pre_2)
			add_violation_case_with_tag ("positive_amount", agent t_deposit_pre_3)
			add_violation_case_with_tag ("positive_amount", agent t_deposit_pre_4)

			-- precondition violations of withdraw
			add_violation_case_with_tag ("customer_exists", agent t_withdraw_pre_1)
			add_violation_case_with_tag ("customer_exists", agent t_withdraw_pre_2)
			add_violation_case_with_tag ("positive_amount", agent t_withdraw_pre_3)
			add_violation_case_with_tag ("positive_amount", agent t_withdraw_pre_4)
			add_violation_case_with_tag ("sufficient_balance", agent t_withdraw_pre_5)

			-- precondition violations of transfer
			add_violation_case_with_tag ("distinct_accounts", agent t_transfer_pre_1)
			add_violation_case_with_tag ("customer1_exists", agent t_transfer_pre_2)
			add_violation_case_with_tag ("customer2_exists", agent t_transfer_pre_3)
			add_violation_case_with_tag ("sufficient_balance", agent t_transfer_pre_4)

			-- postconditions of new
			add_boolean_case (agent t_new_total_balance_unchanged)
			add_boolean_case (agent t_new_num_customers_increased)
			add_boolean_case (agent t_new_customer_added_to_the_end)
			add_boolean_case (agent t_new_other_customers_unchanged)

			-- postconditions of deposit
			add_boolean_case (agent t_deposit_total_balance_increased)
			add_boolean_case (agent t_deposit_num_customers_unchanged)
			add_boolean_case (agent t_deposit_customer_balance_increased)
			add_boolean_case (agent t_deposit_other_customers_unchanged)

			-- postconditions of withdraw
			add_boolean_case (agent t_withdraw_total_balance_decreased)
			add_boolean_case (agent t_withdraw_num_customers_unchanged)
			add_boolean_case (agent t_withdraw_customer_balance_decreased)
			add_boolean_case (agent t_withdraw_other_customers_unchanged)

			-- postconditions of transfer
			add_boolean_case (agent t_transfer_total_balance_unchanged)
			add_boolean_case (agent transfer_customer_balance_decreased)
			add_boolean_case (agent transfer_customer_balance_increased)
			add_boolean_case (agent transfer_other_customers_unchanged)
		end

feature -- Test for precondition violation of new.

	t_new_pre_1
		local
			b: BANK
		do
			comment ("t_new_pre_1: add an existing customer")
			create b.make
			check b.customers.count = 0 end
			b.new ("Jim")
			b.new ("Jim")
		end

feature -- Test for precondition violation of deposit.

	t_deposit_pre_1
		local
			b: BANK
			v: VALUE
		do
			comment ("t_deposit_pre_1: deposit on empty bank")
			v := "100.0"
			create b.make
			b.deposit ("Bill", v)
		end

	t_deposit_pre_2
		local
			b: BANK
			v: VALUE
		do
			comment ("t_deposit_pre_2: deposit on non-existing customer")
			v := "100.0"
			create b.make
			b.new ("Steve")
			b.new ("Jeremy")
			b.deposit ("Jim", v)
		end

	t_deposit_pre_3
		local
			b: BANK
			v: VALUE
		do
			comment ("t_deposit_pre_3: deposit 0 on existing customer")
			v := v.zero
			create b.make
			b.new ("Steve")
			b.deposit ("Steve", v)
		end

	t_deposit_pre_4
		local
			b: BANK
			v: VALUE
		do
			comment ("t_deposit_pre_4: deposit negative amount on existing customer")
			v := "-100.0001"
			create b.make
			b.new ("Steve")
			b.deposit ("Steve", v)
		end

feature -- Test for precondition violation of withdraw.

	t_withdraw_pre_1
		local
			b: BANK
			v: VALUE
		do
			comment ("t_withdraw_pre_1: withdraw on empty bank")
			v := "100.0"
			create b.make
			b.withdraw ("Bill", v)
		end

	t_withdraw_pre_2
		local
			b: BANK
			v: VALUE
		do
			comment ("t_withdraw_pre_2: withdraw on non-existing customer")
			v := "100.0"
			create b.make
			b.new ("Steve")
			b.new ("Jeremy")
			b.withdraw ("Jim", v)
		end

	t_withdraw_pre_3
		local
			b: BANK
			v: VALUE
		do
			comment ("t_withdraw_pre_3: withdraw 0 on existing customer")
			v := v.zero
			create b.make
			b.new ("Steve")
			b.withdraw ("Steve", v)
		end

	t_withdraw_pre_4
		local
			b: BANK
			v: VALUE
		do
			comment ("t_withdraw_pre_4: withdraw negative amount on existing customer")
			v := "-100.0001"
			create b.make
			b.new ("Steve")
			b.withdraw ("Steve", v)
		end

	t_withdraw_pre_5
		local
			b: BANK
			v: VALUE
		do
			comment ("t_withdraw_pre_5: withdraw amount exceeding customer's balance")
			v := "100.0001"
			create b.make
			b.new ("Steve")
			b.withdraw ("Steve", v)
		end

feature -- Test for precondition violations of transfer.

	t_transfer_pre_1
		local
			b : BANK
			v1, v2: VALUE
		do
			comment ("t_transfer_precond_1: transfer within one's account disallowed")
			create b.make
			b.new ("Steve")
			b.new ("Bill")
			v1 := "100.0"
			v2 := "100.0"
			b.deposit ("Steve", v1)
			b.deposit ("Bill", v2)

			b.transfer ("Steve", "Steve", v1)
		end

	t_transfer_pre_2
		local
			b : BANK
			v1, v2: VALUE
		do
			comment ("t_transfer_precond_2: non-existing source account")
			create b.make
			b.new ("Steve")
			b.new ("Bill")
			v1 := "100.0"
			v2 := "100.0"
			b.deposit ("Steve", v1)
			b.deposit ("Bill", v2)

			b.transfer ("Jim", "Bill", v1)
		end

	t_transfer_pre_3
		local
			b : BANK
			v1, v2: VALUE
		do
			comment ("t_transfer_precond_3: non-existing target account")
			create b.make
			b.new ("Steve")
			b.new ("Bill")
			v1 := "100.0"
			v2 := "100.0"
			b.deposit ("Steve", v1)
			b.deposit ("Bill", v2)

			b.transfer ("Steve", "Jim", v1)
		end

	t_transfer_pre_4
		local
			b : BANK
			v1, v2, v3: VALUE
		do
			comment ("t_transfer_precond_4: insufficient balance for the source account")
			create b.make
			b.new ("Steve")
			b.new ("Bill")
			v1 := "100.0"
			v2 := "100.0"
			b.deposit ("Steve", v1)
			b.deposit ("Bill", v2)

			v3 := "101.0"

			b.transfer ("Steve", "Bill", v3)
		end

feature -- Test for postconditions of new.

	t_new_total_balance_unchanged : BOOLEAN
		local
			b : BANK
			old_total_balance: VALUE
			v1, v2: VALUE
		do
			comment ("t_new_total_balance_unchanged : total balance unchanged")
			create b.make

			-- check 1: adding the very first customer
			old_total_balance := b.sum_of_all_balances
			b.new ("Bill")
			Result := b.sum_of_all_balances = old_total_balance
			check Result end

			-- check 2: adding a customer when there're existing ones
			old_total_balance := b.sum_of_all_balances
			b.new ("Steve")
			Result := b.sum_of_all_balances = old_total_balance
			check Result end

			-- check 3: adding a customer when there were deposit's performed
			v1 := "100.0"
			b.deposit ("Bill", v1)
			v2 := "200.2"
			b.deposit ("Steve", v1)
			old_total_balance := b.sum_of_all_balances
			b.new ("Jim")
			Result := b.sum_of_all_balances = old_total_balance
			check Result end
		end

	t_new_num_customers_increased : BOOLEAN
		local
			b : BANK
			old_num_customers: INTEGER
			v1, v2: VALUE
		do
			comment ("t_new_num_customers_increased : number of customers increased")
			create b.make

			-- check 1: adding the very first customer
			old_num_customers := b.count
			b.new ("Bill")
			Result := b.count = old_num_customers + 1
			check Result end

			-- check 2: adding a customer when there're existing ones
			old_num_customers := b.count
			b.new ("Steve")
			Result := b.count = old_num_customers + 1
			check Result end

			-- check 3: adding a customer when there were deposit's perfomred
			v1 := "100.0"
			b.deposit ("Bill", v1)
			v2 := "200.2"
			b.deposit ("Steve", v1)
			old_num_customers := b.count
			b.new ("Jim")
			Result := b.count = old_num_customers + 1
			check Result end
		end

	t_new_customer_added_to_the_end : BOOLEAN
		local
			b : BANK
			v1, v2: VALUE
			id: INTEGER
		do
			comment ("t_new_customer_added_to_the_end: new customer added to the of list")
			create b.make

			-- check 1: adding the very first customer
			b.new ("Bill")
			Result :=
				b.customers [b.count].name ~ "Bill" and then
				b.customers [b.count].balance = b.customers [b.count].balance.zero
			check Result end

			-- check 2: adding a customer when there're existing ones
			b.new ("Steve")
			Result :=
				b.customers [b.count].name ~ "Steve" and then
				b.customers [b.count].balance = b.customers [b.count].balance.zero
			check Result end

			-- check 3: adding a customer when there were deposit's perfomred
			v1 := "100.0"
			b.deposit ("Bill", v1)
			v2 := "200.2"
			b.deposit ("Steve", v1)
			b.new ("Jim")
			id := b.customer_id ("Jim")
			Result :=
				b.customers [id].name ~ "Jim" and then
				b.customers [id].balance = b.customers [id].balance.zero

			check Result end
		end

	t_new_other_customers_unchanged : BOOLEAN
		local
			b : BANK
			v1, v2: VALUE
			old_count: INTEGER
			old_customers: LIST[CUSTOMER]
		do
			comment ("t_new_other_customers_unchanged: old list of customers unchanged")
			create b.make

			-- check 1: adding the very first customer
			old_count := b.count
			old_customers := b.customers.deep_twin
			b.new ("Bill")

			Result :=
				across
					1 |..| old_count as i
				all
					b.customers[i.item] ~
						old_customers[i.item]
				end
			check Result end

			-- check 2: adding a customer when there're existing ones
			old_count := b.count
			old_customers := b.customers.deep_twin
			b.new ("Steve")
			Result :=
				across
					1 |..| old_count as i
				all
					b.customers[i.item] ~
						old_customers[i.item]
				end
			check Result end

			-- check 3: adding a customer when there were deposit's performed
			v1 := "100.0"
			b.deposit ("Bill", v1)
			v2 := "200.2"
			b.deposit ("Steve", v1)
			old_count := b.count
			old_customers := b.customers.deep_twin
			b.new ("Tim")
			Result :=
				across
					1 |..| old_count as i
				all
					b.customers[i.item] ~
						old_customers[i.item]
				end
			check Result end
		end

feature -- Test for postconditions of deposit.

	t_deposit_total_balance_increased : BOOLEAN
		local
			b : BANK
			old_total_balance : VALUE
			v1, v2: VALUE
		do
			comment ("t_deposit_total_balance_increased: total balance increased")
			create b.make
			b.new ("Steve")

			old_total_balance := b.sum_of_all_balances
			v1 := "100.0"
			b.deposit ("Steve", v1)
			Result := b.sum_of_all_balances = old_total_balance + v1
			check Result end

			old_total_balance := b.sum_of_all_balances
			v2 := "50.0"
			b.deposit ("Steve", v2)
			Result := b.sum_of_all_balances = old_total_balance + v2
			check Result end
		end

	t_deposit_num_customers_unchanged : BOOLEAN
		local
			b : BANK
			old_num_customers : INTEGER
			v1, v2: VALUE
		do
			comment ("t_deposit_num_customers_unchanged: number of customers unchanged")
			create b.make
			b.new ("Steve")

			old_num_customers := b.count
			v1 := "100.0"
			b.deposit ("Steve", v1)
			Result := b.count = old_num_customers
			check Result end

			old_num_customers := b.count
			v2 := "50.0"
			b.deposit ("Steve", v2)
			Result := b.count = old_num_customers
			check Result end
		end

	t_deposit_customer_balance_increased : BOOLEAN
		local
			b : BANK
			old_customer_balance : VALUE
			v1, v2: VALUE
		do
			comment ("t_deposit_customer_balance_increased: customer's balance increased")

			create b.make
			b.new ("Steve")

			old_customer_balance := b.customer_with_name ("Steve").balance
			v1 := "100.0"
			b.deposit ("Steve", v1)
			Result := b.customer_with_name ("Steve").balance = old_customer_balance + v1
			check Result end

			old_customer_balance := b.customer_with_name ("Steve").balance
			v2 := "50.0"
			b.deposit ("Steve", v2)
			Result := b.customer_with_name ("Steve").balance = old_customer_balance + v2
			check Result end
		end

	t_deposit_other_customers_unchanged : BOOLEAN
		local
			b : BANK
			old_customers : LIST[CUSTOMER]
			v1, v2, v3: VALUE
		do
			comment ("t_deposit_other_customers_unchanged: other customers remain unchanged")

			create b.make
			b.new ("Steve")

			old_customers := b.customers.deep_twin
			v1 := "100.0"
			b.deposit ("Steve", v1)
			Result :=
				across
					1 |..| b.count as i
				all
					(NOT (b.customers[i.item].name ~ "Steve") IMPLIES
						b.customers[i.item] ~ old_customers[i.item])
				end
			check Result end

			old_customers := b.customers.deep_twin
			v2 := "50.0"
			b.deposit ("Steve", v2)
			Result :=
				across
					1 |..| b.count as i
				all
					(NOT (b.customers[i.item].name ~ "Steve") IMPLIES
						b.customers[i.item] ~ old_customers[i.item])
				end
			check Result end

			old_customers := b.customers.deep_twin
			v3 := "40.0"
			b.new ("Tim")
			b.deposit ("Tim", v3)
			Result :=
				across
					1 |..| b.count as i
				all
					(NOT (b.customers[i.item].name ~ "Tim") IMPLIES
						b.customers[i.item] ~ old_customers[i.item])
				end
			check Result end
		end

feature -- Test for postconditions of withdraw.

	t_withdraw_total_balance_decreased : BOOLEAN
		local
			b : BANK
			old_total_balance : VALUE
			v0, v1, v2: VALUE
		do
			comment ("t_withdraw_total_balance_decreased: total balance decreased")
			create b.make
			b.new ("Steve")

			v0 := "200.0"

			v1 := "100.0"
			b.deposit ("Steve", v0)
			old_total_balance := b.sum_of_all_balances
			b.withdraw ("Steve", v1)
			Result := b.sum_of_all_balances = old_total_balance - v1
			check Result end

			old_total_balance := b.sum_of_all_balances
			v2 := "50.0"
			b.withdraw ("Steve", v2)
			Result := b.sum_of_all_balances = old_total_balance - v2
			check Result end
		end

	t_withdraw_num_customers_unchanged : BOOLEAN
		local
			b : BANK
			old_num_customers : INTEGER
			v0, v1, v2: VALUE
		do
			comment ("t_withdraw_num_customers_unchanged: number of customers unchanged")
			create b.make
			b.new ("Steve")

			v0 := "200"

			v1 := "100.0"
			b.deposit ("Steve", v0)
			old_num_customers := b.count
			b.withdraw ("Steve", v1)
			Result := b.count = old_num_customers
			check Result end

			old_num_customers := b.count
			v2 := "50.0"
			b.withdraw ("Steve", v2)
			Result := b.count = old_num_customers
			check Result end
		end

	t_withdraw_customer_balance_decreased : BOOLEAN
		local
			b : BANK
			old_customer_balance : VALUE
			v0, v1, v2: VALUE
		do
			comment ("t_withdraw_customer_balance_decreased: customer's balance decreased")

			create b.make
			b.new ("Steve")

			v0 := "200"
			b.deposit ("Steve", v0)
			v1 := "100.0"
			old_customer_balance := b.customer_with_name ("Steve").balance
			b.withdraw ("Steve", v1)
			Result := b.customer_with_name ("Steve").balance = old_customer_balance - v1
			check Result end

			old_customer_balance := b.customer_with_name ("Steve").balance
			v2 := "50.0"
			b.withdraw ("Steve", v2)
			Result := b.customer_with_name ("Steve").balance = old_customer_balance - v2
			check Result end
		end

	t_withdraw_other_customers_unchanged : BOOLEAN
		local
			b : BANK
			old_customers : LIST[CUSTOMER]
			v0, v1, v2, v3: VALUE
		do
			comment ("t_withdraw_other_customers_unchanged: other customers remain unchanged")

			create b.make
			b.new ("Steve")

			v0 := "200"

			b.deposit ("Steve", v0)
			v1 := "100.0"
			old_customers := b.customers.deep_twin
			b.withdraw ("Steve", v1)
			Result :=
				across
					1 |..| b.count as i
				all
					(NOT (b.customers[i.item].name ~ "Steve") IMPLIES
						b.customers[i.item] ~ old_customers[i.item])
				end
			check Result end

			old_customers := b.customers.deep_twin
			v2 := "50.0"
			b.withdraw ("Steve", v2)
			Result :=
				across
					1 |..| b.count as i
				all
					(NOT (b.customers[i.item].name ~ "Steve") IMPLIES
						b.customers[i.item] ~ old_customers[i.item])
				end
			check Result end

			v3 := "40.0"
			b.new ("Bill")
			b.deposit ("Bill", v0)
			old_customers := b.customers.deep_twin
			b.withdraw ("Bill", v3)
			Result :=
				across
					1 |..| b.count as i
				all
					(NOT (b.customers[i.item].name ~ "Bill") IMPLIES
						b.customers[i.item] ~ old_customers[i.item])
				end
			check Result end
		end

feature -- Test for postconditions of transfer.

	t_transfer_total_balance_unchanged : BOOLEAN
		local
			b : BANK
			v0, v1: VALUE
			old_total_balance: VALUE
		do
			comment ("t_transfer_total_balance_unchanged: total balance unchanged after transfer")

			create b.make
			b.new ("Tom")
			b.new ("Alan")
			b.new ("Mark")

			v0 := "200"
			b.deposit ("Tom", v0)
			b.deposit ("Alan", v0)
			b.deposit ("Mark", v0)

			v1 := "50"
			old_total_balance := b.sum_of_all_balances
			b.transfer ("Alan", "Mark", v1)
			Result := b.sum_of_all_balances = old_total_balance
			check Result end
		end

	transfer_customer_balance_decreased : BOOLEAN
		local
			b : BANK
			v0, v1: VALUE
			old_customer_balance: VALUE
		do
			comment ("transfer_customer_balance_decreased: source account balance decreased")

			create b.make
			b.new ("Tom")
			b.new ("Alan")
			b.new ("Mark")

			v0 := "200"
			b.deposit ("Tom", v0)
			b.deposit ("Alan", v0)
			b.deposit ("Mark", v0)

			v1 := "50"
			old_customer_balance := b.customer_with_name ("Alan").balance
			b.transfer ("Alan", "Mark", v1)
			Result := b.customer_with_name ("Alan").balance = old_customer_balance - v1
			check Result end
		end

	transfer_customer_balance_increased : BOOLEAN
		local
			b : BANK
			v0, v1: VALUE
			old_customer_balance: VALUE
		do
			comment ("transfer_customer_balance_increased: target account balance increased")

			create b.make
			b.new ("Tom")
			b.new ("Alan")
			b.new ("Mark")

			v0 := "200"
			b.deposit ("Tom", v0)
			b.deposit ("Alan", v0)
			b.deposit ("Mark", v0)

			v1 := "50"
			old_customer_balance := b.customer_with_name ("Mark").balance
			b.transfer ("Alan", "Mark", v1)
			Result := b.customer_with_name ("Mark").balance = old_customer_balance + v1
			check Result end
		end

	transfer_other_customers_unchanged : BOOLEAN
		local
			b : BANK
			v0, v1: VALUE
			old_customers : LIST[CUSTOMER]
		do
			comment ("transfer_other_customers_unchanged: other accounts unchanged")

			create b.make
			b.new ("Tom")
			b.new ("Alan")
			b.new ("Mark")

			v0 := "200"
			b.deposit ("Tom", v0)
			b.deposit ("Alan", v0)
			b.deposit ("Mark", v0)

			v1 := "50"
			old_customers := b.customers.deep_twin
			b.transfer ("Alan", "Mark", v1)
			Result :=
				across
					1 |..| b.count as i
				all
					NOT (b.customers[i.item].name ~ "Alan" OR b.customers[i.item].name ~ "Mark") IMPLIES
						b.customers[i.item] ~ old_customers [i.item]
				end
			check Result end
		end
end
