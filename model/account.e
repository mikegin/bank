note
	description: "[
		A bank account with deposit and withdraw 
		operations. A bank account may not have a negative balance.
		]"
	author: "JSO"
	date: "$Date$"
	revision: "$Revision$"

class
	ACCOUNT
inherit
	ANY
		redefine is_equal end
create
	make_with_name

feature {NONE} -- Initialization

	make_with_name (a_name: STRING)
			-- create an account for `a_name' with zero balance
		do
			create name.make_from_string (a_name)
		ensure
			created: name ~ a_name
			balance_zero: balance = balance.zero
		end

feature -- Account Attributes
	name : STRING

	balance : VALUE

feature -- Commands

	deposit(v: VALUE)
		require
		  positive: v > v.zero
		do
			balance := balance + v
		ensure
			correct_balance: balance = old balance + v
		end

	withdraw(v: VALUE)
		require
		  positive: v > v.zero
		  balance - v >= v.zero
		do
			balance := balance - v
		ensure
			correct_balance: balance = old balance - v
		end

feature -- Queries of Comparison

	is_equal (other: like Current): BOOLEAN
			-- Is `other' value equal to current
		do
			Result := name ~ other.name and balance = other.balance
		ensure then
			Result = (name ~ other.name and balance = other.balance)
		end

	is_less alias "<" (other: like Current): BOOLEAN
			-- Is current object less than `other'?
		do
			if  name < other.name then
				Result := true
			elseif name ~ other.name and balance < other.balance then
				Result := true
			else
				Result := false
			end
		ensure then
			Result =  (name < other.name)
				or else (name ~ other.name and balance < other.balance )
		end

invariant
	balance_non_negative: balance >= balance.zero
end
