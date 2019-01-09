require_relative "./image_window_buffer.rb"

gen = ScenarioGenerater.new(2, 0, [32,1,1], [1,1], [32,3,3], [1,1], 8, 4)
gen.test_1(64, 10, 7)

