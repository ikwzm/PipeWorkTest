-----------------------------------------------------------------------------------
--!     @file    fifo_with_done_ctrl_sync.vhd
--!     @brief   終了処理付きFIFOの制御回路のクロック同期モジュール
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
library ieee;
use     ieee.std_logic_1164.all;
-----------------------------------------------------------------------------------
--! @brief 終了処理付きFIFOの制御回路
-----------------------------------------------------------------------------------
entity  FIFO_WITH_DONE_CTRL_SYNC is
    generic (
        SIZE_WIDTH  : --! @brief SIZE WIDTH :
                      --! I_SIZE/O_SIZEのビット幅を指定する.
                      integer := 16;
        I_CLK_RATE  : --! @brief INPUT CLOCK RATE :
                      --! O_CLK_RATEとペアで入力側のクロック(I_CLK)と出力側のクロッ
                      --! ク(O_CLK)との関係を指定する.
                      integer :=  1;
        O_CLK_RATE  : --! @brief OUTPUT CLOCK RATE :
                      --! I_CLK_RATEとペアで入力側のクロック(I_CLK)と出力側のクロッ
                      --! ク(O_CLK)との関係を指定する.
                      integer :=  1;
        DELAY_CYCLE : --! @brief DELAY CYCLE :
                      --! 入力側から出力側への転送する際の遅延サイクルを指定する.
                      integer :=  0
    );
    port (
    -------------------------------------------------------------------------------
    -- リセット信号
    -------------------------------------------------------------------------------
        RST         : --! @brief ASYNCRONOUSE RESET :
                      --! 非同期リセット信号.アクティブハイ.
                      in  std_logic;
    -------------------------------------------------------------------------------
    -- 入力側の信号
    -------------------------------------------------------------------------------
        I_CLK       : --! @brief INPUT CLOCK :
                      --! 入力側のクロック信号.
                      in  std_logic;
        I_CKE       : --! @brief INPUT CLOCK ENABLE :
                      --! 入力側のクロック(I_CLK)の立上りが有効であることを示す信号.
                      in  std_logic;
        I_DONE      : --! @brief INPUT DONE :
                      --! 入力終了信号.
                      in  std_logic;
        I_PAUSE     : --! @brief INPUT PAUSE :
                      in  std_logic;
        I_SIZE      : --! @brief INPUT SIZE :
                      --! 入力側のカウンタ.
                      in  std_logic_vector(SIZE_WIDTH-1 downto 0);
        I_VAL       : --! @brief INPUT VALID :
                      --! 入力有効信号.
                      in  std_logic;
    -------------------------------------------------------------------------------
    -- 出力側の信号
    -------------------------------------------------------------------------------
        O_CLK       : --! @brief OUTPUT CLK :
                      --! 出力側のクロック信号.
                      in  std_logic;
        O_CKE       : --! @brief OUTPUT CLOCK ENABLE :
                      --! 出力側のクロック(O_CLK)の立上りが有効であることを示す信号.
                      in  std_logic;
        O_DONE      : --! @brief OUTPUT DONE :
                      out std_logic;
        O_VAL       : --! @brief OUTPUT VALID :
                      out std_logic;
        O_SIZE      : --! @brief OUTPUT SIZE :
                      --! 出力側のカウンタ.
                      out std_logic_vector(SIZE_WIDTH-1 downto 0)
    );
end FIFO_WITH_DONE_CTRL_SYNC;
-----------------------------------------------------------------------------------
-- 
-----------------------------------------------------------------------------------
library ieee;
use     ieee.std_logic_1164.all;
library PIPEWORK;
use     PIPEWORK.COMPONENTS.SYNCRONIZER;
use     PIPEWORK.COMPONENTS.SYNCRONIZER_INPUT_PENDING_REGISTER;
use     PIPEWORK.COMPONENTS.DELAY_ADJUSTER;
use     PIPEWORK.COMPONENTS.DELAY_REGISTER;
architecture RTL of FIFO_WITH_DONE_CTRL_SYNC is
    constant  i_clear    : std_logic := '0';
    constant  o_clear    : std_logic := '0';
    signal    i_data     : std_logic_vector(SIZE_WIDTH   downto 0);
    signal    i_valid    : std_logic_vector(1 downto 0);
    signal    i_ready    : std_logic;
    signal    o_data     : std_logic_vector(SIZE_WIDTH   downto 0);
    signal    o_valid    : std_logic_vector(1 downto 0);
    signal    o_done_val : std_logic_vector(1 downto 0);
    constant  delay_sel  : std_logic_vector(DELAY_CYCLE  downto DELAY_CYCLE) := (others => '1');
    signal    delay_val  : std_logic_vector(DELAY_CYCLE  downto 0);
