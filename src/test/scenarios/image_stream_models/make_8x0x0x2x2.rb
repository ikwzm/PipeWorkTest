require_relative "./scenario_generator.rb"

gen = ScenarioGenerator.new(8, [0,0,2,2], [2,2])
gen.test_1(1,  1,  1,  1,  1)
gen.test_1(2,  1,  1,  2,  2)
gen.test_1(3,  1,  1,  3,  3)
gen.test_1(4,  1,  1,  4,  4)
gen.test_1(5,  1,  1, 15, 15)
gen.test_1(6,  1,  1, 24, 24)
