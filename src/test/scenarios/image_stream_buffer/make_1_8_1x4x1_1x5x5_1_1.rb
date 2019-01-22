require_relative "./image_stream_buffer.rb"

gen = ScenarioGenerater.new(8, 1, [1,4,1], [4,1], [1,5,5], [1,1], 1, 1)

gen.test_1( 1, 1, 1, 1)
gen.test_1( 2, 1, 2, 2)
gen.test_1( 3, 1, 3, 3)
gen.test_1( 4, 1, 4, 4)
gen.test_1( 5, 1, 5, 5)
gen.test_1( 6, 1, 6, 6)
gen.test_1( 7, 1, 7, 7)
gen.test_1( 8, 1, 8, 8)
gen.test_1( 9, 1, 9, 9)
gen.test_1(10, 1,10,10)
gen.test_1(11, 1,32,32)
gen.test_1(12, 1,58,41)

gen.test_2( 1, 1,50,39)