begin
    PEND_SIZE: SYNCRONIZER_INPUT_PENDING_REGISTER
        generic map (
            DATA_BITS   => SIZE_WIDTH       , -- 
            OPERATION   => 2                  -- 
        )
        port map (
            CLK         => I_CLK            , -- In  :
            RST         => RST              , -- In  :
            CLR         => i_clear          , -- In  :
            I_DATA      => I_SIZE           , -- In  :
            I_VAL       => I_VAL            , -- In  :
            I_PAUSE     => I_PAUSE          , -- In  :
            P_DATA      => open             , -- Out :
            P_VAL       => open             , -- Out :
            O_DATA      => i_data(SIZE_WIDTH-1 downto 0),  -- Out :
            O_VAL       => i_valid(0)       , -- Out :
            O_RDY       => i_ready            -- In  :
        );
    PEND_DONE: SYNCRONIZER_INPUT_PENDING_REGISTER
        generic map (
            DATA_BITS   => 1,                 -- 
            OPERATION   => 1                  -- 
        )
        port map (
            CLK         => I_CLK            , -- In  :
            RST         => RST              , -- In  :
            CLR         => i_clear          , -- In  :
            I_DATA(0)   => I_DONE           , -- In  :
            I_VAL       => I_DONE           , -- In  :
            I_PAUSE     => I_PAUSE          , -- In  :
            P_DATA      => open             , -- Out :
            P_VAL       => open             , -- Out :
            O_DATA      => i_data(SIZE_WIDTH downto SIZE_WIDTH),  -- Out :
            O_VAL       => i_valid(1)       , -- Out :
            O_RDY       => i_ready            -- In  :
        );
    SYNC: SYNCRONIZER 
        generic map (
            DATA_BITS   => i_data'length    , -- 
            VAL_BITS    => i_valid'length   , --
            I_CLK_RATE  => I_CLK_RATE       , --
            O_CLK_RATE  => O_CLK_RATE       , --
            I_CLK_FLOP  => 1,                 --
            O_CLK_FLOP  => 1,                 --
            I_CLK_FALL  => 0,                 --
            O_CLK_FALL  => 0,                 --
            O_CLK_REGS  => 0                  --
        )
        port map (
            RST         => RST              , -- In  :
            I_CLK       => I_CLK            , -- In  :
            I_CLR       => i_clear          , -- In  :
            I_CKE       => I_CKE            , -- In  :
            I_DATA      => i_data           , -- In  :
            I_VAL       => i_valid          , -- In  :
            I_RDY       => i_ready          , -- Out :
            O_CLK       => O_CLK            , -- In  :
            O_CLR       => o_clear          , -- In  :
            O_CKE       => O_CKE            , -- In  :
            O_DATA      => o_data           , -- Out :
            O_VAL       => o_valid            -- Out :
        );
    DELAYED_SIZE: DELAY_REGISTER 
        generic map (
            DATA_BITS   => SIZE_WIDTH       , -- 
            DELAY_MAX   => DELAY_CYCLE      , -- 
            DELAY_MIN   => DELAY_CYCLE        --
        ) 
        port map (
            CLK         => O_CLK            , -- In  :
            RST         => RST              , -- In  :
            CLR         => o_clear          , -- In  :
            SEL         => delay_sel        , -- In  :
            D_VAL       => delay_val        , -- Out :
            I_DATA      => o_data(SIZE_WIDTH-1 downto 0),
            I_VAL       => o_valid(0)       , -- In  :
            O_DATA      => O_SIZE           , -- Out :
            O_VAL       => O_VAL              -- Out :
        );
    DELAYED_DONE: DELAY_ADJUSTER
        generic map (
            DATA_BITS   => 1                , -- 
            DELAY_MAX   => DELAY_CYCLE      , -- 
            DELAY_MIN   => DELAY_CYCLE        -- 
        ) 
        port map (
            CLK         => O_CLK            , -- In  :
            RST         => RST              , -- In  :
            CLR         => o_clear          , -- In  :
            SEL         => delay_sel        , -- In  :
            D_VAL       => delay_val        , -- In  :
            I_DATA      => o_data(SIZE_WIDTH downto SIZE_WIDTH),
            I_VAL       => o_valid(1)       , -- In  :
            O_DATA(0)   => o_done_val(0)    , -- Out :
            O_VAL       => o_done_val(1)      -- Out :
        );
    O_DONE <= '1' when (o_done_val = "11") else '0';
end RTL;
