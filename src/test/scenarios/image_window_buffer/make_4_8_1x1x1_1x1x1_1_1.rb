require_relative "./image_window_buffer.rb"

gen = ScenarioGenerater.new(8, 4, [1,1,1], [1,1], [1,1,1], [1,1], 1, 1)

gen.test_1(1, 4, 1, 1)
gen.test_1(2, 4, 2, 2)
gen.test_1(3, 4, 3, 3)
gen.test_1(4, 4, 4, 4)
gen.test_1(5, 4, 5, 5)
gen.test_1(6, 4, 6, 6)
gen.test_1(7, 4, 7, 7)
gen.test_1(8, 4, 8, 8)
gen.test_1(9, 4, 9, 9)

