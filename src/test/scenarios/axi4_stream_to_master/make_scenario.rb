#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
#---------------------------------------------------------------------------------
#
#       Version     :   2.0.0
#       Created     :   2023/12/28
#       File name   :   make_scneario_feature.rb
#       Author      :   Ichiro Kawazome <ichiro_k@ca2.so-net.ne.jp>
#       Description :   AXI4_STREAM_TO_MASTER 用シナリオ生成スクリプト
#
#---------------------------------------------------------------------------------
#
#       Copyright (C) 2012-2023 Ichiro Kawazome
#       All rights reserved.
# 
#       Redistribution and use in source and binary forms, with or without
#       modification, are permitted provided that the following conditions
#       are met:
# 
#         1. Redistributions of source code must retain the above copyright
#            notice, this list of conditions and the following disclaimer.
# 
#         2. Redistributions in binary form must reproduce the above copyright
#            notice, this list of conditions and the following disclaimer in
#            the documentation and/or other materials provided with the
#            distribution.
# 
#       THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
#       "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
#       LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
#       A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT
#       OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
#       SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
#       LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
#       DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
#       THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT 
#       (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
#       OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
# 
#---------------------------------------------------------------------------------
require 'optparse'
require 'pp'
require_relative "../../../../Dummy_Plug/tools/Dummy_Plug/ScenarioWriter/axi4"
require_relative "../../../../Dummy_Plug/tools/Dummy_Plug/ScenarioWriter/number-generater"
class ScenarioGenerater
  #-------------------------------------------------------------------------------
  # インスタンス変数
  #-------------------------------------------------------------------------------
  attr_reader   :program_name, :program_version
  attr_accessor :name   , :file_name, :test_items
  attr_accessor :c_model
  attr_accessor :i_model
  attr_accessor :o_model
  #-------------------------------------------------------------------------------
  # initialize
  #-------------------------------------------------------------------------------
  def initialize
    @program_name      = "make_scenario"
    @program_version   = "1.7.0"
    @c_axi4_addr_width = 32
    @o_axi4_addr_width = 32
    @c_axi4_data_width = 32
    @o_axi4_data_width = 32
    @i_axi4_data_width = 32
    @max_xfer_size     = 256
    @id_width          = 4
    @c_model           = nil
    @i_model           = nil
    @o_model           = nil
    @c_id              = 0
    @o_id              = 1
    @i_id              = 2
    @no                = 0
    @name              = "AXI4_S2M_TEST"
    @file_name         = nil
    @test_items        = []
    @timeout           = 10000
    @opt               = OptionParser.new do |opt|
      opt.program_name = @program_name
      opt.version      = @program_version
      opt.on("--verbose"              ){|val| @verbose           = true     }
      opt.on("--name       STRING"    ){|val| @name              = val      }
      opt.on("--output     FILE_NAME" ){|val| @file_name         = val      }
      opt.on("--c_width    INTEGER"   ){|val| @c_axi4_data_width = val.to_i }
      opt.on("--i_width    INTEGER"   ){|val| @i_axi4_data_width = val.to_i }
      opt.on("--o_width    INTEGER"   ){|val| @o_axi4_data_width = val.to_i }
      opt.on("--max_size   INTEGER"   ){|val| @max_xfer_size     = val.to_i }
      opt.on("--timeout    INTEGER"   ){|val| @timeout           = val.to_i }
      opt.on("--test_item  INTEGER"   ){|val| @test_items.push(val.to_i)    }
    end
  end
  #-------------------------------------------------------------------------------
  # parse_options
  #-------------------------------------------------------------------------------
  def parse_options(argv)
    @opt.parse(argv)
  end
  #-------------------------------------------------------------------------------
  # 
  #-------------------------------------------------------------------------------
  def  gen_simple_write(io, model, address, data, resp, cache=nil, auser=nil)
    pos = 0
    max_xfer_size = model.write_transaction.max_transaction_size
    while (pos < data.length)
      len = max_xfer_size - (address % max_xfer_size)
      if (pos + len > data.length)
          len = data.length - pos
      end
      io.print model.write( {
               :Address         => address, 
               :AddressUser     => auser,
               :Cache           => cache,
               :Data            => data[pos..pos+len-1], 
               :Response        => resp
      } )
      pos     += len
      address += len
    end
  end
  #-------------------------------------------------------------------------------
  # 
  #-------------------------------------------------------------------------------
  def  gen_stream_read(io, data, pad=nil)
    pos  = 0
    last = 0
    io.print "- I: \n"
    io.print "  - OUT   : {GPO(0) : 0}\n"
    while (pos < data.length)
      if pad.nil? then
        len = @i_axi4_data_width/8
        pad = 0
      else
        len = rand(0..(@i_axi4_data_width/8))
        pad = rand(0..(@i_axi4_data_width/8-len))
      end
      if (pos + len >= data.length)
          last = 1
          len  = data.length - pos
      end
      data_list = Array.new(@i_axi4_data_width/8, "PAD ")
      data_list[pad...pad+len] = data.slice(pos,len).map{|d| sprintf("0x%02X", d)}
      data_str = data_list.join(",")
      io.print "  - XFER: {DATA: [#{data_str}], LAST: #{last}}\n"
      pos     += len
    end
  end
  #-------------------------------------------------------------------------------
  # 
  #-------------------------------------------------------------------------------
  def  gen_pipeline_write(io, model, address, data, resp, cache=nil, auser=nil)
    pos           = 0
    max_xfer_size = model.read_transaction.max_transaction_size
    data_xfer_pattern = Dummy_Plug::ScenarioWriter::GenericNumberGenerater.new([3,0])
    while (pos < data.length)
      len = max_xfer_size - (address % max_xfer_size)
      if (pos + len > data.length)
          len = data.length - pos
      end
      io.print model.write( {
               :Address           => address, 
               :AddressUser       => auser,
               :Cache             => cache,
               :Data              => data[pos..pos+len-1], 
               :Response          => resp, 
               :DataStartEvent    => (pos == 0) ? :ADDR_VALID    : :NO_WAIT,
               :DataXferPattern   => data_xfer_pattern,
               :ResponseStartEvent=> (pos == 0) ? :LAST_DATA_XFER: :NO_WAIT,
               :ResponseDelayCycle=> (pos == 0) ? 40             : 20

      })
      pos     += len
      address += len
    end
  end
  #-------------------------------------------------------------------------------
  # 
  #-------------------------------------------------------------------------------
  def gen_ctrl_regs(arg,cache=nil,auser=nil)
    ctrl_regs  = 0
    ctrl_regs |= (0x80000000) if (arg.index(:Reset))
    ctrl_regs |= (0x40000000) if (arg.index(:Pause))
    ctrl_regs |= (0x20000000) if (arg.index(:Stop ))
    ctrl_regs |= (0x10000000) if (arg.index(:Start))
    ctrl_regs |= (0x04000000) if (arg.index(:Done_Enable))
    ctrl_regs |= (0x02000000) if (arg.index(:First))
    ctrl_regs |= (0x01000000) if (arg.index(:Last ))
    ctrl_regs |= (0x00040000) if (arg.index(:Close))
    ctrl_regs |= (0x00020000) if (arg.index(:Error))
    ctrl_regs |= (0x00010000) if (arg.index(:Done ))
    ctrl_regs |= (0x00008000) if (arg.index(:Safety))
    ctrl_regs |= (0x00004000) if (arg.index(:Speculative))
    ctrl_regs |= (0x00000004) if (arg.index(:Close_Irq_Enable))
    ctrl_regs |= (0x00000002) if (arg.index(:Error_Irq_Enable))
    ctrl_regs |= (0x00000001) if (arg.index(:Done_Irq_Enable))
    ctrl_regs |= ((cache << 4) & 0x000000F0) if (cache != nil)
    ctrl_regs |= ((auser << 8) & 0x00001F00) if (auser != nil)
    return ctrl_regs
  end
  #-------------------------------------------------------------------------------
  # 
  #-------------------------------------------------------------------------------
  def simple_test(title, io, o_address, o_size, o_cache, o_auser, open_info, close_info, pad=nil)
    size   = o_size
    data   = (1..size).collect{rand(256)}
    o_mode = gen_ctrl_regs([:Last,:First,:Done_Enable,:Close_Irq_Enable,:Error_Irq_Enable,:Safety], o_cache, o_auser)
    close  = gen_ctrl_regs([:Close])
    done   = gen_ctrl_regs([:Done ])
    start  = gen_ctrl_regs([:Start])
    io.print "---\n"
    io.print "- MARCHAL : \n"
    io.print "  - SAY : ", title, "\n"
    io.print "- #{@c_model.name} : \n"
    io.print "  - WAIT : 2\n"
    io.print @c_model.write({
               :Address => 0x00000010, 
               :Data    => [sprintf("0x%08X", open_info     ),
                            sprintf("0x%08X", close_info    )
                           ]
             })
    io.print @c_model.write({
               :Address => 0x00000000, 
               :Data    => [sprintf("0x%08X", o_address)     ,
                            "0x00000000"                     , 
                            sprintf("0x%08X", o_size        ),
                            sprintf("0x%08X", o_mode | start)
                           ]
             })
    io.print "  - WAIT  : {GPI(0) : 1, TIMEOUT: ", @timeout.to_s, "}\n"
    io.print @c_model.read({
               :Address => 0x00000000, 
               :Data    => [sprintf("0x%08X", o_address+size),
                            "0x00000000"                     , 
                            sprintf("0x%08X", o_size-size   ),
                            sprintf("0x%08X", o_mode | close | done),
                            sprintf("0x%08X", open_info     ),
                            sprintf("0x%08X", close_info    )
                           ]
             })
    io.print @c_model.write({
               :Address => 0x00000000, 
               :Data    => ["0x00000000"                     ,
                            "0x00000000"                     , 
                            "0x00000000"                     , 
                            "0x00000000"                     ,
                           ]
             })
    io.print "  - WAIT  : {GPI(0) : 0, TIMEOUT: ", @timeout.to_s, "}\n"
    gen_simple_write(io, @o_model, o_address, data, "OKAY", o_cache, o_auser)
    gen_stream_read( io, data, pad)
  end
  #-------------------------------------------------------------------------------
  # 
  #-------------------------------------------------------------------------------
  def pipeline_test(title, io, o_address, o_size, o_cache, o_auser, pad=nil)
    size   = o_size
    data   = (1..size).collect{rand(256)}
    o_mode = gen_ctrl_regs([:Last,:First,:Done_Enable,:Close_Irq_Enable,:Error_Irq_Enable,:Speculative], o_cache, o_auser)
    close  = gen_ctrl_regs([:Close])
    done   = gen_ctrl_regs([:Done ])
    start  = gen_ctrl_regs([:Start])
    io.print "---\n"
    io.print "- MARCHAL : \n"
    io.print "  - SAY : ", title, "\n"
    io.print "- #{@c_model.name} : \n"
    io.print "  - WAIT : 2\n"
    io.print @c_model.write({
               :Address => 0x00000000, 
               :Data    => [sprintf("0x%08X", o_address)     ,
                            "0x00000000"                     ,
                            sprintf("0x%08X", o_size)        ,
                            sprintf("0x%08X", o_mode | start),
                           ]
             })
    io.print "  - WAIT  : {GPI(0) : 1, TIMEOUT: ", @timeout.to_s, "}\n"
    io.print @c_model.read({
               :Address => 0x00000000, 
               :Data    => [sprintf("0x%08X", o_address+size),
                            "0x00000000"                     ,
                            sprintf("0x%08X", o_size-size   ),
                            sprintf("0x%08X", o_mode | close | done),
                           ]
             })
    io.print @c_model.write({
               :Address => 0x00000000, 
               :Data    => ["0x00000000"                     , 
                            "0x00000000"                     , 
                            "0x00000000"                     , 
                            "0x00000000"                     
                           ]
             })
    io.print "  - WAIT  : {GPI(0) : 0, TIMEOUT: ", @timeout.to_s, "}\n"
    gen_pipeline_write(io, @o_model, o_address, data, "OKAY", o_cache, o_auser)
    gen_stream_read(   io, data, pad)
  end
  #-------------------------------------------------------------------------------
  # 
  #-------------------------------------------------------------------------------
  def test_1(io)
    test_num   = 0
    open_info  = 0xdead0000;
    close_info = 0xfeed0000;
    [0,1,2,3,4,5,6,7,8,9,10,16,21,32,49,64,71,85,99,110,128,140,155,189,200,212,234,256].each{|size|
      (0xFC00..0xFC03).each {|o_address|
        title = @name.to_s + ".1." + test_num.to_s
        simple_test(title, io, o_address, size, 3, 1, open_info, close_info, nil)
        test_num   += 1
        open_info  += 1
        close_info += 1
      }
    }
  end
  #-------------------------------------------------------------------------------
  # 
  #-------------------------------------------------------------------------------
  def test_2(io)
    test_num = 0
    [32,51,64,69,81,97,110,128,140,155,189,200,212,234,256,1523].each{|size|
      (0x7030..0x7033).each {|o_address|
        title = @name.to_s + ".2." + test_num.to_s
        pipeline_test(title, io, o_address, size, nil, nil, nil)
        test_num += 1
      }
    }
  end
  #-------------------------------------------------------------------------------
  # 
  #-------------------------------------------------------------------------------
  def test_3(io)
    test_num   = 0
    [0,1,2,3,4,5,6,7,8,9,10,16,32,64,128].each{|size|
      (0xC100..0xC103).each {|o_address|
        title = @name.to_s + ".3." + test_num.to_s
        pipeline_test(title, io, o_address, size, nil, nil, true)
        test_num   += 1
      }
    }
  end
  #-------------------------------------------------------------------------------
  # 
  #-------------------------------------------------------------------------------
  def generate
    if @file_name == nil then
        @file_name = sprintf("axi4_stream_to_master_test_bench_%d_%d_%d.snr", @o_axi4_data_width, @i_axi4_data_width, @max_xfer_size)
    end
    if @test_items == []
      @test_items = [1,2,3]
    end
    puts "Scenario File: #{@file_name}"         if @verbose
    puts "O Data Width : #{@o_axi4_data_width}" if @verbose
    puts "I Data Width : #{@i_axi4_data_width}" if @verbose
    puts "Max Xfer Size: #{@max_xfer_size}"     if @verbose
    if @c_model == nil
      @c_model = Dummy_Plug::ScenarioWriter::AXI4::Master.new("CSR", {
        :ID            => @c_id,
        :ID_WIDTH      => 4,
        :ADDR_WIDTH    => @c_axi4_addr_width,
        :DATA_WIDTH    => @c_axi4_data_width,
        :MAX_TRAN_SIZE => @max_xfer_size  
      })
    end
    if @i_model == nil
      @i_model = Dummy_Plug::ScenarioWriter::AXI4::Slave.new("I", {
        :ID            => @i_id,
        :ID_WIDTH      => 4,
        :ADDR_WIDTH    => @i_axi4_addr_width,
        :DATA_WIDTH    => @i_axi4_data_width,
        :MAX_TRAN_SIZE => @max_xfer_size  
      })
    end
    if @o_model == nil
      @o_model = Dummy_Plug::ScenarioWriter::AXI4::Slave.new("O", {
        :ID            => @o_id,
        :ID_WIDTH      => 4,
        :ADDR_WIDTH    => @o_axi4_addr_width,
        :DATA_WIDTH    => @o_axi4_data_width,
        :MAX_TRAN_SIZE => @max_xfer_size  
      })
    end
    title = @name.to_s + 
            " O_DATA_WIDTH="    + @o_axi4_data_width.to_s +
            " I_DATA_WIDTH="    + @i_axi4_data_width.to_s + 
            " MAX_XFER_SIZE="   + @max_xfer_size.to_s   
    io = open(@file_name, "w")
    io.print "---\n"
    io.print "- MARCHAL : \n"
    io.print "  - SAY : ", title, "\n"
    @test_items.each {|item|
        test_1(io) if (item == 1)
        test_2(io) if (item == 2)
        test_3(io) if (item == 3)
    }
  end
end
gen = ScenarioGenerater.new
gen.parse_options(ARGV)
gen.generate
