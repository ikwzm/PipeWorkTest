-----------------------------------------------------------------------------------
--!     @file    fifo_with_done_test_bench.vhd
--!     @brief   終了処理付きFIFO用テストベンチ
--!     @version 0.1.3
--!     @date    2012/9/20
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
                      integer := 10;
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
library ieee;
use     ieee.std_logic_1164.all;
use     ieee.numeric_std.all;
library DUMMY_PLUG;
use     DUMMY_PLUG.UTIL.INTEGER_TO_STRING;
use     DUMMY_PLUG.UTIL.HEX_TO_STRING;
use     DUMMY_PLUG.TINYMT32.all;
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
    signal   o_start     : std_logic;
    signal   o_run       : std_logic;
    signal   o_total_size: integer;
    signal   o_block_size: integer;
    signal   o_rand_seed : integer;
    signal   o_wait_scale: real;
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
            O_VAL       => O_VAL,
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
    -- 出力側のチェック
    -------------------------------------------------------------------------------
    process
        variable  total_size        : integer;
        variable  remain_size       : integer;
        variable  block_size        : integer;
        variable  exp_o_data        : integer;
        variable  curr_count        : integer;
        variable  done_asserted     : boolean;
        variable  wait_time_gen     : PSEUDO_RANDOM_NUMBER_GENERATOR_TYPE;
        constant  mat1              : SEED_TYPE           := X"8f7011ee";
        constant  mat2              : SEED_TYPE           := X"fc78ff1f";
        constant  tmat              : RANDOM_NUMBER_TYPE  := X"3793fdff";
        variable  wait_time_scale   : real;
        variable  wait_time_count   : real;
        variable  wait_time_incr    : real;
        procedure PULL_DATA(SIZE:integer) is
            variable  remain_size : integer;
            variable  wait_time   : real;
        begin
            remain_size := SIZE;
            PULL_LOOP: while(remain_size > 0) loop
                O_RDY <= '0' after DELAY;
                if (wait_time_scale > 0.0) then
                    WAIT_LOOP: loop
                        if (wait_time_count <  1.0) then
                            GENERATE_RANDOM_REAL1(wait_time_gen, wait_time_incr);
                            wait_time_count := wait_time_count + wait_time_incr * wait_time_scale;
                        end if;
                        if (wait_time_count >= 1.0) then
                            wait_time_count := wait_time_count - 1.0;
                            wait until (O_CLK'event and O_CLK = '1');
                        else
                            exit;
                        end if;
                    end loop;
                end if;
                O_RDY <= '1' after DELAY;
                wait until (O_CLK'event and O_CLK = '1');
                if (O_VAL  = '1') then
                    assert (O_DATA = std_logic_vector(to_unsigned(exp_o_data,O_DATA'length)))
                        report MESSAGE_TAG & "Mismatch O_DATA " &
                               "O_DATA="    & HEX_TO_STRING(O_DATA) &
                               ",EXP_DATA=" & HEX_TO_STRING(exp_o_data, O_DATA'length)
                        severity WARNING;
                    exp_o_data  := (exp_o_data  + 1) mod (2**O_DATA'length);
                    remain_size := remain_size - 1;
                end if;
                O_RDY <= '0' after DELAY;
            end loop;
        end procedure;
    begin
        done_asserted := FALSE;
        o_run <= '0';
        O_RDY <= '0';
        wait until (o_start = '1');
        o_run <= '1';
        total_size      := o_total_size;
        remain_size     := o_total_size;
        block_size      := o_block_size;
        exp_o_data      := 0;
        wait_time_scale := o_wait_scale;
        wait_time_count := 0.0;
        INIT_PSEUDO_RANDOM_NUMBER_GENERATOR(
            generator => wait_time_gen,
            mat1      => mat1,
            mat2      => mat2,
            tmat      => tmat,
            seed      => TO_SEED_TYPE(o_rand_seed)
        );
        wait until (o_start = '0');
        MAIN_LOOP: loop
            wait until (O_CLK'event and O_CLK = '1');
            curr_count := to_integer(unsigned(O_COUNT));
            if (O_DONE = '1') then
                done_asserted := TRUE;
            end if;
            if (done_asserted and curr_count = 0) then
                exit;
            end if;
            if    (curr_count >= block_size) then
                PULL_DATA(block_size);
            elsif (curr_count >  0 and O_DONE = '1') then
                PULL_DATA(curr_count);
            end if;
        end loop;
        o_run <= '0';
    end process;
    -------------------------------------------------------------------------------
    -- 入力側のシナリオ
    -------------------------------------------------------------------------------
    process
        variable  wait_time_gen     : PSEUDO_RANDOM_NUMBER_GENERATOR_TYPE;
        constant  mat1              : SEED_TYPE           := X"8f7011ee";
        constant  mat2              : SEED_TYPE           := X"fc78ff1f";
        constant  tmat              : RANDOM_NUMBER_TYPE  := X"3793fdff";
        constant  seed              : integer := 1;
        variable  wait_time_scale   : real;
        variable  wait_time_count   : real;
        variable  wait_time_incr    : real;
        variable  input_data        : integer;
        procedure WAIT_I_CLK(CNT:integer) is
        begin
            if (CNT > 0) then
                for i in 1 to CNT loop 
                    wait until (I_CLK'event and I_CLK = '1'); 
                end loop;
            end if;
            wait for DELAY;
        end WAIT_I_CLK;
        procedure START(TOTAL_SIZE, BLOCK_SIZE:integer;I_SCALE,O_SCALE:real) is
        begin
            o_total_size    <= TOTAL_SIZE;
            o_block_size    <= BLOCK_SIZE;
            o_rand_seed     <= seed;
            o_wait_scale    <= O_SCALE;
            input_data      := 0;
            wait_time_scale := I_SCALE;
            wait_time_count := 0.0;
            INIT_PSEUDO_RANDOM_NUMBER_GENERATOR(
                generator => wait_time_gen,
                mat1      => mat1,
                mat2      => mat2,
                tmat      => tmat,
                seed      => TO_SEED_TYPE(seed)
            );
            wait for 0 ns;
            o_start <= '1';
            wait until (o_run = '1');
            o_start <= '0';
        end procedure;
        procedure PUSH_DATA(SIZE:integer;DONE:boolean) is
            variable  remain_size : integer;
        begin
            remain_size := SIZE;
            MAIN_LOOP: while (remain_size > 0) loop
                I_VAL  <= '0' after DELAY;
                if (wait_time_scale > 0.0) then
                    WAIT_LOOP: loop
                        if (wait_time_count <  1.0) then
                            GENERATE_RANDOM_REAL1(wait_time_gen, wait_time_incr);
                            wait_time_count := wait_time_count + wait_time_incr * wait_time_scale;
                        end if;
                        if (wait_time_count >= 1.0) then
                            wait_time_count := wait_time_count - 1.0;
                            wait until (I_CLK'event and I_CLK = '1');
                        else
                            exit;
                        end if;
                    end loop;
                end if;
                I_DATA <= std_logic_vector(to_unsigned(input_data, I_DATA'length)) after DELAY;
                I_VAL  <= '1' after DELAY;
                if (remain_size <= 1) and DONE then
                    I_DONE <= '1' after DELAY;
                else
                    I_DONE <= '0' after DELAY;
                end if;
                wait until (I_CLK'event and I_CLK = '1' and I_RDY = '1');
                I_DATA <= (others => '1') after DELAY;
                I_VAL  <= '0' after DELAY;
                I_DONE <= '0' after DELAY;
                input_data  := (input_data  + 1) mod (2**I_DATA'length);
                remain_size := remain_size - 1;
            end loop;
        end procedure;
        procedure WAIT_DONE(DONE:boolean) is
        begin
            if (DONE) then
                I_DONE <= '1' after DELAY;
                wait until (I_CLK'event and I_CLK = '1');
                I_DONE <= '0' after DELAY;
            end if;
            wait until (o_run = '0');
            wait until (I_CLK'event and I_CLK = '1');
        end procedure;
    begin
        ---------------------------------------------------------------------------
        -- シミュレーションの開始、まずはリセットから。
        ---------------------------------------------------------------------------
        assert(false) report MESSAGE_TAG & "Starting Run..." severity NOTE;
                        SCENARIO     <= "START";
                        RST          <= '1';
                        I_VAL        <= '0';
                        I_DONE       <= '0';
                        I_DATA       <= (others => '0');
                        FINISH       <= '0';
                        o_start      <= '0';
                        o_total_size <= 0;
                        o_block_size <= 0;
        WAIT_I_CLK( 4); RST          <= '0';
        ---------------------------------------------------------------------------
        -- 
        ---------------------------------------------------------------------------
        SCENARIO <= "1.1.1";
        START(TOTAL_SIZE => 2**FIFO_DEPTH,    BLOCK_SIZE => 2**FIFO_DEPTH, I_SCALE => 0.0, O_SCALE => 0.0);
        PUSH_DATA(SIZE => 2**FIFO_DEPTH, DONE=>TRUE);
        WAIT_DONE(DONE=>FALSE);
        SCENARIO <= "1.1.2";
        START(TOTAL_SIZE => 2**FIFO_DEPTH+10, BLOCK_SIZE => 2**FIFO_DEPTH, I_SCALE => 0.0, O_SCALE => 0.0);
        PUSH_DATA(SIZE => 2**FIFO_DEPTH, DONE=>FALSE);
        PUSH_DATA(SIZE => 10           , DONE=>TRUE );
        WAIT_DONE(DONE=>FALSE);
        SCENARIO <= "1.1.3";
        START(TOTAL_SIZE => 2**FIFO_DEPTH+11, BLOCK_SIZE => 2**FIFO_DEPTH, I_SCALE => 0.0, O_SCALE => 0.0);
        PUSH_DATA(SIZE => 2**FIFO_DEPTH, DONE=>FALSE);
        PUSH_DATA(SIZE => 11           , DONE=>FALSE);
        wait until (I_CLK'event and I_CLK = '1' and unsigned(to_x01(I_COUNT)) = 11);
        WAIT_DONE(DONE=>TRUE);
        SCENARIO <= "1.1.4";
        START(TOTAL_SIZE => 2**FIFO_DEPTH,    BLOCK_SIZE => 10, I_SCALE => 0.0, O_SCALE => 0.0);
        PUSH_DATA(SIZE => 2**FIFO_DEPTH, DONE=>TRUE);
        WAIT_DONE(DONE=>FALSE);
        SCENARIO <= "1.1.5";
        START(TOTAL_SIZE => 2**FIFO_DEPTH,    BLOCK_SIZE => 10, I_SCALE => 0.0, O_SCALE => 0.0);
        PUSH_DATA(SIZE => 2**FIFO_DEPTH, DONE=>FALSE);
        wait until (I_CLK'event and I_CLK = '1' and unsigned(to_x01(I_COUNT)) <= 10);
        WAIT_DONE(DONE=>TRUE);
        ---------------------------------------------------------------------------
        -- 
        ---------------------------------------------------------------------------
        SCENARIO <= "1.2.1";
        START(TOTAL_SIZE => 2**FIFO_DEPTH,    BLOCK_SIZE => 2**FIFO_DEPTH, I_SCALE => 0.0, O_SCALE => 3.0);
        PUSH_DATA(SIZE => 2**FIFO_DEPTH, DONE=>TRUE);
        WAIT_DONE(DONE=>FALSE);
        SCENARIO <= "1.2.2";
        START(TOTAL_SIZE => 2**FIFO_DEPTH+10, BLOCK_SIZE => 2**FIFO_DEPTH, I_SCALE => 0.0, O_SCALE => 2.0);
        PUSH_DATA(SIZE => 2**FIFO_DEPTH, DONE=>FALSE);
        PUSH_DATA(SIZE => 10           , DONE=>TRUE );
        WAIT_DONE(DONE=>FALSE);
        SCENARIO <= "1.2.3";
        START(TOTAL_SIZE => 2**FIFO_DEPTH+11, BLOCK_SIZE => 2**FIFO_DEPTH, I_SCALE => 0.0, O_SCALE => 1.0);
        PUSH_DATA(SIZE => 2**FIFO_DEPTH, DONE=>FALSE);
        PUSH_DATA(SIZE => 11           , DONE=>FALSE);
        wait until (I_CLK'event and I_CLK = '1' and unsigned(to_x01(I_COUNT)) = 11);
        WAIT_DONE(DONE=>TRUE);
        SCENARIO <= "1.2.4";
        START(TOTAL_SIZE => 2**FIFO_DEPTH,    BLOCK_SIZE => 10, I_SCALE => 0.0, O_SCALE => 1.2);
        PUSH_DATA(SIZE => 2**FIFO_DEPTH, DONE=>TRUE);
        WAIT_DONE(DONE=>FALSE);
        SCENARIO <= "1.2.5";
        START(TOTAL_SIZE => 2**FIFO_DEPTH,    BLOCK_SIZE => 10, I_SCALE => 0.0, O_SCALE => 2.0);
        PUSH_DATA(SIZE => 2**FIFO_DEPTH, DONE=>FALSE);
        wait until (I_CLK'event and I_CLK = '1' and unsigned(to_x01(I_COUNT)) <= 10);
        WAIT_DONE(DONE=>TRUE);
        ---------------------------------------------------------------------------
        -- 
        ---------------------------------------------------------------------------
        SCENARIO <= "1.3.1";
        START(TOTAL_SIZE => 2**FIFO_DEPTH,    BLOCK_SIZE => 2**FIFO_DEPTH, I_SCALE => 3.0, O_SCALE => 0.0);
        PUSH_DATA(SIZE => 2**FIFO_DEPTH, DONE=>TRUE);
        WAIT_DONE(DONE=>FALSE);
        SCENARIO <= "1.3.2";
        START(TOTAL_SIZE => 2**FIFO_DEPTH+10, BLOCK_SIZE => 2**FIFO_DEPTH, I_SCALE => 2.0, O_SCALE => 0.0);
        PUSH_DATA(SIZE => 2**FIFO_DEPTH, DONE=>FALSE);
        PUSH_DATA(SIZE => 10           , DONE=>TRUE );
        WAIT_DONE(DONE=>FALSE);
        SCENARIO <= "1.3.3";
        START(TOTAL_SIZE => 2**FIFO_DEPTH+11, BLOCK_SIZE => 2**FIFO_DEPTH, I_SCALE => 1.0, O_SCALE => 0.0);
        PUSH_DATA(SIZE => 2**FIFO_DEPTH, DONE=>FALSE);
        PUSH_DATA(SIZE => 11           , DONE=>FALSE);
        wait until (I_CLK'event and I_CLK = '1' and unsigned(to_x01(I_COUNT)) = 11);
        WAIT_DONE(DONE=>TRUE);
        SCENARIO <= "1.3.4";
        START(TOTAL_SIZE => 2**FIFO_DEPTH,    BLOCK_SIZE => 10, I_SCALE => 1.2, O_SCALE => 0.0);
        PUSH_DATA(SIZE => 2**FIFO_DEPTH, DONE=>TRUE);
        WAIT_DONE(DONE=>FALSE);
        SCENARIO <= "1.3.5";
        START(TOTAL_SIZE => 2**FIFO_DEPTH,    BLOCK_SIZE => 10, I_SCALE => 2.0, O_SCALE => 0.0);
        PUSH_DATA(SIZE => 2**FIFO_DEPTH, DONE=>FALSE);
        wait until (I_CLK'event and I_CLK = '1' and unsigned(to_x01(I_COUNT)) <= 10);
        WAIT_DONE(DONE=>TRUE);
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
