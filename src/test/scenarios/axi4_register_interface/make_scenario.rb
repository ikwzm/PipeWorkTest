#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
#---------------------------------------------------------------------------------
require 'pp'

class ScenarioGenerater
  def initialize(name, axi4_data_width, regs_data_width)
    @name            = name
    @axi4_data_width = axi4_data_width
    @axi4_data_size  = (Math.log2(@axi4_data_width)).to_i
    @regs_data_width = regs_data_width
    @no              = 0
    @id              = 10
    @data            = (1..4096).collect{rand(256)}
  end

  def  gen_write(io, address, data, data_size, resp)
    io.print "  - WRITE : \n"
    io.print "      ADDR : ", sprintf("0x%08X", address), "\n"
    io.print "      SIZE : ", data_size, "\n"
    io.print "      BURST: INCR\n"
    io.print "      ID   : ", @id, "\n"
    io.print "      DATA : [", (data.collect{ |d| sprintf("0x%02X",d)}).join(',') ,"]\n" if (data.length > 0)
    io.print "      RESP : ", resp, "\n"
  end
  def  gen_read(io, address, data, data_size, resp)
    io.print "  - READ : \n"
    io.print "      ADDR : ", sprintf("0x%08X", address), "\n"
    io.print "      SIZE : ", data_size, "\n"
    io.print "      BURST: INCR\n"
    io.print "      ID   : ", @id, "\n"
    io.print "      DATA : [", (data.collect{ |d| sprintf("0x%02X",d)}).join(',') ,"]\n"
    io.print "      RESP : ", resp, "\n"
  end

  def gen_strb_null_test(io)
    address=0x00000010
    data_len=(@axi4_data_width > 32)? 8 : 4;
    data_size=@axi4_data_width/8
    data=@data.slice(address, data_len)
    resp="OKAY"
    @no += 1
    io.print "---\n"
    io.print "- - [MARCHAL]\n"
    io.print "  - SAY : \"", @name, " " , @no, "\"\n"
    io.print "- - [MASTER] \n"
    gen_write(io, address, data, data_size, resp)
    gen_read( io, address, data, data_size, resp)
    gen_write(io, address, []  , data_size, resp)
    gen_read( io, address, data, data_size, resp)
  end

  def generate(file_name)
    io = open(file_name, "w")
    address = @data.length
    @no += 1
    io.print "---\n"
    io.print "- - [MARCHAL]\n"
    io.print "  - SAY : \"", @name, " " , @no, "\"\n"
    io.print "- - [MASTER] \n"
    while address > 0 
        data_len  = rand(32)+1
        data_size = 2**rand(@axi4_data_size-3+1)
        if (address - data_len >= 0)
            address  = address - data_len
        else
            data_len = address
            address  = 0
        end
        gen_write(io, address, @data[address..address+data_len-1], data_size, "OKAY")
    end
    io.print "---\n"
    io.print "- - [MASTER] \n"
    address = @data.length
    while address > 0 
        data_len  = rand(32)+1
        data_size = 2**rand(@axi4_data_size-3+1)
        if (address - data_len >= 0)
            address  = address - data_len
        else
            data_len = address
            address  = 0
        end
        gen_read( io, address, @data[address..address+data_len-1], data_size, "OKAY")
    end
    gen_strb_null_test(io)
    io.print "---\n"
    io.close
  end
end

gen = ScenarioGenerater.new("AXI4 REGSITER INTERFACE TEST", 32,32)
gen.generate("axi4_register_interface_test_bench_32_32.snr")

gen = ScenarioGenerater.new("AXI4 REGSITER INTERFACE TEST", 32,64)
gen.generate("axi4_register_interface_test_bench_32_64.snr")

gen = ScenarioGenerater.new("AXI4 REGSITER INTERFACE TEST", 64,32)
gen.generate("axi4_register_interface_test_bench_64_32.snr")
