-----------------------------------------------------------------------------------
--!     @file    delay_register_test_bench.vhd
--!     @brief   DELAY REGISTER/ADJUSTER TEST BENCH :
--!              DELAY REGISTER/ADJUSTERを検証するためのテストベンチ.
--!     @version 1.0.0
--!     @date    2012/8/11
--!     @author  Ichiro Kawazome <ichiro_k@ca2.so-net.ne.jp>
-----------------------------------------------------------------------------------
--
--      Copyright (C) 2012 Ichiro Kawazome
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
-----------------------------------------------------------------------------------
-- コンポーネント宣言
-----------------------------------------------------------------------------------
library ieee;
use     ieee.std_logic_1164.all;
package COMPONENTS is
component DELAY_REGISTER_TEST_BENCH
    generic (
        DATA_BITS   : integer := 8;
        DELAY_MIN   : integer := 0;
        DELAY_MAX   : integer := 1;
        AUTO_FINISH : integer := 1
    );
    port (
        FINISH      : out std_logic
    );
end component;
end COMPONENTS;
-----------------------------------------------------------------------------------
-- エンティティ宣言
-----------------------------------------------------------------------------------
library ieee;
use     ieee.std_logic_1164.all;
entity  DELAY_REGISTER_TEST_BENCH is
    generic (
        DATA_BITS   : integer := 8;
        DELAY_MIN   : integer := 0;
        DELAY_MAX   : integer := 1;
        AUTO_FINISH : integer := 1
    );
    port (
        FINISH      : out std_logic
    );
end     DELAY_REGISTER_TEST_BENCH;
-----------------------------------------------------------------------------------
-- アーキテクチャ本体
-----------------------------------------------------------------------------------
library ieee;
use     ieee.std_logic_1164.all;
use     ieee.numeric_std.all;
library DUMMY_PLUG;
use     DUMMY_PLUG.UTIL.INTEGER_TO_STRING;
library PIPEWORK;
use     PIPEWORK.COMPONENTS.DELAY_REGISTER;
use     PIPEWORK.COMPONENTS.DELAY_ADJUSTER;
architecture MODEL of DELAY_REGISTER_TEST_BENCH is
    constant    PERIOD          : time    := 10 ns;
    constant    DELAY           : time    :=  1 ns;
    signal      CLK             : std_logic;
    signal      RST             : std_logic;
    signal      CLR             : std_logic;
    signal      SEL             : std_logic_vector(DELAY_MAX downto DELAY_MIN);
    signal      reg_data_val    : std_logic_vector(DELAY_MAX downto 0);
    signal      reg_i_data      : std_logic_vector(DATA_BITS-1 downto 0);
    signal      reg_i_valid     : std_logic;
    signal      reg_o_data      : std_logic_vector(DATA_BITS-1 downto 0);
    signal      reg_o_valid     : std_logic;
    signal      adj_i_data      : std_logic_vector(DATA_BITS-1 downto 0);
    signal      adj_i_valid     : std_logic;
    signal      adj_o_data      : std_logic_vector(DATA_BITS-1 downto 0);
    signal      adj_o_valid     : std_logic;
    function    MESSAGE_TAG return STRING is
    begin
        return "(DATA_BITS="  & INTEGER_TO_STRING(DATA_BITS) &
               ",DELAY_MIN="  & INTEGER_TO_STRING(DELAY_MIN) &
               ",DELAY_MAX="  & INTEGER_TO_STRING(DELAY_MAX) &
               "):";
    end function;
