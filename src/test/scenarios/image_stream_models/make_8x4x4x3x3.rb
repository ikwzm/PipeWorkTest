require_relative "./scenario_generator.rb"

gen = ScenarioGenerator.new(8, [4,4,3,3], [1,1])
gen.test_1(1, 32,  1,  1,  1)
gen.test_1(2,  1,  4,  3,  3)
gen.test_1(3,  3,  1, 20, 20)
gen.test_1(4,  4,  4, 20, 20)
gen.test_1(5,  8,  8, 32, 32)
