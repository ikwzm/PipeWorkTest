require_relative "./image_stream_buffer.rb"

gen = ScenarioGenerater.new(2, 0, [32,0,1,1], [1,1], [32,4,3,3], [1,1])

gen.test_1(1, 32, 8, 1,  1)
gen.test_1(2, 64, 8, 1,  1)
gen.test_1(3, 64, 8, 2,  2)
gen.test_1(4, 64, 8, 3,  3)
gen.test_1(5, 64, 8, 4,  4)
gen.test_1(6, 64, 8, 5,  5)
gen.test_1(7, 64, 8, 10, 7)
gen.test_1(8,128, 8, 15,11)

gen.test_2(1, 32, 8, 4,  8)
gen.test_2(2, 64, 8, 4,  8)
gen.test_2(3,128, 8, 15,11)

