-----------------------------------------------------------------------------------
--!     @file    justifier_test_bench.vhd
--!     @brief   Justifier Module Test Bench
--!     @version 2.0.0
--!     @date    2023/12/22
--!     @author  Ichiro Kawazome <ichiro_k@ca2.so-net.ne.jp>
-----------------------------------------------------------------------------------
--
--      Copyright (C) 2023 Ichiro Kawazome
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
library ieee;
use     ieee.std_logic_1164.all;
entity  JUSTIFIER_TEST_BENCH is
    generic (
        NAME            :  STRING  := "test";
        SCENARIO_FILE   :  STRING  := "test.snr";
        DATA_BITS       :  integer := 32;
        DVAL_BITS       :  integer :=  0;
        INFO_BITS       :  integer :=  4;
        PIPELINE        :  integer :=  0;
        I_JUSTIFIED     :  integer :=  0;
        FINISH_ABORT    :  boolean := FALSE
    );
end     JUSTIFIER_TEST_BENCH;
-----------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------
library ieee;
use     ieee.std_logic_1164.all;
use     ieee.numeric_std.all;
use     std.textio.all;
library PIPEWORK;
use     PIPEWORK.COMPONENTS.JUSTIFIER;
library DUMMY_PLUG;
use     DUMMY_PLUG.AXI4_TYPES.all;
use     DUMMY_PLUG.AXI4_MODELS.AXI4_STREAM_MASTER_PLAYER;
use     DUMMY_PLUG.AXI4_MODELS.AXI4_STREAM_SLAVE_PLAYER;
use     DUMMY_PLUG.AXI4_MODELS.AXI4_SIGNAL_PRINTER;
use     DUMMY_PLUG.SYNC.all;
use     DUMMY_PLUG.CORE.MARCHAL;
use     DUMMY_PLUG.CORE.REPORT_STATUS_TYPE;
use     DUMMY_PLUG.CORE.REPORT_STATUS_VECTOR;
use     DUMMY_PLUG.CORE.MARGE_REPORT_STATUS;
architecture MODEL of JUSTIFIER_TEST_BENCH is
    -------------------------------------------------------------------------------
    -- 各種定数
    -------------------------------------------------------------------------------
    type        PARAM_TYPE      is record
                WORDS           :  integer;
                WORD_BITS       :  integer;
                STRB_BITS       :  integer;
                USER_BITS       :  integer;
                ID_BITS         :  integer;
                INFO_BITS       :  integer;
                DVAL_ENABLE     :  integer;
    end record;
    function    NEW_PARAM  return  PARAM_TYPE is
        variable  param         :  PARAM_TYPE;
    begin
        if (DVAL_BITS > 0) then
            param.WORDS       := DVAL_BITS;
            param.WORD_BITS   := (DATA_BITS  )/param.WORDS;
            param.STRB_BITS   := (DATA_BITS/8)/param.WORDS;
            param.USER_BITS   := DVAL_BITS;
            param.DVAL_ENABLE := 1;
        else
            param.WORD_BITS   := 8;
            param.STRB_BITS   := 1;
            param.WORDS       := DATA_BITS/param.WORD_BITS;
            param.USER_BITS   := param.WORDS;
            param.DVAL_ENABLE := 0;
        end if;
        param.ID_BITS     := INFO_BITS;
        param.INFO_BITS   := param.ID_BITS+1;
        return param;
    end function;
    constant    PARAM           :  PARAM_TYPE := NEW_PARAM;
    constant    PERIOD          :  time    := 10 ns;
    constant    DELAY           :  time    :=  1 ns;
    constant    I_WIDTH         :  AXI4_STREAM_SIGNAL_WIDTH_TYPE := (
                                      ID         => PARAM.ID_BITS,
                                      USER       => PARAM.USER_BITS,
                                      DEST       => 4,
                                      DATA       => DATA_BITS
                                   );
    constant    O_WIDTH         :  AXI4_STREAM_SIGNAL_WIDTH_TYPE := (
                                      ID         => PARAM.ID_BITS,
                                      USER       => PARAM.USER_BITS,
                                      DEST       => 4,
                                      DATA       => DATA_BITS
                                   );
    constant   SYNC_WIDTH       :  integer :=  2;
    constant   GPO_WIDTH        :  integer :=  1;
    constant   GPI_WIDTH        :  integer :=  GPO_WIDTH;
    -------------------------------------------------------------------------------
    -- グローバルシグナル.
    -------------------------------------------------------------------------------
    signal    ARESETn           :  std_logic;
    signal    RESET             :  std_logic;
    constant  CLEAR             :  std_logic := '0';
    signal    CLK               :  std_logic;
    signal    I_ENABLE          :  std_logic;
    signal    BUSY              :  std_logic;
    -------------------------------------------------------------------------------
    -- 
    -------------------------------------------------------------------------------
    signal    I_DATA            :  std_logic_vector(PARAM.WORDS*PARAM.WORD_BITS-1 downto 0);
    signal    I_STRB            :  std_logic_vector(PARAM.WORDS*PARAM.STRB_BITS-1 downto 0);
    signal    I_DVAL            :  std_logic_vector(PARAM.WORDS                -1 downto 0);
    signal    I_USER            :  std_logic_vector(PARAM.USER_BITS            -1 downto 0);
    signal    I_ID              :  std_logic_vector(PARAM.ID_BITS              -1 downto 0);
    signal    I_LAST            :  std_logic;
    signal    I_VAL             :  std_logic;
    signal    I_RDY             :  std_logic;
    signal    I_INFO            :  std_logic_vector(PARAM.INFO_BITS            -1 downto 0);
    -------------------------------------------------------------------------------
    -- 
    -------------------------------------------------------------------------------
    signal    O_DATA            :  std_logic_vector(PARAM.WORDS*PARAM.WORD_BITS-1 downto 0);
    signal    O_STRB            :  std_logic_vector(PARAM.WORDS*PARAM.STRB_BITS-1 downto 0);
    signal    O_DVAL            :  std_logic_vector(PARAM.WORDS                -1 downto 0);
    signal    O_USER            :  std_logic_vector(PARAM.USER_BITS            -1 downto 0);
    signal    O_ID              :  std_logic_vector(PARAM.ID_BITS              -1 downto 0);
    signal    O_LAST            :  std_logic;
    signal    O_VAL             :  std_logic;
    signal    O_RDY             :  std_logic;
    signal    O_INFO            :  std_logic_vector(PARAM.INFO_BITS            -1 downto 0);
    constant  O_KEEP            :  std_logic_vector(PARAM.WORDS*PARAM.STRB_BITS-1 downto 0) := (others => '1');
    constant  O_DEST            :  std_logic_vector(O_WIDTH.DEST               -1 downto 0) := (others => '0');
    -------------------------------------------------------------------------------
    -- シンクロ用信号
    -------------------------------------------------------------------------------
    signal    SYNC              :  SYNC_SIG_VECTOR (SYNC_WIDTH   -1 downto 0);
    -------------------------------------------------------------------------------
    -- GPIO(General Purpose Input/Output)
    -------------------------------------------------------------------------------
    signal    I_GPI             :  std_logic_vector(GPI_WIDTH    -1 downto 0);
    signal    I_GPO             :  std_logic_vector(GPO_WIDTH    -1 downto 0);
    signal    O_GPI             :  std_logic_vector(GPI_WIDTH    -1 downto 0);
    signal    O_GPO             :  std_logic_vector(GPO_WIDTH    -1 downto 0);
    -------------------------------------------------------------------------------
    -- 各種状態出力.
    -------------------------------------------------------------------------------
    signal    N_REPORT          :  REPORT_STATUS_TYPE;
    signal    I_REPORT          :  REPORT_STATUS_TYPE;
    signal    O_REPORT          :  REPORT_STATUS_TYPE;
    signal    N_FINISH          :  std_logic;
    signal    I_FINISH          :  std_logic;
    signal    O_FINISH          :  std_logic;
