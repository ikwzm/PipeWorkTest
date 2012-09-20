-----------------------------------------------------------------------------------
--!     @file    fifo_with_done_test_bench_async_5_9.vhd
--!     @brief   終了処理付きFIFO用テストベンチ(非同期用)
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
--! @brief 終了処理付きFIFO用テストベンチ(非同期用)
-----------------------------------------------------------------------------------
use     WORK.FIFO_WITH_DONE_COMPONENTS.FIFO_WITH_DONE_TEST_BENCH;
entity  FIFO_WITH_DONE_TEST_BENCH_ASYNC_5_9 is
end     FIFO_WITH_DONE_TEST_BENCH_ASYNC_5_9;
architecture MODEL of FIFO_WITH_DONE_TEST_BENCH_ASYNC_5_9 is
begin
    TB: FIFO_WITH_DONE_TEST_BENCH generic map(
        FIFO_DEPTH   => 8,
        I_CLK_PERIOD => 5 ns,
        I_CLK_RATE   => 0,
        O_CLK_PERIOD => 9 ns,
        O_CLK_RATE   => 0,
        DELAY_CYCLE  => 0,
        AUTO_FINISH  => 1
    )
    port map(
        FINISH       => open
    );
end MODEL;
