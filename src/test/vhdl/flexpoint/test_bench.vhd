-----------------------------------------------------------------------------------
--!     @file    test_bench.vhd
--!     @brief   Flexable Float/Fixed Point Numeric Test Bench
--!     @version 1.8.0
--!     @date    2020/3/19
--!     @author  Ichiro Kawazome <ichiro_k@ca2.so-net.ne.jp>
-----------------------------------------------------------------------------------
--
--      Copyright (C) 2020 Ichiro Kawazome
--      All rights reserved.
--
--      Redistribution and use in source and binary forms, with or without
--      modification, are permitted provided that the following conditions
--      are met:
--
--        1. Redistributions of source code must retain the above copyright
--           notice, this list of conditions and the following disclaimer.
--
--        2. Redistributions in binary form must reproduce the above copyright
--           notice, this list of conditions and the following disclaimer in
--           the documentation and/or other materials provided with the
--           distribution.
--
--      THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
--      "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
--      LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
--      A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT
--      OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
--      SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
--      LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
--      DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
--      THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT 
--      (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
--      OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
--
-----------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- 
--------------------------------------------------------------------------------
library ieee;
use     ieee.std_logic_1164.all;
use     ieee.numeric_std.all; 
use     std.textio.all;
library PIPEWORK;
use     PIPEWORK.FLEX_POINT_TYPES.all;
library DUMMY_PLUG;
use     DUMMY_PLUG.UTIL.all;
--------------------------------------------------------------------------------
-- 
--------------------------------------------------------------------------------
entity  TEST_BENCH is 
    generic (
        NAME            : STRING  := "test";
        FINISH_ABORT    : boolean := FALSE
    );
end     TEST_BENCH;
-------------------------------------------------------------------------------
-- 
--------------------------------------------------------------------------------
architecture stimulus of TEST_BENCH is
    ----------------------------------------------------------------------------
    -- 時間の定義
    ----------------------------------------------------------------------------
    constant  PERIOD         :  time := 10 ns;
    constant  DELAY          :  time :=  1 ns;
    ----------------------------------------------------------------------------
    -- 
    ----------------------------------------------------------------------------
    constant  A_PARAM        :  FLEX_POINT_PARAM_TYPE := FLEX_FLOAT_POINT_16;
    constant  B_PARAM        :  FLEX_POINT_PARAM_TYPE := FLEX_FLOAT_POINT_16;
    constant  M_PARAM        :  FLEX_POINT_PARAM_TYPE := MULTIPLY(A_PARAM, B_PARAM);
    constant  Q_PARAM        :  FLEX_POINT_PARAM_TYPE := TO_FIXED_POINT(M_PARAM);
    ----------------------------------------------------------------------------
    -- 各種信号の定義
    ----------------------------------------------------------------------------
    signal    clk_ena        :  boolean;
    signal    CLK            :  std_logic;
    signal    RST            :  std_logic;
    signal    CLR            :  std_logic;
    signal    A              :  std_logic_vector(A_PARAM.BITS-1 downto 0);
    signal    B              :  std_logic_vector(B_PARAM.BITS-1 downto 0);
    signal    M              :  std_logic_vector(M_PARAM.BITS-1 downto 0);
    signal    Q              :  std_logic_vector(Q_PARAM.BITS-1 downto 0);
begin
    ----------------------------------------------------------------------------
    -- クロックの生成
    ----------------------------------------------------------------------------
    process begin
        loop
            CLK <= '1'; wait for PERIOD / 2;
            CLK <= '0'; wait for PERIOD / 2;
            exit when (clk_ena = FALSE);
        end loop;
        CLK <= '0';
        wait;
    end process;
    CLR <= '0';
    ----------------------------------------------------------------------------
    -- DUT
    ----------------------------------------------------------------------------
    DUT: block
        constant  I_A_PARAM  :  FLEX_POINT_PARAM_TYPE := COMPLEMENT(A_PARAM);
        constant  I_B_PARAM  :  FLEX_POINT_PARAM_TYPE := COMPLEMENT(B_PARAM);
        signal    i_a        :  std_logic_vector(I_A_PARAM.BITS-1 downto 0);
        signal    i_b        :  std_logic_vector(I_B_PARAM.BITS-1 downto 0);
    begin
        process (CLK, RST) begin
            if (RST = '1') then
                    i_a <= (others => '0');
                    i_b <= (others => '0');
                    M   <= (others => '0');
                    Q   <= (others => '0');
            elsif (CLK'event and CLK = '1') then
                if (CLR = '1') then
                    i_a <= (others => '0');
                    i_b <= (others => '0');
                    M   <= (others => '0');
                    Q   <= (others => '0');
                else
                    i_a <= COMPLEMENT(I_A_PARAM, A_PARAM, A);
                    i_b <= COMPLEMENT(I_B_PARAM, B_PARAM, B);
                    M   <= MULTIPLY      (M_PARAM, I_A_PARAM, i_a, I_B_PARAM, i_b);
                    Q   <= TO_FIXED_POINT(Q_PARAM, M_PARAM  , M);
                end if;
            end if;
        end process;
    end block;
    ----------------------------------------------------------------------------
    -- テスト開始
    ----------------------------------------------------------------------------
    process
        variable MISMATCH : integer := 0;
        procedure WAIT_CLK(CNT:in integer) is
        begin
            for i in 1 to CNT loop 
                wait until (CLK'event and CLK = '1'); 
            end loop;
        end procedure;
        procedure SET(A_STR,B_STR:string) is
            variable a_data  :  std_logic_vector(A_PARAM.BITS-1 downto 0);
            variable b_data  :  std_logic_vector(B_PARAM.BITS-1 downto 0);
            variable str_len :  integer;
        begin
            STRING_TO_STD_LOGIC_VECTOR(A_STR, a_data, str_len);
            STRING_TO_STD_LOGIC_VECTOR(B_STR, b_data, str_len);
            A <= a_data;
            B <= b_data;
        end procedure;
    begin
        clk_ena <= TRUE;
        wait for DELAY;RST<='1';SET("0x0000","0x0000");WAIT_CLK(1);
        wait for DELAY;RST<='0';SET("0x3C00","0x3C00");WAIT_CLK(1);
        wait for DELAY;RST<='0';SET("0x4000","0x3C00");WAIT_CLK(1);
        wait for DELAY;                                WAIT_CLK(10);
        assert(MISMATCH =0) 
                report "Simulation complete(mismatch)." severity FAILURE;
        if (FINISH_ABORT) then
            assert FALSE
                report "Simulation complete(success)."  severity FAILURE;
        else
            assert FALSE
                report "Simulation complete(success)."  severity NOTE;
        end if;
        clk_ena <= FALSE;
        wait;
    end process;
end stimulus;
