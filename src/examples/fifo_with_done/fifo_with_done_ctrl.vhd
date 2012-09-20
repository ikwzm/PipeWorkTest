-----------------------------------------------------------------------------------
--!     @file    fifo_with_done_ctrl.vhd
--!     @brief   終了処理付きFIFOの制御回路
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
entity  FIFO_WITH_DONE_CTRL is
    generic (
        FIFO_DEPTH  : --! @brief FIFO DEPTH :
                      --! FIFOの深さを２のべき乗値で指定する.
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
    -- 
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
        I_VAL       : --! @brief INPUT ENABLE :
                      --! 入力有効信号.
                      in  std_logic;
        I_RDY       : --! @brief INPUT READY :
                      --! 入力許可信号.
                      out std_logic;
        I_COUNT     : --! @brief INPUT COUNTER :
                      --! 入力側のデータ書き込みサイズ.
                      out std_logic_vector(FIFO_DEPTH   downto 0);
    -------------------------------------------------------------------------------
    -- 出力側の信号
    -------------------------------------------------------------------------------
        O_CLK       : --! @brief OUTPUT CLK :
                      --! 出力側のクロック信号.
                      in  std_logic;
        O_CKE       : --! @brief OUTPUT CLOCK ENABLE :
                      --! 出力側のクロック(O_CLK)の立上りが有効であることを示す信号.
                      in  std_logic;
        O_RDY       : --! @brief OUTPUT ENABLE :
                      in  std_logic;
        O_VAL       : --! @brief OUTPUT VALID :
                      out std_logic;
        O_DONE      : --! @brief OUTPUT DONE :
                      out std_logic;
        O_COUNT     : --! @brief OUTPUT COUNTER :
                      --! 出力側のカウンタ.
                      out std_logic_vector(FIFO_DEPTH   downto 0);
    -------------------------------------------------------------------------------
    -- バッファ制御信号
    -------------------------------------------------------------------------------
        W_ENA       : --! @brief BUFFER WRITE ENABLE :
                      --! 入力側のデータ書き込み信号.
                      out std_logic;
        W_PTR       : --! @brief BUFFER WRITE POINTER :
                      --! 入力側のデータ書き込みポインタ.
                      out std_logic_vector(FIFO_DEPTH-1 downto 0);
        R_PTR       : --! @brief BUFFER READ POINTER :
                      --! 出力側の読み出しポインタ.
                      out std_logic_vector(FIFO_DEPTH-1 downto 0)
    );
end FIFO_WITH_DONE_CTRL;
-----------------------------------------------------------------------------------
-- 
-----------------------------------------------------------------------------------
library ieee;
use     ieee.std_logic_1164.all;
use     ieee.numeric_std.all;
architecture RTL of FIFO_WITH_DONE_CTRL is
    constant  in_size   : std_logic_vector(FIFO_DEPTH downto 0) := (0 => '1', others => '0');
    signal    in_ready  : boolean;
    constant  req_pause : std_logic := '0';
    signal    req_valid : std_logic;
    signal    req_done  : std_logic;
    constant  out_size  : std_logic_vector(FIFO_DEPTH downto 0) := (0 => '1', others => '0');
    signal    out_valid : boolean;
    signal    out_done  : boolean;
    constant  ret_pause : std_logic := '0';
    signal    ret_valid : std_logic;
    signal    ret_done  : std_logic;
    signal    i2o_size  : std_logic_vector(FIFO_DEPTH downto 0);
    signal    i2o_done  : std_logic;
    signal    i2o_valid : std_logic;
    signal    o2i_size  : std_logic_vector(FIFO_DEPTH downto 0);
    signal    o2i_done  : std_logic;
    signal    o2i_valid : std_logic;
    component FIFO_WITH_DONE_CTRL_SYNC is
        generic (
            SIZE_WIDTH  : integer := 16;
            I_CLK_RATE  : integer :=  1;
            O_CLK_RATE  : integer :=  1;
            DELAY_CYCLE : integer :=  0
        );
        port (
            RST         : in  std_logic;
            I_CLK       : in  std_logic;
            I_CKE       : in  std_logic;
            I_DONE      : in  std_logic;
            I_PAUSE     : in  std_logic;
            I_SIZE      : in  std_logic_vector(SIZE_WIDTH-1 downto 0);
            I_VAL       : in  std_logic;
            O_CLK       : in  std_logic;
            O_CKE       : in  std_logic;
            O_DONE      : out std_logic;
            O_VAL       : out std_logic;
            O_SIZE      : out std_logic_vector(SIZE_WIDTH-1 downto 0)
        );
    end component;
