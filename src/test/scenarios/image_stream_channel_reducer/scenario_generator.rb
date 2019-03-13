require_relative "../image_stream_models/image_stream.rb"

class ScenarioGenerator

  def initialize(elem_bits, c_size, c_done, m_shape, s_shape, stride)
    @name           = "IMAGE_STREAM_CHANNEL_REDUCER_TEST"
    @elem_bits      = elem_bits
    @c_size         = c_size
    @c_done         = c_done
    @m_shape        = m_shape
    @s_shape        = s_shape
    @m_stride       = stride
    @s_stride       = stride
    @title          = @name +
                      sprintf(" ELEM_BITS=%-2d", @elem_bits ) +
                      sprintf(" C_SIZE=%-1d"   , @c_size    ) +
                      sprintf(" C_DONE=%-1d"   , @c_done    ) +
                      sprintf(" D=%-3d"        , @m_shape[1]) +
                      sprintf(" X=%-3d"        , @m_shape[2]) +
                      sprintf(" Y=%-3d"        , @m_shape[3]) +
                      sprintf(" I.C=%-3d"      , @m_shape[0]) +
                      sprintf(" O.C=%-3d"      , @s_shape[0])
    @m_model = Dummy_Plug::ScenarioWriter::ImageStream::Master.new("I", @elem_bits, 0, @m_shape, @m_stride)
    @s_model = Dummy_Plug::ScenarioWriter::ImageStream::Slave .new("O", @elem_bits, 0, @s_shape, @s_stride)
    @file_name = "test_#{@c_size}_#{@c_done}_#{@m_shape[0]}_#{@s_shape[0]}.snr"
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
    @io.print "  - OUT : {GPO(0): 1}\n"
    @io.print "  - OUT : {GPO(1): 0}\n"
    @io.print "  - OUT : {GPO(2): 0}\n"
    @io.print "  - OUT : {GPO(3): 0}\n"
    @m_model.output_data(@io, "  ", data, d_size)
    @io.print "  - OUT : {GPO(0): 0}\n"
    @io.print @s_model.output_name("- ")
    @io.print "  - OUT : {GPO(0): 1}\n"
    @io.print "  - WAIT: {GPI(2): 1}\n"
    @s_model.check_data( @io, "  ", data, d_size)
    @io.print "  - WAIT: {GPI(2): 0}\n"
    @io.print "  - OUT : {GPO(0): 0}\n"
    @io.print "---\n"
  end
end

