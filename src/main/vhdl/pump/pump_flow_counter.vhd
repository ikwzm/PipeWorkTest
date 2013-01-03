-----------------------------------------------------------------------------------
--!     @file    pump_flow_counter.vhd
--!     @brief   PUMP FLOW COUNTER
--!     @version 1.0.0
--!     @date    2013/1/2
--!     @author  Ichiro Kawazome <ichiro_k@ca2.so-net.ne.jp>
-----------------------------------------------------------------------------------
--
--      Copyright (C) 2012,2013 Ichiro Kawazome
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
--! @brief   PUMP FLOW COUNTER :
-----------------------------------------------------------------------------------
entity  PUMP_COUNT_DOWN_REGISTER is
    generic (
        BITS        : --! @brief  COUNTER BITS :
                      --! カウンターのビット数を指定する.
                      integer := 32
    );
    port (
    -------------------------------------------------------------------------------
    -- クロック&リセット信号
    -------------------------------------------------------------------------------
        CLK         : --! @brief CLOCK :
                      --! クロック信号
                      in  std_logic; 
        RST         : --! @brief ASYNCRONOUSE RESET :
                      --! 非同期リセット信号.アクティブハイ.
                      in  std_logic;
        CLR         : --! @brief SYNCRONOUSE RESET :
                      --! 同期リセット信号.アクティブハイ.
                      in  std_logic;
    -------------------------------------------------------------------------------
    -- 入力側のインターフェース
    -------------------------------------------------------------------------------
        PUSH_VAL    : --! @brief PUSH VALID :
                      in  std_logic;
        PUSH_DONE   : --! @brief PUSH DONE  :
                      in  std_logic;
        PUSH_STOP   : --! @brief PUSH DONE  :
                      in  std_logic;
        PUSH_SIZE   : --! @brief PUSH SIZE  :
                      in  std_logic_vector(BITS-1 downto 0);
    -------------------------------------------------------------------------------
    -- 出力側のインターフェース
    -------------------------------------------------------------------------------
        PULL_VAL    : --! @brief PULL VALID :
                      in  std_logic;
        PULL_DONE   : --! @brief PULL DONE  :
                      in  std_logic;
        PULL_STOP   : --! @brief PULL DONE  :
                      in  std_logic;
        PULL_SIZE   : --! @brief PULL SIZE  :
                      in  std_logic_vector(BITS-1 downto 0);
    -------------------------------------------------------------------------------
    -- カウンタ出力
    -------------------------------------------------------------------------------
        COUNT       : --! @brief COUNT :
                      out std_logic_vector(BITS-1 downto 0);
        NEXT_COUNT  : --! @brief NEXT COUNT :
                      out std_logic_vector(BITS-1 downto 0)
    );
end PUMP_FLOW_COUNTER;
-----------------------------------------------------------------------------------
-- 
-----------------------------------------------------------------------------------
library ieee;
use     ieee.std_logic_1164.all;
use     ieee.numeric_std.all;
architecture RTL of PUMP_FLOW_COUNTER is
begin
   
        
end RTL;
