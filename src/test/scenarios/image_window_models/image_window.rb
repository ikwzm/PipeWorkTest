#!/usr/bin/env ruby
# -*- coding: utf-8 -*-
#---------------------------------------------------------------------------------
#
#       Version     :   1.8.0
#       Created     :   2019/1/8
#       File name   :   image_window.rb
#       Author      :   Ichiro Kawazome <ichiro_k@ca2.so-net.ne.jp>
#       Description :   IMAGE_WINDOW用シナリオ生成モジュール
#
#---------------------------------------------------------------------------------
#
#       Copyright (C) 2019 Ichiro Kawazome
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
module Dummy_Plug
  module ScenarioWriter
    module ImageWindow

      ATRB_BITS = 3

      class Atrb
        attr_reader :valid, :start, :last
        def initialize(valid, start, last)
          def to_boolan(x)
            if    x == TRUE or x == FALSE then
              return x
            elsif x == 1 then
              return TRUE
            elsif x == 0 then
              return FALSE
            else
              raise ArgumentError
            end
          end
          @valid = to_boolan(valid)
          @start = to_boolan(start)
          @last  = to_boolan(last )
          @bits  = ATRB_BITS
        end
        def to_int
          return ((@valid == TRUE) ? 1 : 0 ) |
                 ((@start == TRUE) ? 2 : 0 ) |
                 ((@last  == TRUE) ? 4 : 0 )
        end
      end

      class Range
        attr_reader :size, :lo, :hi
        def initialize(x)
          if    x.class == Fixnum then
            @lo   = 0
            @hi   = x-1
            @size = x
          elsif x.class == Range  then
            @lo   = x.min
            @hi   = x.max
            @size = x.size
          elsif x.class == Array  then
            @lo   = x[0]
            @hi   = x[1]
            @size = @hi - @lo + 1
          else
            raise ArgumentError
          end
        end
      end

      class Data
        attr_reader :size, :lo, :hi
        attr_reader :elem_field
        attr_reader :info_field
        attr_reader :atrb_field
        attr_reader :atrb_c_field
        attr_reader :atrb_x_field
        attr_reader :atrb_y_field
        def initialize(elem_bits, info_bits, shape)
          def new_field(prev_field, size)
            if prev_field.nil?
              return Range.new(size)
            else 
              return Range.new([prev_field.hi+1, prev_field.hi+1+size-1])
            end
          end
          @elem_field   = new_field(nil          , elem_bits * shape.c.size * shape.x.size * shape.y.size)
          @atrb_c_field = new_field(@elem_field  , ATRB_BITS * shape.c.size)
          @atrb_x_field = new_field(@atrb_c_field, ATRB_BITS * shape.x.size)
          @atrb_y_field = new_field(@atrb_x_field, ATRB_BITS * shape.y.size)
          @atrb_field   = Range.new([@atrb_c_field.lo, @atrb_y_field.hi])
          @info_field   = new_field(@atrb_field  , info_bits)
          if (info_bits > 0)
            @hi = @info_field.hi
          else
            @hi = @atrb_field.hi
          end
          @lo   = @elem_field.lo
          @size = @hi - @lo + 1
        end
      end

      class Shape
        attr_reader :c, :x, :y, :size
        def initialize(c,x,y)
          if c.class == Dummy_Plug::ScenarioWriter::ImageWindow::Range then
            @c = c
          else
            @c = Range.new(c)
          end
          if x.class == Dummy_Plug::ScenarioWriter::ImageWindow::Range then
            @x = x
          else
            @x = Range.new(x)
          end
          if y.class == Dummy_Plug::ScenarioWriter::ImageWindow::Range then
            @y = y
          else
            @y = Range.new(y)
          end
          @size = c.size * x.size * y.size
        end
      end

      class Stride
        attr_reader :x, :y
        def initialize(x,y)
          @x = x
          @y = y
        end
      end

      class Base
        attr_reader :name
        attr_reader :elem_bits, :atrb_bits, :info_bits
        attr_reader :shape, :stride, :data, :border_type
        def initialize(name, elem_bits, info_bits, shape, stride)
          @name      = name
          @elem_bits = elem_bits
          @atrb_bits = ATRB_BITS
          @info_bits = info_bits
          if    shape.class == Dummy_Plug::ScenarioWriter::ImageWindow::Shape then
            @shape   = shape
          elsif shape.class == Array then
            @shape   = Shape.new(shape[0],shape[1],shape[2])
          else
            raise ArgumentError
          end
          if    stride.class == Dummy_Plug::ScenarioWriter::ImageWindow::Stride then
            @stride  = stride
          elsif stride.class == Array then
            @stride  = Stride.new(stride[0], stride[1])
          else
            raise ArgumentError
          end
          @data = Data.new(@elem_bits, @info_bits, @shape)
        end
        def gen_data_array(data, value, d_size, d_unroll)
          data_array = Array.new
          y_size     = data.size
          x_size     = data[0].size
          c_size     = data[0][0].size
          y_last_pos = y_size-(@shape.y.size-@stride.y+1)
          y_last_pos = 0 if (y_last_pos < 0)
          x_last_pos = x_size-(@shape.x.size-@stride.x+1)
          x_last_pos = 0 if (x_last_pos < 0)
          y_pos = 0
          while y_pos <= y_last_pos do
            x_pos = 0
            while x_pos <= x_last_pos do
              d_pos = 0
              while d_pos < d_size do
                c_pos  = 0
                while c_pos < c_size do
                  elem   = Array.new
                  atrb_c = Array.new
                  atrb_x = Array.new
                  atrb_y = Array.new
                  for y in 0...@shape.y.size do
                    elem_x = Array.new
                    for x in 0...@shape.x.size do
                      elem_c = Array.new
                      for c in 0 ...@shape.c.size do
                        if (y_pos+y < y_size) and
                           (x_pos+x < x_size) and
                           (c_pos+c < c_size) then
                          elem_c.push(data[y_pos+y][x_pos+x][c_pos+c])
                        else
                          elem_c.push(value)
                        end
                      end
                      elem_x.push(elem_c)
                    end
                    elem.push(elem_x)
                  end
                  for c in 0 ...@shape.c.size do
                    atrb_c.push(Atrb.new((c_pos + c >= 0 and c_pos + c <= c_size-1), (c_pos + c == 0), (c_pos + c >= c_size-1)).to_int)
                  end
                  for x in 0 ...@shape.x.size do
                    atrb_x.push(Atrb.new((x_pos + x >= 0 and x_pos + x <= x_size-1), (x_pos + x == 0), (x_pos + x >= x_size-1)).to_int)
                  end
                  for y in 0 ...@shape.y.size do
                    atrb_y.push(Atrb.new((y_pos + y >= 0 and y_pos + y <= y_size-1), (y_pos + y == 0), (y_pos + y >= y_size-1)).to_int)
                  end
                  data_array.push({:ELEM => elem, :ATRB => {:C => atrb_c, :X => atrb_x, :Y => atrb_y}}) 
                  c_pos += @shape.c.size
                end
                d_pos += d_unroll
              end
              x_pos += @stride.x
            end
            y_pos += @stride.y
          end
          return data_array
        end

        def output_name(indent)
          str = indent + "#{@name} : \n"
        end

        def output_elem(indent, elem)
          if (@elem_bits % 4 == 0) then
            string_size     = @elem_bits/4
            dontcare_string = '"' + "#{@elem_bits}'x" + ("-" * string_size) + '"'
            element_format  = "0x%0#{string_size}X"
          else
            dontcare_string = '"' + "#{@elem_bits}'b" + ("-" * @elem_bits ) + '"'
            element_format  = "%d"
          end
          str = indent + "ELEM : "
                         "       [" "[["
                         "        "
                         "       ]"
          str += "[" + elem.each.map{|elem_line|
                   "[" + elem_line.each.map{|elem_chan|
                     "[" + elem_chan.map{ |element|
                       if element == '-' then
                         dontcare_string
                       else
                         sprintf(element_format, element)
                       end
                     }.join(", ") + "]"
                   }.join(",") + "]"
                 }.join(", \n"+indent+"        ") + "]\n"
          return str
        end

        def output_atrb(indent, atrb)
          str = indent + "ATRB : {C: #{atrb[:C]}, X: #{atrb[:X]}, Y: #{atrb[:Y]}}\n"
        end

        def output_valid(indent, value)
          str = indent + "VALID: #{value}\n"
        end          

        def output_ready(indent, value)
          str = indent + "READY: #{value}\n"
        end          

        def wait_valid(indent, value)
          str = indent + "WAIT : {VALID: #{value}}\n"
        end          

        def wait_ready(indent, value)
          str = indent + "WAIT : {READY: #{value}}\n"
        end          

        def wait_cycle(indent, value)
          str = indent + "WAIT : #{value}\n"
        end          
      end

      class Master < Base

        def initialize(name, elem_bits, info_bits, shape, stride)
          super(name, elem_bits, info_bits, shape, stride)
        end

        def output_data(io, indent, data)
          array_indent = indent + "- "
          gen_data_array(data, 0, 1, 1).each do |line|
            if block_given? then
              cycle = yield
              if cycle > 0 then
                io.print wait_cycle(array_indent, cycle)
              end
            end
            io.print output_elem( array_indent, line[:ELEM])
            io.print output_atrb( array_indent, line[:ATRB])
            io.print output_valid(array_indent, 1)
            io.print wait_ready(  array_indent, 1)
            io.print output_valid(array_indent, 0)
          end
        end
      end

      class Slave  < Base

        def initialize(name, elem_bits, info_bits, shape, stride)
          super(name, elem_bits, info_bits, shape, stride)
        end

        def check_data(io, indent, data, d_size=1, d_unroll=1)
          array_indent = indent + "- "
          check_indent = indent + "   "
          gen_data_array(data, '-', d_size, d_unroll).each do |line|
            if block_given? then
              cycle = yield
              if cycle > 0 then
                io.print wait_cycle(array_indent, cycle)
              end
            end
            io.print output_ready( array_indent, 1)
            io.print wait_valid(   array_indent, 1)
            io.print array_indent + "CHECK: \n"
            io.print output_elem(check_indent, line[:ELEM])
            io.print output_atrb(check_indent, line[:ATRB])
            io.print output_ready( array_indent, 0)
          end
        end
      end
    end
  end
end
