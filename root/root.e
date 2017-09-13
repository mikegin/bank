note
	description: "Summary description for {ROOT}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	ROOT
inherit
	ES_SUITE
create
	make
feature {NONE}

	 make
	 	do
				add_test(create {BANK_TEST_INSTRUCTOR1}.make)
				add_test(create {BANK_TEST_INSTRUCTOR2}.make)
				add_test (create {STUDENT_TESTS}.make)
				add_test (create {BANK_TEST_CONTRACTS1}.make)
				show_browser
--				show_errors
	 			run_espec
	 	end
end
