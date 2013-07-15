#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
#---------------------------------------------------------------------------------
require 'optparse'
require 'pp'
require_relative "../../../../Dummy_Plug/tools/Dummy_Plug/ScenarioWriter/axi4"
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

  def test_1(io)
    test_num = 0
    (1..200).each {|num|  
      title   = @name.to_s + ".1." + num.to_s
      address = rand(@t_max_xfer_size)
      size    = rand(@t_max_xfer_size) % 256
      if ((address % @t_max_xfer_size) + size) > @t_max_xfer_size then
        size = @t_max_xfer_size - (address % @t_max_xfer_size)
      end
      data    = (1..size).collect{rand(256)}
      t_tran  = @t_model.read_transaction.clone({:Address => address, :Data => data})
      m_tran  = @m_model.read_transaction.clone({:Address => address, :Data => data})
      io.print "---\n"
      io.print "- MARCHAL : \n"
      io.print "  - SAY : ", title, "\n"
      io.print @t_model.execute(t_tran)
      io.print @m_model.execute(m_tran)
    }
    io.print "---\n"
  end

  def test_2(io)
    test_num = 0
    (1..200).each {|num|  
      title   = @name.to_s + ".1." + num.to_s
      address = rand(@t_max_xfer_size)
      size    = rand(@t_max_xfer_size) % 256
      if ((address % @t_max_xfer_size) + size) > @t_max_xfer_size then
        size = @t_max_xfer_size - (address % @t_max_xfer_size)
      end
      data    = (1..size).collect{rand(256)}
      t_tran  = @t_model.write_transaction.clone({:Address => address, :Data => data})
      m_tran  = @m_model.write_transaction.clone({:Address => address, :Data => data})
      io.print "---\n"
      io.print "- MARCHAL : \n"
      io.print "  - SAY : ", title, "\n"
      io.print @t_model.execute(t_tran)
      io.print @m_model.execute(m_tran)
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
    io.print "- MARCHAL : \n"
    io.print "  - SAY : ", title, "\n"
    @test_items.each {|item|
        test_1(io) if (item == 1)
        test_2(io) if (item == 2)
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
