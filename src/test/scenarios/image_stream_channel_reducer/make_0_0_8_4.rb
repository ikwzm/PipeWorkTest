require_relative "./scenario_generator.rb"

gen = ScenarioGenerator.new(8, 0, 0, [8,4,3,3], [4,4,3,3], [1,1])

gen.test_1( 1, 32,  1,  1,  1)
gen.test_1( 2,  1,  1, 20, 10)
gen.test_1( 3,  2,  1, 19,  9)
gen.test_1( 4,  3,  1, 18,  8)
gen.test_1( 5,  4,  1, 17,  7)
gen.test_1( 6,  5,  1, 16,  6)
gen.test_1( 7,  6,  1, 15,  5)
gen.test_1( 8,  7,  1, 14,  4)
gen.test_1( 9,  8,  1, 13,  3)
gen.test_1(10,  9,  1, 12,  2)
gen.test_1(11, 10,  1, 11,  1)