begin
    REG: DELAY_REGISTER
        generic map (
            DATA_BITS => DATA_BITS,
            DELAY_MIN => DELAY_MIN,
            DELAY_MAX => DELAY_MAX
        )
        port map (
            CLK       => CLK,
            RST       => RST,
            CLR       => CLR,
            SEL       => SEL,
            D_VAL     => reg_data_val,
            I_DATA    => reg_i_data,
            I_VAL     => reg_i_valid,
            O_DATA    => reg_o_data,
            O_VAL     => reg_o_valid
        );
    ADJ: DELAY_ADJUSTER
        generic map (
            DATA_BITS => DATA_BITS,
            DELAY_MIN => DELAY_MIN,
            DELAY_MAX => DELAY_MAX
        )
        port map (
            CLK       => CLK,
            RST       => RST,
            CLR       => CLR,
            SEL       => SEL,
            D_VAL     => reg_data_val,
            I_DATA    => adj_i_data,
            I_VAL     => adj_i_valid,
            O_DATA    => adj_o_data,
            O_VAL     => adj_o_valid
        );
    process begin
        CLK <= '1'; wait for PERIOD/2;
        CLK <= '0'; wait for PERIOD/2;
    end process;

    process
        procedure WAIT_CLK(CNT:integer) is
        begin
            for i in 1 to CNT loop 
                wait until (CLK'event and CLK = '1'); 
            end loop;
            wait for DELAY;
        end procedure;
        procedure SET_REG(DATA: integer) is
        begin 
            reg_i_data  <= std_logic_vector(to_unsigned(DATA,DATA_BITS));
            reg_i_valid <= '1';
            WAIT_CLK(1);
            reg_i_valid <= '0';
        end procedure;
        procedure SET_ADJ(DATA: integer) is
        begin 
            adj_i_data  <= std_logic_vector(to_unsigned(DATA,DATA_BITS));
            adj_i_valid <= '1';
            WAIT_CLK(1);
            adj_i_valid <= '0';
        end procedure;
        procedure SET_REG_ADJ(REG_DATA,ADJ_DATA: integer) is
        begin 
            reg_i_data  <= std_logic_vector(to_unsigned(REG_DATA,DATA_BITS));
            adj_i_data  <= std_logic_vector(to_unsigned(ADJ_DATA,DATA_BITS));
            reg_i_valid <= '1';
            adj_i_valid <= '1';
            WAIT_CLK(1);
            reg_i_valid <= '0';
            adj_i_valid <= '0';
        end procedure;
    begin
        ---------------------------------------------------------------------------
        -- シミュレーションの開始、まずはリセットから。
        ---------------------------------------------------------------------------
        assert(false) report MESSAGE_TAG & "Starting Run..." severity NOTE;
                              CLR  <= '1';
                              RST  <= '1';
                              SEL  <= (others => '0');
                              reg_i_data  <= (others => '0');
                              reg_i_valid <= '0';
                              adj_i_data  <= (others => '0');
                              adj_i_valid <= '0';
        WAIT_CLK( 4);         RST  <= '0';
                              CLR  <= '0';
        WAIT_CLK( 4);
        ---------------------------------------------------------------------------
        -- 
        ---------------------------------------------------------------------------
        for DELAY_CYCLE in DELAY_MIN to DELAY_MAX loop
            for i in SEL'range loop
                if (i = DELAY_CYCLE) then
                    SEL(i) <= '1';
                else
                    SEL(i) <= '0';
                end if;
            end loop;
            for DATA in 0 to 15 loop
                SET_REG(DATA);
            end loop;
            WAIT_CLK(DELAY_CYCLE);
            for DATA in 16 to 22 loop
                SET_REG(DATA);
                WAIT_CLK(1);
            end loop;
            WAIT_CLK(DELAY_CYCLE);
            for DATA in 16 to 22 loop
                SET_REG(DATA);
                WAIT_CLK(2);
            end loop;
            WAIT_CLK(DELAY_CYCLE);

            SET_REG_ADJ(16#01#,16#FF#);
            WAIT_CLK(DELAY_CYCLE);

            SET_REG(16#02#);
            SET_ADJ(16#FE#);
            WAIT_CLK(DELAY_CYCLE);

            SET_REG(16#03#);
            WAIT_CLK(1);
            SET_ADJ(16#FD#);
            WAIT_CLK(DELAY_CYCLE);

            SET_REG(16#04#);
            WAIT_CLK(2);
            SET_ADJ(16#FC#);
            WAIT_CLK(DELAY_CYCLE);
            
            SET_REG(16#05#);
            WAIT_CLK(3);
            SET_ADJ(16#FB#);
            WAIT_CLK(DELAY_CYCLE);
        end loop;
        ---------------------------------------------------------------------------
        -- シミュレーション終了
        ---------------------------------------------------------------------------
        WAIT_CLK(10); 
        if (AUTO_FINISH = 0) then
            assert(false) report MESSAGE_TAG & "Run complete..." severity NOTE;
            FINISH <= 'Z';
        else
            FINISH <= 'Z';
            assert(false) report MESSAGE_TAG & "Run complete..." severity FAILURE;
        end if;
        wait;
    end process;
end MODEL;
-----------------------------------------------------------------------------------
-- DELAY_REGISTER_TEST_BENCH_ALL
-----------------------------------------------------------------------------------
library ieee;
use     ieee.std_logic_1164.all;
entity  DELAY_REGISTER_TEST_BENCH_ALL is
end     DELAY_REGISTER_TEST_BENCH_ALL;
library ieee;
use     ieee.std_logic_1164.all;
use     WORK.COMPONENTS.DELAY_REGISTER_TEST_BENCH;
architecture MODEL of DELAY_REGISTER_TEST_BENCH_ALL is
    signal FINISH : std_logic;
begin
    DELAY_MIN_GEN : for DELAY_MIN in 0         to 3 generate
    DELAY_MAX_GEN : for DELAY_MAX in DELAY_MIN to 3 generate
        TB:DELAY_REGISTER_TEST_BENCH
            generic map (
                DATA_BITS   => 8,
                DELAY_MIN   => DELAY_MIN,
                DELAY_MAX   => DELAY_MAX,
                AUTO_FINISH => 0
            )
            port map (
                FINISH      => FINISH
            );
    end generate;
    end generate;
    FINISH <= 'H' after 1 ns;
    process (FINISH) begin
        if (FINISH'event and FINISH = 'H') then
            assert(false) report "Run complete all." severity FAILURE;
        end if;
    end process;
end MODEL;
-----------------------------------------------------------------------------------
-- DELAY_REGISTER_TEST_BENCH_8_3_3
-----------------------------------------------------------------------------------
library ieee;
use     ieee.std_logic_1164.all;
entity  DELAY_REGISTER_TEST_BENCH_8_3_3 is
end     DELAY_REGISTER_TEST_BENCH_8_3_3;
library ieee;
use     ieee.std_logic_1164.all;
use     WORK.COMPONENTS.DELAY_REGISTER_TEST_BENCH;
architecture MODEL of DELAY_REGISTER_TEST_BENCH_8_3_3 is
begin
    TB:DELAY_REGISTER_TEST_BENCH
        generic map (
            DATA_BITS   => 8,
            DELAY_MIN   => 3,
            DELAY_MAX   => 3,
            AUTO_FINISH => 1
        )
        port map (
            FINISH      => open
        );
end MODEL;