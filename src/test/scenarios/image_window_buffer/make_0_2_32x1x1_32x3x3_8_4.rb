require_relative "./image_window_buffer.rb"

gen = ScenarioGenerater.new(2, 0, [32,1,1], [1,1], [32,3,3], [1,1], 8, 4)

gen.test_1(1, 32, 1,  1)
gen.test_1(2, 64, 1,  1)
gen.test_1(3, 64, 2,  2)
gen.test_1(4, 64, 3,  3)
gen.test_1(5, 64, 4,  4)
gen.test_1(6, 64, 5,  5)
gen.test_1(7, 64, 10, 7)
gen.test_1(8,128, 15,11)

gen.test_2(1, 32, 4,  8)
gen.test_2(2, 64, 4,  8)
gen.test_2(3,128, 15,11)

