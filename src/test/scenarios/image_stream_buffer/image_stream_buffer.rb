require_relative "../image_stream_models/image_stream.rb"

class ScenarioGenerater

  def initialize(elem_bits, channel_size, i_win_size, i_win_stride, o_win_size, o_win_stride)
    @name           = "IMAGE_STREAM_BUFFER_TEST"
    @elem_bits      = elem_bits
    @channel_size   = channel_size
    @i_win_size     = i_win_size
    @i_win_stride   = i_win_stride
    @o_win_size     = o_win_size
    @o_win_stride   = o_win_stride
    @title          = @name + 
                      " ELEM_BITS="     + @elem_bits    .to_s +
                      " CHANNEL_SIZE="  + @channel_size .to_s +
                      " I.C="           + @i_win_size[0].to_s +
                      " I.X="           + @i_win_size[2].to_s +
                      " I.Y="           + @i_win_size[3].to_s +
                      " O.C="           + @o_win_size[0].to_s +
                      " O.D="           + @o_win_size[1].to_s +
                      " O.X="           + @o_win_size[2].to_s +
                      " O.Y="           + @o_win_size[3].to_s
    @i_model = Dummy_Plug::ScenarioWriter::ImageStream::Master.new("I", @elem_bits, 0, @i_win_size, @i_win_stride)
    @o_model = Dummy_Plug::ScenarioWriter::ImageStream::Slave .new("O", @elem_bits, 0, @o_win_size, @o_win_stride)
    @file_name      = "test_#{@channel_size}_#{@elem_bits}_#{@i_win_size[0]}x#{@i_win_size[2]}x#{@i_win_size[3]}_#{@o_win_size[0]}x#{@o_win_size[1]}x#{@o_win_size[2]}x#{@o_win_size[3]}.snr"
    @io = open(@file_name, "w")
    @io.print "---\n"
    @io.print "- MARCHAL : \n"
    @io.print "  - SAY : ", @title, "\n"
    @io.print "---\n"
  end

  def test_1(num, c_size, d_size, x_size, y_size)
    data = Array.new(y_size){Array.new(x_size){Array.new(c_size){rand(2**@elem_bits)}}}
    @io.print "- MARCHAL : \n"
    @io.print "  - SAY : ", @name.to_s, ".1.", num.to_s, " C.SIZE=#{c_size} X.SIZE=#{x_size} Y.SIZE=#{y_size} \n"
    @io.print "---\n"
    @io.print @i_model.output_name("- ")
    @io.print "  - OUT  : {GPO(0): 1}\n"
    @io.print "  - WAIT : 1\n"
    @io.print "  - OUT  : {GPO(0): 0}\n"
    @i_model.output_data(@io, "  ", data)
    @io.print "  - OUT  : {GPO(0): 0}\n"
    @io.print @o_model.output_name("- ")
    @io.print "  - OUT  : {GPO(0): 0}\n"
    @o_model.check_data(@io, "  ", data, d_size)
    @io.print "---\n"
  end

  def test_2(num, c_size, d_size, x_size, y_size)
    data = Array.new(y_size){Array.new(x_size){Array.new(c_size){rand(2**@elem_bits)}}}
    @io.print "- MARCHAL : \n"
    @io.print "  - SAY : ", @name.to_s, ".2.", num.to_s, " C.SIZE=#{c_size} X.SIZE=#{x_size} Y.SIZE=#{y_size} \n"
    @io.print "---\n"
    @io.print @i_model.output_name("- ")
    @io.print "  - OUT  : {GPO(0): 1}\n"
    @io.print "  - WAIT : 1\n"
    @io.print "  - OUT  : {GPO(0): 0}\n"
    @i_model.output_data(@io, "  ", data)
    @io.print "  - OUT  : {GPO(0): 0}\n"
    @io.print @o_model.output_name("- ")
    @io.print "  - OUT  : {GPO(0): 0}\n"
    @o_model.check_data(@io, "  ", data, d_size){rand(5)}
    @io.print "---\n"
  end
end