begin
    -------------------------------------------------------------------------------
    -- 入力側のブロック
    -------------------------------------------------------------------------------
    I_BLK: block
        signal    curr_pointer  : unsigned(FIFO_DEPTH-1 downto 0);
        signal    curr_counter  : unsigned(FIFO_DEPTH   downto 0);
        signal    wait_done     : boolean;
    begin
        req_done  <= '1' when (in_ready and I_DONE = '1') else '0';
        req_valid <= '1' when (in_ready and I_VAL  = '1') else '0';
        W_ENA     <= '1' when (in_ready and I_VAL  = '1') else '0';
        W_PTR     <= std_logic_vector(curr_pointer);
        I_COUNT   <= std_logic_vector(curr_counter);
        I_RDY     <= '1' when (in_ready) else '0';
        process (I_CLK, RST)
            variable  next_pointer : unsigned(FIFO_DEPTH downto 0);
            variable  next_counter : unsigned(FIFO_DEPTH downto 0);
        begin
            if (RST = '1') then
                curr_pointer <= (others => '0');
                curr_counter <= (others => '0');
                in_ready     <= FALSE;
                wait_done    <= FALSE;
            elsif (I_CLK'event and I_CLK = '1') then
                next_pointer := "0" & curr_pointer;
                next_counter := curr_counter;
                if (req_valid = '1') then
                    next_counter := next_counter + unsigned(in_size);
                    next_pointer := next_pointer + unsigned(in_size);
                end if;
                if (o2i_valid = '1') then
                    next_counter := next_counter - unsigned(o2i_size);
                end if;
                if (o2i_done  = '1') then
                    next_pointer := (others => '0');
                    next_counter := (others => '0');
                end if;
                curr_pointer <= next_pointer(curr_pointer'range);
                curr_counter <= next_counter;
                if (o2i_done = '1') then
                    wait_done <= FALSE;
                    in_ready  <= TRUE;
                elsif (wait_done or req_done = '1') then
                    wait_done <= TRUE;
                    in_ready  <= FALSE;
                else
                    wait_done <= FALSE;
                    in_ready  <= (next_counter(next_counter'high) = '0');
                end if;
            end if;
        end process;
    end block;
    -------------------------------------------------------------------------------
    -- 入力側から出力側への情報転送
    -------------------------------------------------------------------------------
    I2O_SYNC: FIFO_WITH_DONE_CTRL_SYNC
        generic map (
            SIZE_WIDTH  => FIFO_DEPTH+1     , -- 
            I_CLK_RATE  => I_CLK_RATE       , -- 
            O_CLK_RATE  => O_CLK_RATE       , -- 
            DELAY_CYCLE => DELAY_CYCLE        --
        )
        port map (
            RST         => RST              , -- In  :
            I_CLK       => I_CLK            , -- In  :
            I_CKE       => I_CKE            , -- In  :
            I_DONE      => req_done         , -- In  :
            I_PAUSE     => req_pause        , -- In  :
            I_SIZE      => in_size          , -- In  :
            I_VAL       => req_valid        , -- In  :
            O_CLK       => O_CLK            , -- In  :
            O_CKE       => O_CKE            , -- In  :
            O_DONE      => i2o_done         , -- Out :
            O_VAL       => i2o_valid        , -- Out :
            O_SIZE      => i2o_size           -- Out :
        );
    -------------------------------------------------------------------------------
    -- 出力側から入力側への情報転送
    -------------------------------------------------------------------------------
    O2I_SYNC: FIFO_WITH_DONE_CTRL_SYNC
        generic map (
            SIZE_WIDTH  => FIFO_DEPTH+1     , -- 
            I_CLK_RATE  => O_CLK_RATE       , -- 
            O_CLK_RATE  => I_CLK_RATE       , -- 
            DELAY_CYCLE => 0                  --
        )
        port map (
            RST         => RST              , -- In  :
            I_CLK       => O_CLK            , -- In  :
            I_CKE       => O_CKE            , -- In  :
            I_DONE      => ret_done         , -- In  :
            I_PAUSE     => ret_pause        , -- In  :
            I_SIZE      => out_size         , -- In  :
            I_VAL       => ret_valid        , -- In  :
            O_CLK       => I_CLK            , -- In  :
            O_CKE       => I_CKE            , -- In  :
            O_DONE      => o2i_done         , -- Out :
            O_VAL       => o2i_valid        , -- Out :
            O_SIZE      => o2i_size           -- Out :
        );
    -------------------------------------------------------------------------------
    -- 出力側のブロック
    -------------------------------------------------------------------------------
    O_BLK: block
        signal    curr_pointer  : unsigned(FIFO_DEPTH-1 downto 0);
        signal    next_pointer  : unsigned(FIFO_DEPTH   downto 0);
        signal    curr_counter  : unsigned(FIFO_DEPTH   downto 0);
        signal    next_counter  : unsigned(FIFO_DEPTH   downto 0);
    begin
        O_VAL     <= '1' when (out_valid) else '0';
        O_DONE    <= '1' when (out_done ) else '0';
        O_COUNT   <= std_logic_vector(curr_counter);
        R_PTR     <= std_logic_vector(next_pointer(R_PTR'range));
        ret_done  <= '1' when (out_done  and next_counter = 0) else '0';
        ret_valid <= '1' when (out_valid and O_RDY = '1') else '0';
        process (curr_counter, i2o_valid, i2o_size, ret_valid)
            variable  counter : unsigned(FIFO_DEPTH downto 0);
        begin
            counter := curr_counter;
            if (i2o_valid = '1') then
                counter := counter + unsigned(i2o_size);
            end if;
            if (ret_valid = '1') then
                counter := counter - unsigned(out_size);
            end if;
            next_counter <= counter;
        end process;
        process (curr_pointer, ret_valid) begin
            if (ret_valid = '1') then
                next_pointer <= "0" & curr_pointer + unsigned(out_size);
            else
                next_pointer <= "0" & curr_pointer;
            end if;
        end process;
        process (O_CLK, RST) begin
            if (RST = '1') then
                curr_counter <= (others => '0');
                curr_pointer <= (others => '0');
                out_valid    <= FALSE;
                out_done     <= FALSE;
            elsif (O_CLK'event and O_CLK = '1') then
                if    (ret_done = '1') then
                    curr_counter <= (others => '0');
                    curr_pointer <= (others => '0');
                else
                    curr_counter <= next_counter;
                    curr_pointer <= next_pointer(curr_pointer'range);
                end if;
                if    (i2o_done = '1') then
                    out_done  <= TRUE;
                elsif (ret_done = '1') then
                    out_done  <= FALSE;
                end if;
                if (next_counter = 0) then
                    out_valid <= FALSE;
                else
                    out_valid <= TRUE;
                end if;
            end if;
        end process;
    end block;
end RTL;
