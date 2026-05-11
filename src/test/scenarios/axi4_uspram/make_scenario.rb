#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
#---------------------------------------------------------------------------------
require 'pp'

class ScenarioGenerater
  def initialize(name, ram_words, ram_word_bits, r_num, w_num, write_mode)
    @name            = name
    @axi4_data_width = 32
    @axi4_data_bytes = @axi4_data_width/8
    @axi4_data_size  = (Math.log2(@axi4_data_bytes)).to_i
    @ram_word_bits   = ram_word_bits
    @ram_word_bytes  = @ram_word_bits/8
    @ram_words       = ram_words
    @no              = 0
    @id              = 10
    @r_wait          = 10
    @w_wait          = 10
    @r_num           = r_num
    @w_num           = w_num
    @ram_num         = (@r_num > @w_num) ? @r_num : @w_num
    @write_mode      = write_mode
    @data            = (1..@ram_words*@ram_word_bytes).collect{rand(256)}
  end

  def gen_write(io, address, data, resp)
    io.print "  - WRITE : \n"
    io.print "      ADDR : ", sprintf("0x%08X", address), "\n"
    io.print "      ID   : ", @id, "\n"
    io.print "      DATA : [", (data.collect{ |d| sprintf("0x%02X",d)}).join(',') ,"]\n" if (data.length > 0)
    io.print "      RESP : ", resp, "\n"
  end

  def gen_read(io, address, data, resp)
    io.print "  - READ : \n"
    io.print "      ADDR : ", sprintf("0x%08X", address), "\n"
    io.print "      ID   : ", @id, "\n"
    io.print "      DATA : [", (data.collect{ |d| sprintf("0x%02X",d)}).join(',') ,"]\n"
    io.print "      RESP : ", resp, "\n"
  end

  def gen_write_read_test(io)
    address = @data.length
    @no += 1
    io.print "---\n"
    io.print "- - [MARCHAL]\n"
    io.print "  - SAY : \"", @name, " " , @no, "\"\n"
    io.print "- - [MASTER] \n"
    while address > 0
        if (address % @axi4_data_bytes > 0)
            data_len = rand(1..(address % @axi4_data_bytes))
        else
            data_len = rand(1..@axi4_data_bytes)
        end
        address  = address - data_len
        gen_write(io, address, @data[address..address+data_len-1], "OKAY")
    end
    io.print "---\n"
    io.print "- - [MASTER] \n"
    address = @data.length
    while address > 0 
        if (address % @axi4_data_bytes > 0)
            data_len = rand(1..(address % @axi4_data_bytes))
        else
            data_len = rand(1..@axi4_data_bytes)
        end
        address  = address - data_len
        gen_read( io, address, @data[address..address+data_len-1], "OKAY")
    end
  end

  def gen_strb_null_test(io)
    address=0x00000010
    data_size= (@axi4_data_width > 32)? 8 : 4;
    data=@data.slice(address, data_size)
    resp="OKAY"
    @no += 1
    io.print "---\n"
    io.print "- - [MARCHAL]\n"
    io.print "  - SAY : \"", @name, " " , @no, "\"\n"
    io.print "- - [MASTER] \n"
    gen_write(io, address, data, resp)
    gen_read( io, address, data, resp)
    gen_write(io, address, []  , resp)
    gen_read( io, address, data, resp)
  end

  def gen_async_write(io, address, data, resp, wait)
    addr_lo  =  address % 4
    data_vec = Array.new(@axi4_data_bytes, "00")
    strb_vec = Array.new(@axi4_data_bytes,  "0")
    data.each_with_index do |value, i|
      index = addr_lo + i
      break if index >= data_vec.length
      data_vec[index] = sprintf("%02X",value)
      strb_vec[index] = "1"
    end
    addr_str = sprintf("0x%08X", address)
    size_str = @axi4_data_size.to_s
    wait_str = wait.to_s
    data_str = "\"32'h"+ data_vec.reverse.join + "\""
    strb_str = "\"4'b" + strb_vec.reverse.join + "\""
    io.print "  - AW:                                   # Write Address Channel Action.\n"
    io.print "    - VALID  : 0                          # AWVALID <= 0\n"
    io.print "    - WAIT   : ", wait_str.ljust(26),   " # wait #{wait} clock\n"
    io.print "      ADDR   : ", addr_str.ljust(26),   " # AWADDR  <= #{addr_str}\n"
    io.print "      SIZE   : ", size_str.ljust(26),   " # AWSIZE  <= #{size_str}\n"
    io.print "      LEN    : 1                          # AWLEN   <= 8'h00\n"
    io.print "      VALID  : 1                          # AWVALID <= 1\n"
    io.print "    - WAIT   : {VALID : 1, READY : 1}     # wait until AWVALID = 1 and AWREADY = 1\n"
    io.print "    - VALID  : 0                          # AWVALID <= 0\n"
    io.print "  - W:                                    # Write Data Channel Action.\n"
    io.print "    - DATA   : 0                          # WDATA  <= \"32'h00000000\"\n"
    io.print "      STRB   : 0                          # WSTRB  <= \"4'b0000\"\n"
    io.print "      LAST   : 0                          # WLAST  <= 0\n"
    io.print "      VALID  : 0                          # WVALID <= 0\n"
    io.print "    - WAIT   : {AWVALID: 1, ON: on}       # wait until AWVALID = 1 \n"
    io.print "    - DATA   : ", data_str.ljust(26),   " # WDATA  <= #{data_str}\n"
    io.print "      STRB   : ", strb_str.ljust(26),   " # WSTRB  <= #{strb_str}\n"
    io.print "      LAST   : 1                          # WLAST  <= 1\n"
    io.print "      VALID  : 1                          # WVALID <= 1\n"
    io.print "    - WAIT   : {VALID: 1, READY: 1}       # wait until WVALID = 1 and WREADY = 1\n"
    io.print "    - WVALID : 0                          # WVALID <= 0\n"
    io.print "  - B:                                    # Write Responce Channel Action.\n"
    io.print "    - READY  : 0                          # BREADY <= 0\n"
    io.print "    - WAIT   : {AWVALID: 1, AWREADY: 1}   # wait until AWVALID = 1 and AWREADY = 1\n"
    io.print "    - READY  : 1                          # BREADY <= 1\n"
    io.print "    - WAIT   : {VALID: 1, READY: 1}       # wait until BVALID = 1 and BREADY = 1\n"
    io.print "    - CHECK  :                            # CHECK \n"
    io.print "        RESP : ", resp.ljust(26),       " #   RESP=#{resp}\n"
    io.print "    - READY  : 0                          # BREADY <= 0\n"
  end

  def gen_async_read(io, address, data, resp, wait)
    addr_lo  =  address % 4
    data_vec = Array.new(@axi4_data_bytes, "--")
    data.each_with_index do |value, i|
      index = addr_lo + i
      break if index >= data_vec.length
      data_vec[index] = sprintf("%02X",value)
    end
    addr_str = sprintf("0x%08X", address)
    size_str = @axi4_data_size.to_s
    wait_str = wait.to_s
    data_str = "\"32'h" + data_vec.reverse.join + "\""
    io.print "  - AR:                                   # Read Address Channel Action.\n"
    io.print "    - VALID  : 0                          # ARVALID <= 0\n"
    io.print "    - WAIT   : ", wait_str.ljust(26),   " # wait #{wait} clock\n"
    io.print "      ADDR   : ", addr_str.ljust(26),   " # ARADDR  <= #{addr_str}\n"
    io.print "      SIZE   : ", size_str.ljust(26),   " # ARSIZE  <= #{size_str}\n"
    io.print "      LEN    : 1                          # ARLEN   <= 8'h00\n"
    io.print "      VALID  : 1                          # ARVALID <= 1\n"
    io.print "    - WAIT   : {VALID : 1, READY : 1}     # wait until ARVALID = 1 and ARREADY = 1\n"
    io.print "    - VALID  : 0                          # ARVALID <= 0\n"
    io.print "  - R:\n"
    io.print "    - RREADY : 0                          # RREADY <= 0\n"
    io.print "    - WAIT   : {ARVALID: 1, ON: on}       # wait until ARVALID = 1 \n"
    io.print "    - RREADY : 1                          # RREADY <= 1\n"
    io.print "    - WAIT   : {RVALID: 1, RREADY: 1}     # wait until RVALID = 1 and RREADY = 1\n"
    io.print "    - CHECK  :                            # CHECK \n"
    io.print "        RDATA   : ", data_str.ljust(23)," #  RDATA=#{data_str}\n"
    io.print "        RLAST   : 1                       #  RLAST=1\n"
    io.print "        RRESP   : ", resp.ljust(23),    " #  RESP=#{resp}\n"
    io.print "    - RREADY : 0                          # RREADY <= 0\n"
  end

  def gen_write_read_collition_test(io)
    @no += 1
    num =  1
    io.print "---\n"
    io.print "- - [MARCHAL]\n"
    io.print "  - SAY : \"", @name, " " , @no, "\"\n"
    io.print "- - [MASTER] \n"

    init_data  = [0x00, 0x01, 0x02, 0x03,
                  0x04, 0x05, 0x06, 0x07,
                  0x08, 0x09, 0x0A, 0x0B,
                  0x0C, 0x0D, 0x0E, 0x0F]
    address = 0x00000000
    init_data.each_slice(@axi4_data_bytes) do |data|
      gen_write(io, address, data, "OKAY")
      address += @axi4_data_bytes
    end
    address = 0x00000000
    init_data.each_slice(@axi4_data_bytes) do |data|
      gen_read(io, address, data, "OKAY")
      address += @axi4_data_bytes
    end
    if @write_mode == :NC then
      last_index = init_data.length - @axi4_data_bytes
      last_data  = init_data.last(@r_num)
    end

    r_count    = (@axi4_data_bytes > @r_num) ? @axi4_data_bytes/@r_num : 1

    write_data = [0x10, 0x11, 0x12, 0x13,
                  0x14, 0x15, 0x16, 0x17]
    curr_data  = init_data.dup
    address    = 0x00000000
    index      = 0
    write_byte = 1
    write_data.each_slice(write_byte) do |w_data|
      io.print "---\n"
      io.print "- - [MASTER]\n"
      io.print "  - SAY : \"", @name, " " , @no, ".", num, "\"\n"

      w_addr = address + index
      w_wait = @w_wait + 2*(index % r_count)
      gen_async_write(io, w_addr, w_data, "OKAY", w_wait)

      index_lo = index % @axi4_data_bytes
      index_hi = index - index_lo
      r_addr   = address + index_hi
      r_data   = curr_data[index_hi,@axi4_data_bytes]
      if    @write_mode == :WF then
        r_data[index_lo, write_byte] = w_data
      elsif @write_mode == :NC then
        if r_count > 1 then
          prev_index = (index % r_count) - @r_num
          if prev_index >= 0 then
            last_data = r_data[prev_index, @r_num]
          end
        end
        r_data[index_lo, write_byte] = last_data[index % @r_num, write_byte]
      end
      gen_async_read( io, r_addr, r_data, "OKAY", @r_wait)

      curr_data[index,write_byte] = w_data
      r_data   = curr_data[index_hi,@axi4_data_bytes]
      io.print "---\n"
      io.print "- - [MASTER]\n"
      gen_read(io, r_addr, r_data, "OKAY")

      if @write_mode == :NC then
        last_data_bytes = (@r_num > @axi4_data_bytes) ? @r_num : @axi4_data_bytes
        r_addr = address + (curr_data.length - last_data_bytes)
        curr_data.last(last_data_bytes).each_slice(@axi4_data_bytes) do |r_data|
          gen_read(io, r_addr, r_data, "OKAY")
          r_addr += @axi4_data_bytes
        end
        last_data = curr_data.last(@r_num)
      end
      
      index += write_byte
      num   += 1
    end
  end
  
  def generate(file_name)
    begin
      File.open(file_name, "w") do |io|
        gen_write_read_test(io)
        gen_strb_null_test(io)
        gen_write_read_collition_test(io)
        io.print "---\n"
        io.close
      end
    rescue => e
      puts "open filed: #{e.message}"
    end
  end
