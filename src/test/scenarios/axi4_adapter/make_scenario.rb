#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
#---------------------------------------------------------------------------------
require 'optparse'
require 'pp'
require_relative "../../../../Dummy_Plug/tools/Dummy_Plug/ScenarioWriter/axi4"
require_relative "../../../../Dummy_Plug/tools/Dummy_Plug/ScenarioWriter/number-generater"
class ScenarioGenerater

  def initialize
    @program_name      = "make_scenario"
    @program_version   = "0.0.3"
    @t_axi4_data_width = 32
    @m_axi4_data_width = 32
    @t_max_xfer_size   = 4096
    @m_max_xfer_size   = 4096
    @t_model           = nil
    @m_model           = nil
    @no                = 0
    @name              = "AXI4_ADAPTER_TEST"
    @file_name         = "axi4_adapter_test_bench_4096_32_32.snr"
    @test_items        = []
    @opt               = OptionParser.new do |opt|
      opt.program_name = @program_name
      opt.version      = @program_version
      opt.on("--verbose"              ){|val| @verbose           = true     }
      opt.on("--name       STRING"    ){|val| @name              = val      }
      opt.on("--output     FILE_NAME" ){|val| @file_name         = val      }
      opt.on("--t_width    INTEGER"   ){|val| @t_axi4_data_width = val.to_i }
      opt.on("--m_width    INTEGER"   ){|val| @m_axi4_data_width = val.to_i }
      opt.on("--t_max_size INTEGER"   ){|val| @t_max_xfer_size   = val.to_i }
      opt.on("--m_max_size INTEGER"   ){|val| @m_max_xfer_size   = val.to_i }
      opt.on("--test_item  INTEGER"   ){|val| @test_items.push(val.to_i)    }
    end
  end

  def parse_options(argv)
    @opt.parse(argv)
  end

  def data_size_array(width)
    return (0..12).to_a.select{|i| 8*(2**i) <= width}
  end

  def gen_write(io, address, data, t_size, t_seq, m_seq)
    t_tran  = @t_model.write_transaction.clone({:Address => address, :Data => data, :DataSize => t_size})
    m_tran  = @m_model.write_transaction.clone({:Address => address, :Data => data})
    io.print @t_model.execute(t_tran, t_seq)
    io.print @m_model.execute(m_tran, m_seq)
  end

  def gen_read(io, address, data, t_size, t_seq, m_seq)
    t_tran  = @t_model.read_transaction.clone({:Address => address, :Data => data, :DataSize => t_size})
    if (@t_axi4_data_width > @m_axi4_data_width) then
      t_req_size = t_tran.estimate_request_size
      m_dmy_size = t_req_size - data.size
      m_data = data + Array.new(m_dmy_size, 0xFF)
    else
      m_data = data
    end
    m_tran  = @m_model.read_transaction.clone({:Address => address, :Data => m_data})
    io.print @t_model.execute(t_tran, t_seq)
    io.print @m_model.execute(m_tran, m_seq)
  end

  def test_1(io)
    read_write_select  = Dummy_Plug::ScenarioWriter::RandomNumberGenerater.new([0,1])
    t_data_size_select = Dummy_Plug::ScenarioWriter::RandomNumberGenerater.new(data_size_array(@t_axi4_data_width))
    (1..1000).each {|num|  
      title   = sprintf("%s.1.%-5d", @name.to_s, num)
      address = rand(@t_max_xfer_size)
      size    = rand(255)+1
      if ((address % @t_max_xfer_size) + size) > @t_max_xfer_size then
        size = @t_max_xfer_size - (address % @t_max_xfer_size)
      end
      data    = (1..size).collect{rand(256)}
      t_size  = t_data_size_select.next
      t_seq   = @t_model.default_sequence.clone({})
      m_seq   = @m_model.default_sequence.clone({})
      if read_write_select.next == 1 then
        io.print "---\n"
        io.print "- N : \n"
        io.print "  - SAY : ", title, sprintf(" WRITE ADDR=0x%08X, SIZE=%-3d, DATA_SIZE=%d\n", address, size, 2**t_size)
        gen_write(io, address, data, t_size, t_seq, m_seq)
      else
        io.print "---\n"
        io.print "- N : \n"
        io.print "  - SAY : ", title, sprintf(" READ  ADDR=0x%08X, SIZE=%-3d, DATA_SIZE=%d\n", address, size, 2**t_size)
        gen_read(io, address, data, t_size, t_seq, m_seq)
      end
    }
    io.print "---\n"
  end

  def test_2(io)
    (1..500).each {|num|  
      title   = @name.to_s + ".2." + num.to_s
      address = rand(@t_max_xfer_size)
      size    = rand(255)+1
      if ((address % @t_max_xfer_size) + size) > @t_max_xfer_size then
        size = @t_max_xfer_size - (address % @t_max_xfer_size)
      end
      data    = (1..size).collect{rand(256)}
      t_seq   = @t_model.default_sequence.clone({})
      t_tran  = @t_model.write_transaction.clone({:Address => address, :Data => data})
      m_seq   = @m_model.default_sequence.clone({})
      m_tran  = @m_model.write_transaction.clone({:Address => address, :Data => data})
      io.print "---\n"
      io.print "- N : \n"
      io.print "  - SAY : ", title, sprintf(" WRITE ADDR=0x%08X, SIZE=%d\n", address, size)
      io.print @t_model.execute(t_tran, t_seq)
      io.print @m_model.execute(m_tran, m_seq)
    }
    io.print "---\n"
  end

  def generate
    io = open(@file_name, "w")
    if @test_items == []
      @test_items = [1,2,3,4,5,6]
    end
    if @t_model == nil
      @t_model = Dummy_Plug::ScenarioWriter::AXI4::Master.new("T", {
        :ID_WIDTH      =>  4,
        :ADDR_WIDTH    => 32,
        :DATA_WIDTH    => @t_axi4_data_width,
        :MAX_TRAN_SIZE => @t_max_xfer_size  
      })
    end
    if @m_model == nil
      @m_model = Dummy_Plug::ScenarioWriter::AXI4::Slave.new("M", {
        :ID_WIDTH      =>  4,
        :ADDR_WIDTH    => 32,
        :DATA_WIDTH    => @m_axi4_data_width,
        :MAX_TRAN_SIZE => @m_max_xfer_size  
      })
    end
    title     = @name.to_s + 
                " T_DATA_WIDTH="    + @t_axi4_data_width.to_s + 
                " M_DATA_WIDTH="    + @m_axi4_data_width.to_s +
                " T_MAX_XFER_SIZE=" + @t_max_xfer_size.to_s   +
                " M_MAX_XFER_SIZE=" + @m_max_xfer_size.to_s
    io.print "---\n"
    io.print "- N : \n"
    io.print "  - SAY : ", title, "\n"
    @test_items.each {|item|
        test_1(io) if (item == 1)
     #  test_2(io) if (item == 2)
     #  test_3(io) if (item == 3)
     #  test_4(io) if (item == 4)
     #  test_5(io) if (item == 5)
     #  test_6(io) if (item == 6)
    }
  end
end


gen = ScenarioGenerater.new
gen.parse_options(ARGV)
gen.generate
