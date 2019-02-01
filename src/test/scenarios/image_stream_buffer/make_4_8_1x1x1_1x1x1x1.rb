require_relative "./image_stream_buffer.rb"

gen = ScenarioGenerater.new(8, 4, [1,0,1,1], [1,1], [1,1,1,1], [1,1])

gen.test_1(1, 4, 1, 1, 1)
gen.test_1(2, 4, 1, 2, 2)
gen.test_1(3, 4, 1, 3, 3)
gen.test_1(4, 4, 1, 4, 4)
gen.test_1(5, 4, 1, 5, 5)
gen.test_1(6, 4, 1, 6, 6)
gen.test_1(7, 4, 1, 7, 7)
gen.test_1(8, 4, 1, 8, 8)
gen.test_1(9, 4, 1, 9, 9)

