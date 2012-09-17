-----------------------------------------------------------------------------------
--!     @file    ../../../src/examples/fifo_with_done/fifo_with_done_components.vhd --
--!     @brief   FIFO_WITH_DONE COMPONENT LIBRARY DESCRIPTION                    --
--!     @version 1.2.0                                                           --
--!     @date    2012/09/17                                                      --
--!     @author  Ichiro Kawazome <ichiro_k@ca2.so-net.ne.jp>                     --
-----------------------------------------------------------------------------------
-----------------------------------------------------------------------------------
--                                                                               --
--      Copyright (C) 2012 Ichiro Kawazome <ichiro_k@ca2.so-net.ne.jp>           --
--      All rights reserved.                                                     --
--                                                                               --
--      Redistribution and use in source and binary forms, with or without       --
--      modification, are permitted provided that the following conditions       --
--      are met:                                                                 --
--                                                                               --
--        1. Redistributions of source code must retain the above copyright      --
--           notice, this list of conditions and the following disclaimer.       --
--                                                                               --
--        2. Redistributions in binary form must reproduce the above copyright   --
--           notice, this list of conditions and the following disclaimer in     --
--           the documentation and/or other materials provided with the          --
--           distribution.                                                       --
--                                                                               --
--      THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS      --
--      "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT        --
--      LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR    --
--      A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT    --
--      OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,    --
--      SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT         --
--      LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,    --
--      DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY    --
--      THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT      --
--      (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE    --
--      OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.     --
--                                                                               --
-----------------------------------------------------------------------------------
library ieee;
use     ieee.std_logic_1164.all;
-----------------------------------------------------------------------------------
--! @brief FIFO_WITH_DONE COMPONENT LIBRARY DESCRIPTION                          --
-----------------------------------------------------------------------------------
package FIFO_WITH_DONE_COMPONENTS is
-----------------------------------------------------------------------------------
--! @brief FIFO_WITH_DONE                                                        --
-----------------------------------------------------------------------------------
component FIFO_WITH_DONE
    generic (
        FIFO_DEPTH  : --! @brief FIFO DEPTH :
                      --! FIFOの深さを２のべき乗値で指定する.
                      integer := 16;
        DATA_WIDTH  : --! @brief DATA WIDTH :
                      integer := 3;
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
        I_DATA      : --! @brief INPUT DATA :
                      --! 入力側データ
                      in  std_logic_vector(2**DATA_WIDTH-1 downto 0);
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
        O_DATA      : --! @brief INPUT DATA :
                      --! 出力側データ
                      out std_logic_vector(2**DATA_WIDTH-1 downto 0);
        O_DONE      : --! @brief OUTPUT DONE :
                      out std_logic;
        O_VAL       : --! @brief OUTPUT VALID :
                      out std_logic;
        O_RDY       : --! @brief OUTPUT ENABLE :
                      in  std_logic;
        O_COUNT     : --! @brief OUTPUT COUNTER :
                      --! 出力側のカウンタ.
                      out std_logic_vector(FIFO_DEPTH   downto 0)
    );
end component;
-----------------------------------------------------------------------------------
--! @brief FIFO_WITH_DONE_TEST_BENCH                                             --
-----------------------------------------------------------------------------------
component FIFO_WITH_DONE_TEST_BENCH
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
end component;
end FIFO_WITH_DONE_COMPONENTS;
