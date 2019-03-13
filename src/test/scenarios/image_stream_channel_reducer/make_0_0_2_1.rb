require_relative "./scenario_generator.rb"

gen = ScenarioGenerator.new(8, 0, 0, [2,0,3,3], [1,0,3,3], [1,1])

gen.test_1(1, 32,  1,  1,  1)
gen.test_1(2,  1,  1, 12, 12)
gen.test_1(3,  2,  1, 11, 11)
gen.test_1(4,  3,  1, 10, 10)
gen.test_1(5,  4,  1,  9,  9)
