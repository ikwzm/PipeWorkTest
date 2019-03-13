require_relative "./image_stream.rb"

class ScenarioGenerator

  def initialize(elem_bits, win_size, win_stride)
    @name           = "IMAGE_STREAM_PLAYER_TEST"
    @elem_bits      = elem_bits
    @win_size       = win_size
    @win_stride     = win_stride
    @title          = @name +
                      sprintf(" ELEM_BITS=%-2d", @elem_bits  ) +
                      sprintf(" C=%-3d"        , @win_size[0]) +
                      sprintf(" D=%-3d"        , @win_size[1]) +
                      sprintf(" X=%-3d"        , @win_size[2]) +
                      sprintf(" Y=%-3d"        , @win_size[3])
    @m_model = Dummy_Plug::ScenarioWriter::ImageStream::Master.new("M", @elem_bits, 0, @win_size, @win_stride)
    @s_model = Dummy_Plug::ScenarioWriter::ImageStream::Slave .new("S", @elem_bits, 0, @win_size, @win_stride)
    @file_name = "test_#{@elem_bits}x#{@win_size[0]}x#{@win_size[1]}x#{@win_size[2]}x#{@win_size[3]}.snr"
    @io = open(@file_name, "w")
    @io.print "---\n"
    @io.print "- MARCHAL : \n"
    @io.print "  - SAY : ", @title, "\n"
    @io.print "---\n"
  end
  
  def test_1(num, c_size, d_size, x_size, y_size)
    data  = Array.new(y_size){Array.new(x_size){Array.new(c_size){rand(2**@elem_bits)}}}
    # p data
    title = sprintf("%s.1.%-3d"    , @name, num) +
            sprintf(" C_SIZE=%-3d" , c_size    ) + 
            sprintf(" D_SIZE=%-3d" , d_size    ) +
            sprintf(" X_SIZE=%-3d" , x_size    ) +
            sprintf(" Y_SIZE=%-3d" , y_size    )
    @io.print "- MARCHAL : \n"
    @io.print "  - SAY : ", title , "\n"
    @io.print "---\n"
    @io.print @m_model.output_name("- ")
    @m_model.output_data(@io, "  ", data, d_size)
    @io.print @s_model.output_name("- ")
    @s_model.check_data( @io, "  ", data, d_size)
    @io.print "---\n"
  end
end