begin
    -------------------------------------------------------------------------------
    -- 
    -------------------------------------------------------------------------------
    DUT: JUSTIFIER 
        generic map (
            WORD_BITS       => PARAM.WORD_BITS   ,
            STRB_BITS       => PARAM.STRB_BITS   ,
            INFO_BITS       => PARAM.INFO_BITS   ,
            WORDS           => PARAM.WORDS       ,
            I_JUSTIFIED     => I_JUSTIFIED       ,
            I_DVAL_ENABLE   => PARAM.DVAL_ENABLE ,
            PIPELINE        => PIPELINE 
        )
        port map (
            CLK             => CLK               ,  -- In  :
            RST             => RESET             ,  -- In  :
            CLR             => CLEAR             ,  -- In  :
            I_ENABLE        => I_ENABLE          ,  -- In  :
            I_DATA          => I_DATA            ,  -- In  :
            I_STRB          => I_STRB            ,  -- In  :
            I_DVAL          => I_DVAL            ,  -- In  :
            I_INFO          => I_INFO            ,  -- In  :
            I_VAL           => I_VAL             ,  -- In  :
            I_RDY           => I_RDY             ,  -- Out :
            O_DATA          => O_DATA            ,  -- Out :
            O_STRB          => O_STRB            ,  -- Out :
            O_DVAL          => O_DVAL            ,  -- Out :
            O_INFO          => O_INFO            ,  -- Out :
            O_VAL           => O_VAL             ,  -- Out :
            O_RDY           => O_RDY             ,  -- In  :
            BUSY            => BUSY                 -- Out :
        );
    I_DVAL    <= I_USER;
    I_INFO(0) <= I_LAST;
    I_INFO(I_INFO'high downto 1) <= I_ID;
    O_USER    <= O_DVAL; 
    O_LAST    <= O_INFO(0);
    O_ID      <= O_INFO(O_INFO'high downto 1);
    -------------------------------------------------------------------------------
    -- 
    -------------------------------------------------------------------------------
    N: MARCHAL
        generic map(
            SCENARIO_FILE   => SCENARIO_FILE,
            NAME            => "MARCHAL",
            SYNC_PLUG_NUM   => 1,
            SYNC_WIDTH      => SYNC_WIDTH,
            FINISH_ABORT    => FALSE
        )
        port map(
            CLK             => CLK             , -- In  :
            RESET           => RESET           , -- In  :
            SYNC(0)         => SYNC(0)         , -- I/O :
            SYNC(1)         => SYNC(1)         , -- I/O :
            REPORT_STATUS   => N_REPORT        , -- Out :
            FINISH          => N_FINISH          -- Out :
        );
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    I: AXI4_STREAM_MASTER_PLAYER                 -- 
        generic map (                            -- 
            SCENARIO_FILE   => SCENARIO_FILE   , --
            NAME            => "I"             , --
            OUTPUT_DELAY    => DELAY           , --
            SYNC_PLUG_NUM   => 2               , --
            WIDTH           => I_WIDTH         , --
            SYNC_WIDTH      => SYNC_WIDTH      , --
            GPI_WIDTH       => GPI_WIDTH       , --
            GPO_WIDTH       => GPO_WIDTH       , --
            FINISH_ABORT    => FALSE             --
        )                                        -- 
        port map(                                -- 
            ACLK            => CLK             , -- In  :
            ARESETn         => ARESETn         , -- In  :
            TDATA           => I_DATA          , -- I/O :
            TSTRB           => I_STRB          , -- I/O :
            TUSER           => I_USER          , -- I/O :
            TID             => I_ID            , -- I/O :
            TLAST           => I_LAST          , -- I/O :
            TVALID          => I_VAL           , -- I/O :
            TREADY          => I_RDY           , -- In  :
            SYNC            => SYNC            , -- I/O :
            GPI             => I_GPI           , -- In  :
            GPO             => I_GPO           , -- Out :
            REPORT_STATUS   => I_REPORT        , -- Out :
            FINISH          => I_FINISH          -- Out :
        );                                       --
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    O: AXI4_STREAM_SLAVE_PLAYER                  -- 
        generic map (                            -- 
            SCENARIO_FILE   => SCENARIO_FILE   , --
            NAME            => "O"             , --
            OUTPUT_DELAY    => DELAY           , --
            SYNC_PLUG_NUM   => 3               , --
            WIDTH           => O_WIDTH         , --
            SYNC_WIDTH      => SYNC_WIDTH      , --
            GPI_WIDTH       => GPI_WIDTH       , --
            GPO_WIDTH       => GPO_WIDTH       , --
            FINISH_ABORT    => FALSE             --
        )                                        -- 
        port map(                                -- 
            ACLK            => CLK             , -- In  :
            ARESETn         => ARESETn         , -- In  :
            TDATA           => O_DATA          , -- In  :
            TSTRB           => O_STRB          , -- In  :
            TKEEP           => O_KEEP          , -- In  :
            TUSER           => O_USER          , -- In  :
            TDEST           => O_DEST          , -- In  :
            TID             => O_ID            , -- In  :
            TLAST           => O_LAST          , -- In  :
            TVALID          => O_VAL           , -- In  :
            TREADY          => O_RDY           , -- Out :
            SYNC(0)         => SYNC(0)         , -- I/O :
            SYNC(1)         => SYNC(1)         , -- I/O :
            GPI             => O_GPI           , -- In  :
            GPO             => O_GPO           , -- Out :
            REPORT_STATUS   => O_REPORT        , -- Out :
            FINISH          => O_FINISH          -- Out :
        );                                       --
    -------------------------------------------------------------------------------
    -- 
    -------------------------------------------------------------------------------
    process begin
        loop
            CLK <= '0'; wait for PERIOD / 2;
            CLK <= '1'; wait for PERIOD / 2;
            exit when(N_FINISH = '1');
        end loop;
        CLK <= '0';
        wait;
    end process;
    -------------------------------------------------------------------------------
    -- 
    -------------------------------------------------------------------------------
    ARESETn  <= '1' when (RESET = '0') else '0';
    I_ENABLE <= '1' when (I_GPO(0) = '1') else '0';
    I_GPI(0) <= BUSY;
    O_GPI(0) <= BUSY;
    process
        variable L   : LINE;
        constant T   : STRING(1 to 7) := "  ***  ";
    begin
        wait until (N_FINISH'event and N_FINISH = '1');
        wait for DELAY;
        WRITE(L,T);                                                   WRITELINE(OUTPUT,L);
        WRITE(L,T & "ERROR REPORT " & NAME);                          WRITELINE(OUTPUT,L);
        WRITE(L,T & "[ IN ]");                                        WRITELINE(OUTPUT,L);
        WRITE(L,T & "  Error    : ");WRITE(L,I_REPORT.error_count   );WRITELINE(OUTPUT,L);
        WRITE(L,T & "  Mismatch : ");WRITE(L,I_REPORT.mismatch_count);WRITELINE(OUTPUT,L);
        WRITE(L,T & "  Warning  : ");WRITE(L,I_REPORT.warning_count );WRITELINE(OUTPUT,L);
        WRITE(L,T);                                                   WRITELINE(OUTPUT,L);
        WRITE(L,T & "[ OUT ]");                                       WRITELINE(OUTPUT,L);
        WRITE(L,T & "  Error    : ");WRITE(L,O_REPORT.error_count   );WRITELINE(OUTPUT,L);
        WRITE(L,T & "  Mismatch : ");WRITE(L,O_REPORT.mismatch_count);WRITELINE(OUTPUT,L);
        WRITE(L,T & "  Warning  : ");WRITE(L,O_REPORT.warning_count );WRITELINE(OUTPUT,L);
        WRITE(L,T);                                                   WRITELINE(OUTPUT,L);
        assert (I_REPORT.error_count    = 0 and
                O_REPORT.error_count    = 0)
            report "Simulation complete(error)."    severity FAILURE;
        assert (I_REPORT.mismatch_count = 0 and
                O_REPORT.mismatch_count = 0)
            report "Simulation complete(mismatch)." severity FAILURE;
        if (FINISH_ABORT) then
            assert FALSE report "Simulation complete(success)."  severity FAILURE;
        else
            assert FALSE report "Simulation complete(success)."  severity NOTE;
        end if;
        wait;
    end process;
end MODEL;
-----------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------
library ieee;
use     ieee.std_logic_1164.all;
entity  JUSTIFIER_TEST_BENCH_64_0_0 is
    generic (
        NAME            : STRING  := "JUSTIFIER_TEST_BENCH_64_0_0";
        SCENARIO_FILE   : STRING  := "justifier_test_bench_64_0.snr";
        FINISH_ABORT    : boolean := FALSE
    );
end     JUSTIFIER_TEST_BENCH_64_0_0;
architecture MODEL of JUSTIFIER_TEST_BENCH_64_0_0 is
begin
    TB: entity work.JUSTIFIER_TEST_BENCH
        generic map (
            NAME            => NAME            , -- 
            SCENARIO_FILE   => SCENARIO_FILE   , --   
            DATA_BITS       => 64              , --   
            DVAL_BITS       => 0               , --   
            PIPELINE        => 0               , --   
            FINISH_ABORT    => FINISH_ABORT      --   
        );
end MODEL;
-----------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------
library ieee;
use     ieee.std_logic_1164.all;
entity  JUSTIFIER_TEST_BENCH_64_0_1 is
    generic (
        NAME            : STRING  := "JUSTIFIER_TEST_BENCH_64_0_1";
        SCENARIO_FILE   : STRING  := "justifier_test_bench_64_0.snr";
        FINISH_ABORT    : boolean := FALSE
    );
end     JUSTIFIER_TEST_BENCH_64_0_1;
architecture MODEL of JUSTIFIER_TEST_BENCH_64_0_1 is
begin
    TB: entity work.JUSTIFIER_TEST_BENCH
        generic map (
            NAME            => NAME            , -- 
            SCENARIO_FILE   => SCENARIO_FILE   , --   
            DATA_BITS       => 64              , --   
            DVAL_BITS       => 0               , --   
            PIPELINE        => 1               , --   
            FINISH_ABORT    => FINISH_ABORT      --   
        );
end MODEL;
-----------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------
library ieee;
use     ieee.std_logic_1164.all;
entity  JUSTIFIER_TEST_BENCH_64_0_2 is
    generic (
        NAME            : STRING  := "JUSTIFIER_TEST_BENCH_64_0_2";
        SCENARIO_FILE   : STRING  := "justifier_test_bench_64_0.snr";
        FINISH_ABORT    : boolean := FALSE
    );
end     JUSTIFIER_TEST_BENCH_64_0_2;
architecture MODEL of JUSTIFIER_TEST_BENCH_64_0_2 is
begin
    TB: entity work.JUSTIFIER_TEST_BENCH
        generic map (
            NAME            => NAME            , -- 
            SCENARIO_FILE   => SCENARIO_FILE   , --   
            DATA_BITS       => 64              , --   
            DVAL_BITS       => 0               , --   
            PIPELINE        => 2               , --   
            FINISH_ABORT    => FINISH_ABORT      --   
        );
end MODEL;
-----------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------
library ieee;
use     ieee.std_logic_1164.all;
entity  JUSTIFIER_TEST_BENCH_64_0_3 is
    generic (
        NAME            : STRING  := "JUSTIFIER_TEST_BENCH_64_0_3";
        SCENARIO_FILE   : STRING  := "justifier_test_bench_64_0.snr";
        FINISH_ABORT    : boolean := FALSE
    );
end     JUSTIFIER_TEST_BENCH_64_0_3;
architecture MODEL of JUSTIFIER_TEST_BENCH_64_0_3 is
begin
    TB: entity work.JUSTIFIER_TEST_BENCH
        generic map (
            NAME            => NAME            , -- 
            SCENARIO_FILE   => SCENARIO_FILE   , --   
            DATA_BITS       => 64              , --   
            DVAL_BITS       => 0               , --   
            PIPELINE        => 3               , --   
            FINISH_ABORT    => FINISH_ABORT      --   
        );
end MODEL;
-----------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------
library ieee;
use     ieee.std_logic_1164.all;
entity  JUSTIFIER_TEST_BENCH_64_4_0 is
    generic (
        NAME            : STRING  := "JUSTIFIER_TEST_BENCH_64_4_0";
        SCENARIO_FILE   : STRING  := "justifier_test_bench_64_4.snr";
        FINISH_ABORT    : boolean := FALSE
    );
end     JUSTIFIER_TEST_BENCH_64_4_0;
architecture MODEL of JUSTIFIER_TEST_BENCH_64_4_0 is
begin
    TB: entity work.JUSTIFIER_TEST_BENCH
        generic map (
            NAME            => NAME            , -- 
            SCENARIO_FILE   => SCENARIO_FILE   , --   
            DATA_BITS       => 64              , --   
            DVAL_BITS       => 4               , --   
            PIPELINE        => 0               , --   
            FINISH_ABORT    => FINISH_ABORT      --   
        );
end MODEL;
-----------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------
library ieee;
use     ieee.std_logic_1164.all;
entity  JUSTIFIER_TEST_BENCH_64_4_1 is
    generic (
        NAME            : STRING  := "JUSTIFIER_TEST_BENCH_64_4_1";
        SCENARIO_FILE   : STRING  := "justifier_test_bench_64_4.snr";
        FINISH_ABORT    : boolean := FALSE
    );
end     JUSTIFIER_TEST_BENCH_64_4_1;
architecture MODEL of JUSTIFIER_TEST_BENCH_64_4_1 is
begin
    TB: entity work.JUSTIFIER_TEST_BENCH
        generic map (
            NAME            => NAME            , -- 
            SCENARIO_FILE   => SCENARIO_FILE   , --   
            DATA_BITS       => 64              , --   
            DVAL_BITS       => 4               , --   
            PIPELINE        => 1               , --   
            FINISH_ABORT    => FINISH_ABORT      --   
        );
end MODEL;
-----------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------
library ieee;
use     ieee.std_logic_1164.all;
entity  JUSTIFIER_TEST_BENCH_64_4_2 is
    generic (
        NAME            : STRING  := "JUSTIFIER_TEST_BENCH_64_4_2";
        SCENARIO_FILE   : STRING  := "justifier_test_bench_64_4.snr";
        FINISH_ABORT    : boolean := FALSE
    );
end     JUSTIFIER_TEST_BENCH_64_4_2;
architecture MODEL of JUSTIFIER_TEST_BENCH_64_4_2 is
begin
    TB: entity work.JUSTIFIER_TEST_BENCH
        generic map (
            NAME            => NAME            , -- 
            SCENARIO_FILE   => SCENARIO_FILE   , --   
            DATA_BITS       => 64              , --   
            DVAL_BITS       => 4               , --   
            PIPELINE        => 2               , --   
            FINISH_ABORT    => FINISH_ABORT      --   
        );
end MODEL;
-----------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------
library ieee;
use     ieee.std_logic_1164.all;
entity  JUSTIFIER_TEST_BENCH_64_4_3 is
    generic (
        NAME            : STRING  := "JUSTIFIER_TEST_BENCH_64_4_3";
        SCENARIO_FILE   : STRING  := "justifier_test_bench_64_4.snr";
        FINISH_ABORT    : boolean := FALSE
    );
end     JUSTIFIER_TEST_BENCH_64_4_3;
architecture MODEL of JUSTIFIER_TEST_BENCH_64_4_3 is
begin
    TB: entity work.JUSTIFIER_TEST_BENCH
        generic map (
            NAME            => NAME            , -- 
            SCENARIO_FILE   => SCENARIO_FILE   , --   
            DATA_BITS       => 64              , --   
            DVAL_BITS       => 4               , --   
            PIPELINE        => 3               , --   
            FINISH_ABORT    => FINISH_ABORT      --   
        );
end MODEL;
