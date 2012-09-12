-----------------------------------------------------------------------------------
--!     @file    fifo_with_done_test_bench.vhd
--!     @brief   終了処理付きFIFO用テストベンチ
--!     @version 0.1.2
--!     @date    2012/9/12
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
--! @brief テストベンチのベースモデル(エンティティ宣言)
-----------------------------------------------------------------------------------
library ieee;
use     ieee.std_logic_1164.all;
entity  FIFO_WITH_DONE_TEST_BENCH is
    generic (
        FIFO_DEPTH  : --! @brief FIFO DEPTH :
                      --! FIFOの深さを２のべき乗値で指定する.
                      integer := 16;
        I_CLK_PERIOD: --! @breif INPUT CLOCK PERIOD :
                      time    := 10 ns;
        I_CLK_RATE  : --! @brief INPUT CLOCK RATE :
                      --! O_CLK_RATEとペアで入力側のクロック(I_CLK)と出力側のクロッ
                      --! ク(O_CLK)との関係を指定する.
                      integer :=  1;
        O_CLK_PERIOD: --! @breif OUTPUT CLOCK PERIOD :
                      time    := 10 ns;
        O_CLK_RATE  : --! @brief OUTPUT CLOCK RATE :
                      --! I_CLK_RATEとペアで入力側のクロック(I_CLK)と出力側のクロッ
                      --! ク(O_CLK)との関係を指定する.
                      integer :=  1;
        DELAY_CYCLE : --! @brief DELAY CYCLE :
                      --! 入力側から出力側への転送する際の遅延サイクルを指定する.
                      integer :=  0;
        AUTO_FINISH : integer :=  1
    );
    port (
        FINISH      : out std_logic
    );
end FIFO_WITH_DONE_TEST_BENCH;
-----------------------------------------------------------------------------------
-- テストベンチのベースモデル(アーキテクチャ本体)
-----------------------------------------------------------------------------------
library DUMMY_PLUG;
use     DUMMY_PLUG.UTIL.INTEGER_TO_STRING;
use     WORK.FIFO_WITH_DONE_COMPONENTS.FIFO_WITH_DONE;
architecture MODEL of FIFO_WITH_DONE_TEST_BENCH is
    constant DATA_WIDTH  : integer := 3;
    constant DELAY       : time    :=  1 ns;
    signal   SCENARIO    : STRING(1 to 5);
    signal   RST         : std_logic;
    signal   I_CLK       : std_logic;
    signal   I_CKE       : std_logic;
    signal   I_DATA      : std_logic_vector(2**DATA_WIDTH-1 downto 0);
    signal   I_DONE      : std_logic;
    signal   I_VAL       : std_logic;
    signal   I_RDY       : std_logic;
    signal   I_COUNT     : std_logic_vector(FIFO_DEPTH   downto 0);
    signal   O_CLK       : std_logic;
    signal   O_CKE       : std_logic;
    signal   O_DATA      : std_logic_vector(2**DATA_WIDTH-1 downto 0);
    signal   O_DONE      : std_logic;
    signal   O_VAL       : std_logic;
    signal   O_RDY       : std_logic;
    signal   O_COUNT     : std_logic_vector(FIFO_DEPTH   downto 0);
    function MESSAGE_TAG return STRING is
    begin
        return "(FIFO_DEPTH="  & INTEGER_TO_STRING(FIFO_DEPTH ) &
               ",I_CLK_RATE="  & INTEGER_TO_STRING(I_CLK_RATE ) &
               ",O_CLK_RATE="  & INTEGER_TO_STRING(O_CLK_RATE ) &
               ",DELAY_CYCLE=" & INTEGER_TO_STRING(DELAY_CYCLE) &
               "):";
    end function;