end

RAM_WORDS       = 64
RAM_WORD_BITS   = 32
TEST_BENCH_LIST = [{:r_num => 4, :w_num=> 4, :write_mode => :RF},
                   {:r_num => 4, :w_num=> 4, :write_mode => :WF},
                   {:r_num => 4, :w_num=> 4, :write_mode => :NC},
                   {:r_num => 4, :w_num=> 8, :write_mode => :RF},
                   {:r_num => 4, :w_num=> 8, :write_mode => :WF},
                   {:r_num => 4, :w_num=> 8, :write_mode => :NC},
                   {:r_num => 8, :w_num=> 4, :write_mode => :RF},
                   {:r_num => 8, :w_num=> 4, :write_mode => :WF},
                   {:r_num => 8, :w_num=> 4, :write_mode => :NC},
                   {:r_num => 4, :w_num=> 1, :write_mode => :RF},
                   {:r_num => 4, :w_num=> 1, :write_mode => :WF},
                   {:r_num => 4, :w_num=> 1, :write_mode => :NC},
                   {:r_num => 1, :w_num=> 4, :write_mode => :RF},
                   {:r_num => 1, :w_num=> 4, :write_mode => :WF},
                   {:r_num => 1, :w_num=> 4, :write_mode => :NC}]

if __FILE__ == $0
  require 'optparse'

  entry_list = []
  curr_entry = {}
  verbose    = false

  parser = OptionParser.new do |opt|

    WRITE_MODE = {"RF" => :RF, "WF" => :WF, "NC" => :NC}

    opt.on("-n STRING", "--name STRING", "Scenario Name") do |v|
      unless curr_entry.empty?
        entry_list << curr_entry
        curr_entry = {}
      end
      curr_entry[:name] = v
    end

    opt.on("-r VALUE", "--r-num VALUE", "Read Word Count") do |v|
      curr_entry[:r_num] = v
    end
    
    opt.on("-w VALUE", "--w-num VALUE", "Write Word Count") do |v|
      curr_entry[:w_num] = v
    end
    
    opt.on("-m STRING", "--write-mode STRING", "Write Mode(RF, WF, NC)") do |v|
      curr_entry[:write_mode] = WRITE_MODE_LIST.fetch(v) do 
        raise OptionParser::InvalidArgment, "Invalide Write Mode: #{v}"
      end
    end

    opt.on("--read-first", "Write Mode = RF") do |v|
      curr_entry[:write_mode] = :RF
    end
      
    opt.on("--write-first", "Write Mode = WF") do |v|
      curr_entry[:write_mode] = :WF
    end
      
    opt.on("--no-change", "Write Mode = NC") do |v|
      curr_entry[:write_mode] = :WF
    end

    opt.on("-o FILE", "--output FILE", "Output Scenario File Name") do |v|
      curr_entry[:file_name] = v
    end

    opt.on("-v", "--verbose") do |v|
      verbose = true
    end
  end
      
  parser.parse!

  entry_list << curr_entry unless curr_entry.empty?

  if entry_list.empty?
    TEST_BENCH_LIST.each do |test_info|
      curr_entry = test_info.dup
      r_num      = test_info[:r_num]
      w_num      = test_info[:w_num]
      write_mode = test_info[:write_mode]
      name       = "AXI4 USPRAM #{RAM_WORDS}x#{RAM_WORD_BITS} R#{r_num}W#{w_num}#{write_mode} TEST BENCH"
      curr_entry[:name] = name
      entry_list << curr_entry
    end
  end

  entry_list.each do |entry|
    unless entry.key?(:file_name)
      entry[:file_name] = entry[:name].downcase.gsub(' ', '_') + ".snr"
    end
  end

  entry_list.each do |entry|
    name       = entry[:name]
    r_num      = entry[:r_num]
    w_num      = entry[:w_num]
    write_mode = entry[:write_mode]
    file_name  = entry[:file_name]
    if verbose == true then
      puts "- NAME: #{name}"
      puts "  FILE: #{file_name}"
      puts "  RN  : #{r_num}"
      puts "  WN  : #{w_num}"
      puts "  WM  : #{write_mode}"
    end
    gen = ScenarioGenerater.new(name, RAM_WORDS, RAM_WORD_BITS, r_num, w_num, write_mode)
    gen.generate(file_name)
  end
end