begin
    -------------------------------------------------------------------------------
    -- 
    -------------------------------------------------------------------------------
    DUT:  FIFO_WITH_DONE 
        generic map (
            FIFO_DEPTH  => FIFO_DEPTH,
            DATA_WIDTH  => DATA_WIDTH,
            I_CLK_RATE  => I_CLK_RATE,
            O_CLK_RATE  => O_CLK_RATE,
            DELAY_CYCLE => DELAY_CYCLE
        )
        port map(
            RST         => RST,
            I_CLK       => I_CLK,
            I_CKE       => I_CKE,
            I_DATA      => I_DATA,
            I_DONE      => I_DONE,
            I_VAL       => I_VAL,
            I_RDY       => I_RDY,
            I_COUNT     => I_COUNT,
            O_CLK       => O_CLK,
            O_CKE       => O_CKE,
            O_DATA      => O_DATA,
            O_DONE      => O_DONE,
            O_RDY       => O_RDY,
            O_COUNT     => O_COUNT
        );

    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    ASYNC: if (I_CLK_RATE = 0 and O_CLK_RATE = 0) generate
        process begin
            I_CLK <= '1'; wait for I_CLK_PERIOD/2;
            I_CLK <= '0'; wait for I_CLK_PERIOD/2;
        end process;
        process begin
            O_CLK <= '1'; wait for O_CLK_PERIOD/2;
            O_CLK <= '0'; wait for O_CLK_PERIOD/2;
        end process;
        I_CKE <= '1';
        O_CKE <= '1';
    end generate;
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    WSYNC: if (I_CLK_RATE >= 1 and O_CLK_RATE = 1) generate
        process begin
            I_CLK <= '0';
            I_CKE <= '1';
            O_CLK <= '0';
            O_CKE <= '1';
            MAIN_LOOP : loop 
                for i in 1 to I_CLK_RATE loop
                    wait for O_CLK_PERIOD/(I_CLK_RATE*2);
                    O_CLK <= '1';
                    I_CLK <= not I_CLK;
                    if (i = 1) then
                        I_CKE <= '1';
                    else
                        I_CKE <= '0';
                    end if;
                end loop;
                for i in 1 to I_CLK_RATE loop
                    wait for O_CLK_PERIOD/(I_CLK_RATE*2);
                    O_CLK <= '0';
                    I_CLK <= not I_CLK;
                    if (i = I_CLK_RATE) then
                        I_CKE <= '1';
                    else
                        I_CKE <= '0';
                    end if;
                end loop;
            end loop;
        end process;
    end generate;
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    RSYNC: if (I_CLK_RATE = 1 and O_CLK_RATE >= 2) generate
        process begin
            I_CLK <= '0';
            I_CKE <= '1';
            O_CLK <= '0';
            O_CKE <= '1';
            MAIN_LOOP : loop 
                for i in 1 to O_CLK_RATE loop
                    wait for I_CLK_PERIOD/(O_CLK_RATE*2);
                    I_CLK <= '1';
                    O_CLK <= not O_CLK;
                    if (i = 1) then
                        O_CKE <= '1';
                    else
                        O_CKE <= '0';
                    end if;
                end loop;
                for i in 1 to O_CLK_RATE loop
                    wait for I_CLK_PERIOD/(O_CLK_RATE*2);
                    I_CLK <= '0';
                    O_CLK <= not O_CLK;
                    if (i = O_CLK_RATE) then
                        O_CKE <= '1';
                    else
                        O_CKE <= '0';
                    end if;
                end loop;
            end loop;
        end process;
    end generate;
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    process 
        procedure WAIT_I_CLK(CNT:integer) is
        begin
            if (CNT > 0) then
                for i in 1 to CNT loop 
                    wait until (I_CLK'event and I_CLK = '1'); 
                end loop;
            end if;
            wait for DELAY;
        end WAIT_I_CLK;
    begin
        ---------------------------------------------------------------------------
        -- シミュレーションの開始、まずはリセットから。
        ---------------------------------------------------------------------------
        assert(false) report MESSAGE_TAG & "Starting Run..." severity NOTE;
                        SCENARIO <= "START";
                        RST      <= '1';
                        I_VAL    <= '0';
                        I_DONE   <= '0';
                        I_DATA   <= (others => '0');
                        O_RDY    <= '0';
                        FINISH   <= '0';
        WAIT_I_CLK( 4); RST      <= '0';
        ---------------------------------------------------------------------------
        -- シミュレーション終了
        ---------------------------------------------------------------------------
        WAIT_I_CLK(10); 
        if (AUTO_FINISH = 0) then
            assert(false) report MESSAGE_TAG & " Run complete..." severity NOTE;
            FINISH <= 'Z';
        else
            FINISH <= 'Z';
            assert(false) report MESSAGE_TAG & " Run complete..." severity FAILURE;
        end if;
        wait;
    end process;
end MODEL;
