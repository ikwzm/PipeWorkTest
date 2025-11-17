-----------------------------------------------------------------------------------
--!     @file    axi_traffic_checker.vhd
--!     @brief   AXI Traffic Checker Module
--!     @version 0.6.0
--!     @date    2025/11/17
--!     @author  Ichiro Kawazome <ichiro_k@ca2.so-net.ne.jp>
-----------------------------------------------------------------------------------
--
--      Copyright (C) 2024-2025 Ichiro Kawazome
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
--! @brief 
-----------------------------------------------------------------------------------
entity  AXI_TRAFFIC_CHECKER is
    -------------------------------------------------------------------------------
    -- 
    -------------------------------------------------------------------------------
    generic (
        BUILD_VERSION   : integer range 1 to  255 :=  1;
        C_ADDR_WIDTH    : integer range 1 to   64 := 12;
        C_DATA_WIDTH    : integer range 8 to 1024 := 32;
        C_ID_WIDTH      : integer                 :=  8;
        M_AXI_ID        : integer                 :=  1;
        M_ADDR_WIDTH    : integer range 1 to   64 := 32;
        M_DATA_WIDTH    : integer range 8 to 1024 := 32;
        M_ID_WIDTH      : integer                 :=  8;
        M_AUSER_WIDTH   : integer                 :=  4;
        MW_MAX_XFER_SIZE: integer                 := 12;
        MW_QUEUE_SIZE   : integer                 :=  2;
        MW_REQ_REGS     : integer                 :=  1;
        MW_ACK_REGS     : integer                 :=  1;
        MW_RESP_REGS    : integer                 :=  1;
        MW_DATA_PIPELINE: integer                 :=  0;
        MW_MONITOR_BITS : integer range 32 to 64  := 32;
        MR_MAX_XFER_SIZE: integer                 := 12;
        MR_QUEUE_SIZE   : integer                 :=  1;
        MR_ACK_REGS     : integer                 :=  1;
        MR_DATA_REGS    : integer                 :=  1;
        MR_DATA_PIPELINE: integer                 :=  0;
        MR_MONITOR_BITS : integer range 32 to 64  := 32
    );
    port(
    -------------------------------------------------------------------------------
    -- Reset Signals.
    -------------------------------------------------------------------------------
        ARESETn         : in    std_logic;
    -------------------------------------------------------------------------------
    -- Clock.
    -------------------------------------------------------------------------------
        ACLK            : in    std_logic;
    -------------------------------------------------------------------------------
    -- Control Status Register I/F AXI4 Read Address Channel Signals.
    -------------------------------------------------------------------------------
        C_ARID          : in    std_logic_vector(C_ID_WIDTH    -1 downto 0);
        C_ARADDR        : in    std_logic_vector(C_ADDR_WIDTH  -1 downto 0);
        C_ARLEN         : in    std_logic_vector(7 downto 0);
        C_ARSIZE        : in    std_logic_vector(2 downto 0);
        C_ARBURST       : in    std_logic_vector(1 downto 0);
        C_ARVALID       : in    std_logic;
        C_ARREADY       : out   std_logic;
    -------------------------------------------------------------------------------
    -- Control Status Register I/F AXI4 Read Data Channel Signals.
    -------------------------------------------------------------------------------
        C_RID           : out   std_logic_vector(C_ID_WIDTH    -1 downto 0);
        C_RDATA         : out   std_logic_vector(C_DATA_WIDTH  -1 downto 0);
        C_RRESP         : out   std_logic_vector(1 downto 0);
        C_RLAST         : out   std_logic;
        C_RVALID        : out   std_logic;
        C_RREADY        : in    std_logic;
    -------------------------------------------------------------------------------
    -- Control Status Register I/F AXI4 Write Address Channel Signals.
    -------------------------------------------------------------------------------
        C_AWID          : in    std_logic_vector(C_ID_WIDTH    -1 downto 0);
        C_AWADDR        : in    std_logic_vector(C_ADDR_WIDTH  -1 downto 0);
        C_AWLEN         : in    std_logic_vector(7 downto 0);
        C_AWSIZE        : in    std_logic_vector(2 downto 0);
        C_AWBURST       : in    std_logic_vector(1 downto 0);
        C_AWVALID       : in    std_logic;
        C_AWREADY       : out   std_logic;
    -------------------------------------------------------------------------------
    -- Control Status Register I/F AXI4 Write Data Channel Signals.
    -------------------------------------------------------------------------------
        C_WDATA         : in    std_logic_vector(C_DATA_WIDTH  -1 downto 0);
        C_WSTRB         : in    std_logic_vector(C_DATA_WIDTH/8-1 downto 0);
        C_WLAST         : in    std_logic;
        C_WVALID        : in    std_logic;
        C_WREADY        : out   std_logic;
    -------------------------------------------------------------------------------
    -- Control Status Register I/F AXI4 Write Response Channel Signals.
    -------------------------------------------------------------------------------
        C_BID           : out   std_logic_vector(C_ID_WIDTH    -1 downto 0);
        C_BRESP         : out   std_logic_vector(1 downto 0);
        C_BVALID        : out   std_logic;
        C_BREADY        : in    std_logic;
    -------------------------------------------------------------------------------
    -- Traffic I/F AXI4 Write Address Channel Signals.
    -------------------------------------------------------------------------------
        M_AWID          : out   std_logic_vector(M_ID_WIDTH    -1 downto 0);
        M_AWADDR        : out   std_logic_vector(M_ADDR_WIDTH  -1 downto 0);
        M_AWLEN         : out   std_logic_vector(7 downto 0);
        M_AWSIZE        : out   std_logic_vector(2 downto 0);
        M_AWBURST       : out   std_logic_vector(1 downto 0);
        M_AWLOCK        : out   std_logic_vector(0 downto 0);
        M_AWCACHE       : out   std_logic_vector(3 downto 0);
        M_AWPROT        : out   std_logic_vector(2 downto 0);
        M_AWQOS         : out   std_logic_vector(3 downto 0);
        M_AWREGION      : out   std_logic_vector(3 downto 0);
        M_AWUSER        : out   std_logic_vector(M_AUSER_WIDTH -1 downto 0);
        M_AWVALID       : out   std_logic;
        M_AWREADY       : in    std_logic;
    -------------------------------------------------------------------------------
    -- Traffic I/F AXI4 Write Data Channel Signals.
    -------------------------------------------------------------------------------
        M_WID           : out   std_logic_vector(M_ID_WIDTH    -1 downto 0);
        M_WDATA         : out   std_logic_vector(M_DATA_WIDTH  -1 downto 0);
        M_WSTRB         : out   std_logic_vector(M_DATA_WIDTH/8-1 downto 0);
        M_WLAST         : out   std_logic;
        M_WVALID        : out   std_logic;
        M_WREADY        : in    std_logic;
    -------------------------------------------------------------------------------
    -- Traffic I/F AXI4 Write Response Channel Signals.
    -------------------------------------------------------------------------------
        M_BID           : in    std_logic_vector(M_ID_WIDTH    -1 downto 0);
        M_BRESP         : in    std_logic_vector(1 downto 0);
        M_BVALID        : in    std_logic;
        M_BREADY        : out   std_logic;
    -------------------------------------------------------------------------------
    -- Traffic I/F AXI4 Read Address Channel Signals.
    -------------------------------------------------------------------------------
        M_ARID          : out   std_logic_vector(M_ID_WIDTH    -1 downto 0);
        M_ARADDR        : out   std_logic_vector(M_ADDR_WIDTH  -1 downto 0);
        M_ARLEN         : out   std_logic_vector(7 downto 0);
        M_ARSIZE        : out   std_logic_vector(2 downto 0);
        M_ARBURST       : out   std_logic_vector(1 downto 0);
        M_ARLOCK        : out   std_logic_vector(0 downto 0);
        M_ARCACHE       : out   std_logic_vector(3 downto 0);
        M_ARPROT        : out   std_logic_vector(2 downto 0);
        M_ARQOS         : out   std_logic_vector(3 downto 0);
        M_ARREGION      : out   std_logic_vector(3 downto 0);
        M_ARUSER        : out   std_logic_vector(M_AUSER_WIDTH -1 downto 0);
        M_ARVALID       : out   std_logic;
        M_ARREADY       : in    std_logic;
    -------------------------------------------------------------------------------
    -- Traffic I/F AXI4 Read Data Channel Signals.
    -------------------------------------------------------------------------------
        M_RID           : in    std_logic_vector(M_ID_WIDTH    -1 downto 0);
        M_RDATA         : in    std_logic_vector(M_DATA_WIDTH  -1 downto 0);
        M_RRESP         : in    std_logic_vector(1 downto 0);
        M_RLAST         : in    std_logic;
        M_RVALID        : in    std_logic;
        M_RREADY        : out   std_logic;
    -------------------------------------------------------------------------------
    -- Interrupt Request Signal.
    -------------------------------------------------------------------------------
        IRQ             : out   std_logic
    );
end AXI_TRAFFIC_CHECKER;
-----------------------------------------------------------------------------------
-- アーキテクチャ本体
-----------------------------------------------------------------------------------
library ieee;
use     ieee.std_logic_1164.all;
use     ieee.numeric_std.all;
library PIPEWORK;
use     PIPEWORK.AXI4_TYPES.all;
use     PIPEWORK.AXI4_COMPONENTS.AXI4_MASTER_READ_INTERFACE;
use     PIPEWORK.AXI4_COMPONENTS.AXI4_MASTER_WRITE_INTERFACE;
use     PIPEWORK.AXI4_COMPONENTS.AXI4_REGISTER_INTERFACE;
use     PIPEWORK.AXI4_COMPONENTS.AXI4_TRAFFIC_MONITOR;
use     PIPEWORK.COMPONENTS.REGISTER_ACCESS_ADAPTER;
use     PIPEWORK.PUMP_COMPONENTS.PUMP_CONTROLLER_OUTLET_SIDE;
use     PIPEWORK.PUMP_COMPONENTS.PUMP_CONTROLLER_INTAKE_SIDE;
architecture RTL of AXI_TRAFFIC_CHECKER is
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    function  CALC_BITS(N:integer) return integer is
        variable bits : integer;
    begin
        bits := 1;
        while (2**bits < N) loop
            bits := bits + 1;
        end loop;
        return bits;
    end function;
    -------------------------------------------------------------------------------
    -- Reset Signals.
    -------------------------------------------------------------------------------
    signal    RST                   :  std_logic;
    constant  CLR                   :  std_logic := '0';
    -------------------------------------------------------------------------------
    -- レジスタアクセスインターフェースのアドレスのビット数.
    -------------------------------------------------------------------------------
    constant  REGS_ADDR_WIDTH       :  integer := 8;
    -------------------------------------------------------------------------------
    -- 全レジスタのビット数.
    -------------------------------------------------------------------------------
    constant  REGS_DATA_BITS        :  integer := (2**REGS_ADDR_WIDTH)*8;
    -------------------------------------------------------------------------------
    -- レジスタアクセスインターフェースのデータのビット数.
    -------------------------------------------------------------------------------
    constant  REGS_DATA_WIDTH       :  integer := 32;
    -------------------------------------------------------------------------------
    -- レジスタアクセス用の信号群.
    -------------------------------------------------------------------------------
    signal    regs_load             :  std_logic_vector(REGS_DATA_BITS   -1 downto 0);
    signal    regs_wbit             :  std_logic_vector(REGS_DATA_BITS   -1 downto 0);
    signal    regs_rbit             :  std_logic_vector(REGS_DATA_BITS   -1 downto 0);
    -------------------------------------------------------------------------------
    -- Version Register
    -------------------------------------------------------------------------------
    --           31            24              16               8               0
    --           +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    -- Addr=0x00 |                                                               |
    --           +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    -- Addr=0x04 | MAJOR | MINOR | BUILD_VERSION |                       |  DW   | 
    --           +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    -------------------------------------------------------------------------------
    constant  VERSION_REGS_ADDR     :  integer := 16#00#;
    constant  VERSION_REGS_BITS     :  integer := 64;
    constant  VERSION_REGS_LO       :  integer := 8*VERSION_REGS_ADDR;
    constant  VERSION_REGS_HI       :  integer := 8*VERSION_REGS_ADDR + VERSION_REGS_BITS- 1;
    constant  VERSION_MAJOR         :  integer range 0 to 15 := 0;
    constant  VERSION_MINOR         :  integer range 0 to 15 := 6;
    constant  VERSION_REGS_DATA     :  std_logic_vector(VERSION_REGS_BITS-1 downto 0)
                                    := std_logic_vector(to_unsigned(VERSION_MAJOR          , 4)) &
                                       std_logic_vector(to_unsigned(VERSION_MINOR          , 4)) &
                                       std_logic_vector(to_unsigned(BUILD_VERSION          , 8)) &
                                       std_logic_vector(to_unsigned(0                      ,12)) &
                                       std_logic_vector(to_unsigned(CALC_BITS(M_DATA_WIDTH), 4)) &
                                       std_logic_vector(to_unsigned(0                      ,32));
    -------------------------------------------------------------------------------
    -- Master Read Parameter Register
    -------------------------------------------------------------------------------
    --           31            24              16               8               0
    --           +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    -- Addr=0x08 |                               | P | D | A |   | QUEUE | XSIZE |
    --           +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    -------------------------------------------------------------------------------
    constant  MR_PARAM_REGS_ADDR    :  integer := 16#08#;
    constant  MR_PARAM_REGS_BITS    :  integer := 32;
    constant  MR_PARAM_REGS_LO      :  integer := 8*MR_PARAM_REGS_ADDR;
    constant  MR_PARAM_REGS_HI      :  integer := 8*MR_PARAM_REGS_ADDR + MR_PARAM_REGS_BITS- 1;
    constant  MR_PARAM_REGS_DATA    :  std_logic_vector(MR_PARAM_REGS_BITS-1 downto 0)
                                    := std_logic_vector(to_unsigned(0               ,16)) &
                                       std_logic_vector(to_unsigned(MR_DATA_PIPELINE, 2)) &
                                       std_logic_vector(to_unsigned(MR_DATA_REGS    , 2)) &
                                       std_logic_vector(to_unsigned(MR_ACK_REGS     , 2)) &
                                       std_logic_vector(to_unsigned(0               , 2)) &
                                       std_logic_vector(to_unsigned(MR_QUEUE_SIZE   , 4)) &
                                       std_logic_vector(to_unsigned(MR_MAX_XFER_SIZE, 4));
    -------------------------------------------------------------------------------
    -- Master Write Parameter Register
    -------------------------------------------------------------------------------
    --           31            24              16               8               0
    --           +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    -- Addr=0x0C |                               | P | D | A | R | QUEUE | XSIZE |
    --           +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    -------------------------------------------------------------------------------
    constant  MW_PARAM_REGS_ADDR    :  integer := 16#0C#;
    constant  MW_PARAM_REGS_BITS    :  integer := 32;
    constant  MW_PARAM_REGS_LO      :  integer := 8*MW_PARAM_REGS_ADDR;
    constant  MW_PARAM_REGS_HI      :  integer := 8*MW_PARAM_REGS_ADDR + MW_PARAM_REGS_BITS- 1;
    constant  MW_PARAM_REGS_DATA    :  std_logic_vector(MW_PARAM_REGS_BITS-1 downto 0)
                                    := std_logic_vector(to_unsigned(0               ,16)) &
                                       std_logic_vector(to_unsigned(MW_DATA_PIPELINE, 2)) &
                                       std_logic_vector(to_unsigned(MW_RESP_REGS    , 2)) &
                                       std_logic_vector(to_unsigned(MW_ACK_REGS     , 2)) &
                                       std_logic_vector(to_unsigned(MW_REQ_REGS     , 2)) &
                                       std_logic_vector(to_unsigned(MW_QUEUE_SIZE   , 4)) &
                                       std_logic_vector(to_unsigned(MW_MAX_XFER_SIZE, 4));
    -------------------------------------------------------------------------------
    -- Master Read Registers
    -------------------------------------------------------------------------------
    --           31            24              16               8               0
    --           +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    -- Addr=0x10 |                       Address[31:00]                          |
    --           +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    -- Addr=0x14 |                       Address[63:31]                          |
    --           +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    -- Addr=0x18 |                          Size[31:00]                          |
    --           +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    -- Addr=0x1C | Control[7:0]  |  Status[7:0]  |          Mode[15:00]          |
    --           +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    -------------------------------------------------------------------------------
    constant  MR_REGS_BASE_ADDR     :  integer := 16#10#;
    constant  MR_REGS_BITS          :  integer := 128;
    constant  MR_REGS_LO            :  integer := 8*MR_REGS_BASE_ADDR;
    constant  MR_REGS_HI            :  integer := MR_REGS_LO + MR_REGS_BITS - 1;
    -------------------------------------------------------------------------------
    -- Master Read Address Register
    -------------------------------------------------------------------------------
    -- Address     = 転送開始アドレス.
    -------------------------------------------------------------------------------
    constant  MR_ADDR_REGS_ADDR     :  integer := MR_REGS_BASE_ADDR + 16#00#;
    constant  MR_ADDR_REGS_BITS     :  integer := 64;
    constant  MR_ADDR_REGS_LO       :  integer := 8*MR_ADDR_REGS_ADDR;
    constant  MR_ADDR_REGS_HI       :  integer := 8*MR_ADDR_REGS_ADDR + MR_ADDR_REGS_BITS-1;
    -------------------------------------------------------------------------------
    -- Master Read Size Register
    -------------------------------------------------------------------------------
    -- Size[31:00] = 転送サイズ.
    -------------------------------------------------------------------------------
    constant  MR_SIZE_REGS_ADDR     :  integer := MR_REGS_BASE_ADDR + 16#08#;
    constant  MR_SIZE_REGS_BITS     :  integer := 32;
    constant  MR_SIZE_REGS_LO       :  integer := 8*MR_SIZE_REGS_ADDR;
    constant  MR_SIZE_REGS_HI       :  integer := 8*MR_SIZE_REGS_ADDR + MR_SIZE_REGS_BITS-1;
    -------------------------------------------------------------------------------
    -- Master Read Mode Register
    -------------------------------------------------------------------------------
    -- Mode[15]    = 1:AXI4 Master Read I/F をセイフティモードで動かす.
    -- Mode[14]    = 1:AXI4 Master Read I/F を投機モードで動かす.
    -- Mode[10:08] = AXI4 Master Read I/F の APROT の値を指定する.
    -- Mode[07:04] = AXI4 Master Read I/F のキャッシュモードを指定する.
    -- Mode[01]    = 1:エラー発生時(Status[1]='1')に割り込みを発生する.
    -- Mode[00]    = 1:転送終了時(Status[0]='1')に割り込みを発生する.
    -------------------------------------------------------------------------------
    constant  MR_MODE_REGS_ADDR     :  integer := MR_REGS_BASE_ADDR + 16#0C#;
    constant  MR_MODE_REGS_BITS     :  integer := 16;
    constant  MR_MODE_REGS_HI       :  integer := 8*MR_MODE_REGS_ADDR + 15;
    constant  MR_MODE_REGS_LO       :  integer := 8*MR_MODE_REGS_ADDR +  0;
    constant  MR_MODE_SAFETY_POS    :  integer := 8*MR_MODE_REGS_ADDR + 15;
    constant  MR_MODE_SPECUL_POS    :  integer := 8*MR_MODE_REGS_ADDR + 14;
    constant  MR_MODE_PROT_HI       :  integer := 8*MR_MODE_REGS_ADDR + 10;
    constant  MR_MODE_PROT_LO       :  integer := 8*MR_MODE_REGS_ADDR +  8;
    constant  MR_MODE_CACHE_HI      :  integer := 8*MR_MODE_REGS_ADDR +  7;
    constant  MR_MODE_CACHE_LO      :  integer := 8*MR_MODE_REGS_ADDR +  4;
    constant  MR_MODE_ERROR_POS     :  integer := 8*MR_MODE_REGS_ADDR +  1;
    constant  MR_MODE_DONE_POS      :  integer := 8*MR_MODE_REGS_ADDR +  0;
    -------------------------------------------------------------------------------
    -- Master Read Status Register
    -------------------------------------------------------------------------------
    -- Status[7:2] = 予約.
    -- Status[1]   = エラー発生時にセットされる.
    -- Status[0]   = 転送終了時かつ Control[2]='1' にセットされる.
    -------------------------------------------------------------------------------
    constant  MR_STAT_REGS_ADDR     :  integer := MR_REGS_BASE_ADDR + 16#0E#;
    constant  MR_STAT_REGS_BITS     :  integer := 8;
    constant  MR_STAT_RESV_HI       :  integer := 8*MR_STAT_REGS_ADDR +  7;
    constant  MR_STAT_RESV_LO       :  integer := 8*MR_STAT_REGS_ADDR +  2;
    constant  MR_STAT_ERROR_POS     :  integer := 8*MR_STAT_REGS_ADDR +  1;
    constant  MR_STAT_DONE_POS      :  integer := 8*MR_STAT_REGS_ADDR +  0;
    constant  MR_STAT_RESV_BITS     :  integer := MR_STAT_RESV_HI - MR_STAT_RESV_LO + 1;
    constant  MR_STAT_RESV_NULL     :  std_logic_vector(MR_STAT_RESV_BITS-1 downto 0) := (others => '0');
    ------------------------------------------------------------------------------
    -- Master Read Control Register
    -------------------------------------------------------------------------------
    -- Control[7]  = 1:モジュールをリセットする. 0:リセットを解除する.
    -- Control[6]  = 1:転送を一時中断する.       0:転送を再開する.
    -- Control[5]  = 1:転送を中止する.           0:意味無し.
    -- Control[4]  = 1:転送を開始する.           0:意味無し.
    -- Control[3]  = 予約.
    -- Control[2]  = 1:転送終了時にStatus[0]がセットされる.
    -- Control[1]  = 1:連続したトランザクションの開始を指定する.
    -- Control[0]  = 1:連続したトランザクションの終了を指定する.
    -------------------------------------------------------------------------------
    constant  MR_CTRL_REGS_ADDR     :  integer := MR_REGS_BASE_ADDR + 16#0F#;
    constant  MR_CTRL_RESET_POS     :  integer := 8*MR_CTRL_REGS_ADDR +  7;
    constant  MR_CTRL_PAUSE_POS     :  integer := 8*MR_CTRL_REGS_ADDR +  6;
    constant  MR_CTRL_STOP_POS      :  integer := 8*MR_CTRL_REGS_ADDR +  5;
    constant  MR_CTRL_START_POS     :  integer := 8*MR_CTRL_REGS_ADDR +  4;
    constant  MR_CTRL_RESV_POS      :  integer := 8*MR_CTRL_REGS_ADDR +  3;
    constant  MR_CTRL_DONE_POS      :  integer := 8*MR_CTRL_REGS_ADDR +  2;
    constant  MR_CTRL_FIRST_POS     :  integer := 8*MR_CTRL_REGS_ADDR +  1;
    constant  MR_CTRL_LAST_POS      :  integer := 8*MR_CTRL_REGS_ADDR +  0;
    -------------------------------------------------------------------------------
    -- Master Write Registers
    -------------------------------------------------------------------------------
    --           31            24              16               8               0
    --           +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    -- Addr=0x20 |                       Address[31:00]                          |
    --           +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    -- Addr=0x24 |                       Address[63:31]                          |
    --           +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    -- Addr=0x28 |                          Size[31:00]                          |
    --           +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    -- Addr=0x2C | Control[7:0]  |  Status[7:0]  |          Mode[15:00]          |
    --           +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    -------------------------------------------------------------------------------
    constant  MW_REGS_BASE_ADDR     :  integer := 16#20#;
    constant  MW_REGS_BITS          :  integer := 128;
    constant  MW_REGS_LO            :  integer := 8*MW_REGS_BASE_ADDR;
    constant  MW_REGS_HI            :  integer := MW_REGS_LO + MW_REGS_BITS - 1;
    -------------------------------------------------------------------------------
    -- Master Write Address Register
    -------------------------------------------------------------------------------
    -- Address     = 転送開始アドレス.
    -------------------------------------------------------------------------------
    constant  MW_ADDR_REGS_ADDR     :  integer := MW_REGS_BASE_ADDR + 16#00#;
    constant  MW_ADDR_REGS_BITS     :  integer := 64;
    constant  MW_ADDR_REGS_LO       :  integer := 8*MW_ADDR_REGS_ADDR;
    constant  MW_ADDR_REGS_HI       :  integer := 8*MW_ADDR_REGS_ADDR + MW_ADDR_REGS_BITS-1;
    -------------------------------------------------------------------------------
    -- Master Write Size Register
    -------------------------------------------------------------------------------
    -- Size[31:00] = 転送サイズ.
    -------------------------------------------------------------------------------
    constant  MW_SIZE_REGS_ADDR     :  integer := MW_REGS_BASE_ADDR + 16#08#;
    constant  MW_SIZE_REGS_BITS     :  integer := 32;
    constant  MW_SIZE_REGS_LO       :  integer := 8*MW_SIZE_REGS_ADDR;
    constant  MW_SIZE_REGS_HI       :  integer := 8*MW_SIZE_REGS_ADDR + MW_SIZE_REGS_BITS-1;
    -------------------------------------------------------------------------------
    -- Master Write Mode Register
    -------------------------------------------------------------------------------
    -- Mode[15]    = 1:AXI4 Master Write I/F をセイフティモードで動かす.
    -- Mode[14]    = 1:AXI4 Master Write I/F を投機モードで動かす.
    -- Mode[10:08] = AXI4 Master Write I/F の APROT の値を指定する.
    -- Mode[07:04] = AXI4 Master Write I/F のキャッシュモードを指定する.
    -- Mode[01]    = 1:エラー発生時(Status[1]='1')に割り込みを発生する.
    -- Mode[00]    = 1:転送終了時(Status[0]='1')に割り込みを発生する.
    -------------------------------------------------------------------------------
    constant  MW_MODE_REGS_ADDR     :  integer := MW_REGS_BASE_ADDR + 16#0C#;
    constant  MW_MODE_REGS_BITS     :  integer := 16;
    constant  MW_MODE_REGS_HI       :  integer := 8*MW_MODE_REGS_ADDR + 15;
    constant  MW_MODE_REGS_LO       :  integer := 8*MW_MODE_REGS_ADDR +  0;
    constant  MW_MODE_SAFETY_POS    :  integer := 8*MW_MODE_REGS_ADDR + 15;
    constant  MW_MODE_SPECUL_POS    :  integer := 8*MW_MODE_REGS_ADDR + 14;
    constant  MW_MODE_PROT_HI       :  integer := 8*MW_MODE_REGS_ADDR + 10;
    constant  MW_MODE_PROT_LO       :  integer := 8*MW_MODE_REGS_ADDR +  8;
    constant  MW_MODE_CACHE_HI      :  integer := 8*MW_MODE_REGS_ADDR +  7;
    constant  MW_MODE_CACHE_LO      :  integer := 8*MW_MODE_REGS_ADDR +  4;
    constant  MW_MODE_ERROR_POS     :  integer := 8*MW_MODE_REGS_ADDR +  1;
    constant  MW_MODE_DONE_POS      :  integer := 8*MW_MODE_REGS_ADDR +  0;
    -------------------------------------------------------------------------------
    -- Master Write Status Register
    -------------------------------------------------------------------------------
    -- Status[7:2] = 予約.
    -- Status[1]   = エラー発生時にセットされる.
    -- Status[0]   = 転送終了時かつ Control[2]='1' にセットされる.
    -------------------------------------------------------------------------------
    constant  MW_STAT_REGS_ADDR     :  integer := MW_REGS_BASE_ADDR + 16#0E#;
    constant  MW_STAT_REGS_BITS     :  integer := 8;
    constant  MW_STAT_RESV_HI       :  integer := 8*MW_STAT_REGS_ADDR +  7;
    constant  MW_STAT_RESV_LO       :  integer := 8*MW_STAT_REGS_ADDR +  2;
    constant  MW_STAT_ERROR_POS     :  integer := 8*MW_STAT_REGS_ADDR +  1;
    constant  MW_STAT_DONE_POS      :  integer := 8*MW_STAT_REGS_ADDR +  0;
    constant  MW_STAT_RESV_BITS     :  integer := MW_STAT_RESV_HI - MW_STAT_RESV_LO + 1;
    constant  MW_STAT_RESV_NULL     :  std_logic_vector(MW_STAT_RESV_BITS-1 downto 0) := (others => '0');
    ------------------------------------------------------------------------------
    -- Master Write Control Register
    -------------------------------------------------------------------------------
    -- Control[7]  = 1:モジュールをリセットする. 0:リセットを解除する.
    -- Control[6]  = 1:転送を一時中断する.       0:転送を再開する.
    -- Control[5]  = 1:転送を中止する.           0:意味無し.
    -- Control[4]  = 1:転送を開始する.           0:意味無し.
    -- Control[3]  = 予約.
    -- Control[2]  = 1:転送終了時にStatus[0]がセットされる.
    -- Control[1]  = 1:連続したトランザクションの開始を指定する.
    -- Control[0]  = 1:連続したトランザクションの終了を指定する.
    -------------------------------------------------------------------------------
    constant  MW_CTRL_REGS_ADDR     :  integer := MW_REGS_BASE_ADDR + 16#0F#;
    constant  MW_CTRL_RESET_POS     :  integer := 8*MW_CTRL_REGS_ADDR +  7;
    constant  MW_CTRL_PAUSE_POS     :  integer := 8*MW_CTRL_REGS_ADDR +  6;
    constant  MW_CTRL_STOP_POS      :  integer := 8*MW_CTRL_REGS_ADDR +  5;
    constant  MW_CTRL_START_POS     :  integer := 8*MW_CTRL_REGS_ADDR +  4;
    constant  MW_CTRL_RESV_POS      :  integer := 8*MW_CTRL_REGS_ADDR +  3;
    constant  MW_CTRL_DONE_POS      :  integer := 8*MW_CTRL_REGS_ADDR +  2;
    constant  MW_CTRL_FIRST_POS     :  integer := 8*MW_CTRL_REGS_ADDR +  1;
    constant  MW_CTRL_LAST_POS      :  integer := 8*MW_CTRL_REGS_ADDR +  0;
    -------------------------------------------------------------------------------
    -- Reserved Register
    -------------------------------------------------------------------------------
    --           31            24              16               8               0
    --           +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    -- Addr=0x30 |                                                               |
    --           +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    -- Addr=0x34 |                              :                                |
    --           :                              :                                :
    -- Addr=0x78 |                              :                                |
    --           +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    -- Addr=0x7C |                                                               |
    --           +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    -------------------------------------------------------------------------------
    constant  RESERVED_REGS_ADDR    :  integer := 16#30#;
    constant  RESERVED_REGS_BITS    :  integer := 8*80;
    constant  RESERVED_REGS_LO      :  integer := 8*RESERVED_REGS_ADDR;
    constant  RESERVED_REGS_HI      :  integer := 8*RESERVED_REGS_ADDR + RESERVED_REGS_BITS- 1;
    constant  RESERVED_REGS_DATA    :  std_logic_vector(RESERVED_REGS_BITS-1 downto 0)
                                    := (others => '0');
    -------------------------------------------------------------------------------
    -- Master Read Monitor Registers
    -------------------------------------------------------------------------------
    --           31            24              16               8               0
    --           +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    -- Addr=0x80 |                     MR_MONITOR_CTRL[31:00]                    |
    --           +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    -- Addr=0x84 |                     MR_MONITOR_CTRL[63:32]                    |
    --           +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    -- Addr=0x88 |                     MR_MONITOR_COUNT[31:00]                   |
    --           +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    -- Addr=0x8C |                     MR_MONITOR_COUNT[63:32]                   |
    --           +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    -- Addr=0x90 |                     MR_MONITOR_ADDR[31:00]                    |
    --           +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    -- Addr=0x94 |                     MR_MONITOR_ADDR[63:32]                    |
    --           +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    -- Addr=0x98 |                     MR_MONITOR_AVAL[31:00]                    |
    --           +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    -- Addr=0x9C |                     MR_MONITOR_AVAL[63:32]                    |
    --           +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    -- Addr=0xA0 |                     MR_MONITOR_ARDY[31:00]                    |
    --           +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    -- Addr=0xA4 |                     MR_MONITOR_ARDY[63:32]                    |
    --           +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    -- Addr=0xA8 |                     MR_MONITOR_DATA[31:00]                    |
    --           +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    -- Addr=0xAC |                     MR_MONITOR_DATA[63:32]                    |
    --           +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    -- Addr=0xB0 |                     MR_MONITOR_DVAL[31:00]                    |
    --           +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    -- Addr=0xB4 |                     MR_MONITOR_DVAL[63:32]                    |
    --           +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    -- Addr=0xB8 |                     MR_MONITOR_DRDY[31:00]                    |
    --           +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    -- Addr=0xBC |                     MR_MONITOR_DRDY[63:32]                    |
    --           +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    -------------------------------------------------------------------------------
    constant  MR_MONITOR_CTRL_ADDR       :  integer := 16#80#;
    constant  MR_MONITOR_CTRL_BITS       :  integer := 64;
    constant  MR_MONITOR_CTRL_LO         :  integer := 8*MR_MONITOR_CTRL_ADDR;
    constant  MR_MONITOR_CTRL_HI         :  integer := 8*MR_MONITOR_CTRL_ADDR  + MR_MONITOR_CTRL_BITS -1;
    constant  MR_MONITOR_RESET_POS       :  integer := 8*MR_MONITOR_CTRL_ADDR  + 63;
    constant  MR_MONITOR_COUNT_ADDR      :  integer := 16#88#;
    constant  MR_MONITOR_COUNT_BITS      :  integer := 64;
    constant  MR_MONITOR_COUNT_LO        :  integer := 8*MR_MONITOR_COUNT_ADDR;
    constant  MR_MONITOR_COUNT_HI        :  integer := 8*MR_MONITOR_COUNT_ADDR + MR_MONITOR_COUNT_BITS-1;
    constant  MR_MONITOR_ADDR_ADDR       :  integer := 16#90#;
    constant  MR_MONITOR_ADDR_BITS       :  integer := 64;
    constant  MR_MONITOR_ADDR_LO         :  integer := 8*MR_MONITOR_ADDR_ADDR;
    constant  MR_MONITOR_ADDR_HI         :  integer := 8*MR_MONITOR_ADDR_ADDR  + MR_MONITOR_ADDR_BITS -1;
    constant  MR_MONITOR_AVAL_ADDR       :  integer := 16#98#;
    constant  MR_MONITOR_AVAL_BITS       :  integer := 64;
    constant  MR_MONITOR_AVAL_LO         :  integer := 8*MR_MONITOR_AVAL_ADDR;
    constant  MR_MONITOR_AVAL_HI         :  integer := 8*MR_MONITOR_AVAL_ADDR  + MR_MONITOR_AVAL_BITS -1;
    constant  MR_MONITOR_ARDY_ADDR       :  integer := 16#A0#;
    constant  MR_MONITOR_ARDY_BITS       :  integer := 64;
    constant  MR_MONITOR_ARDY_LO         :  integer := 8*MR_MONITOR_ARDY_ADDR;
    constant  MR_MONITOR_ARDY_HI         :  integer := 8*MR_MONITOR_ARDY_ADDR  + MR_MONITOR_ARDY_BITS -1;
    constant  MR_MONITOR_DATA_ADDR       :  integer := 16#A8#;
    constant  MR_MONITOR_DATA_BITS       :  integer := 64;
    constant  MR_MONITOR_DATA_LO         :  integer := 8*MR_MONITOR_DATA_ADDR;
    constant  MR_MONITOR_DATA_HI         :  integer := 8*MR_MONITOR_DATA_ADDR  + MR_MONITOR_DATA_BITS -1;
    constant  MR_MONITOR_DVAL_ADDR       :  integer := 16#B0#;
    constant  MR_MONITOR_DVAL_BITS       :  integer := 64;
    constant  MR_MONITOR_DVAL_LO         :  integer := 8*MR_MONITOR_DVAL_ADDR;
    constant  MR_MONITOR_DVAL_HI         :  integer := 8*MR_MONITOR_DVAL_ADDR  + MR_MONITOR_DVAL_BITS -1;
    constant  MR_MONITOR_DRDY_ADDR       :  integer := 16#B8#;
    constant  MR_MONITOR_DRDY_BITS       :  integer := 64;
    constant  MR_MONITOR_DRDY_LO         :  integer := 8*MR_MONITOR_DRDY_ADDR;
    constant  MR_MONITOR_DRDY_HI         :  integer := 8*MR_MONITOR_DRDY_ADDR  + MR_MONITOR_DRDY_BITS -1;
    -------------------------------------------------------------------------------
    -- Master Write Monitor Registers
    -------------------------------------------------------------------------------
    --           31            24              16               8               0
    --           +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    -- Addr=0xC0 |                     MW_MONITOR_CTRL[31:00]                    |
    --           +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    -- Addr=0xC4 |                     MW_MONITOR_CTRL[63:32]                    |
    --           +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    -- Addr=0xC8 |                     MW_MONITOR_COUNT[31:00]                   |
    --           +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    -- Addr=0xCC |                     MW_MONITOR_COUNT[63:32]                   |
    --           +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    -- Addr=0xD0 |                     MW_MONITOR_ADDR[31:00]                    |
    --           +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    -- Addr=0xD4 |                     MW_MONITOR_ADDR[63:32]                    |
    --           +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    -- Addr=0xD8 |                     MW_MONITOR_AVAL[31:00]                    |
    --           +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    -- Addr=0xDC |                     MW_MONITOR_AVAL[63:32]                    |
    --           +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    -- Addr=0xE0 |                     MW_MONITOR_ARDY[31:00]                    |
    --           +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    -- Addr=0xE4 |                     MW_MONITOR_ARDY[63:32]                    |
    --           +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    -- Addr=0xE8 |                     MW_MONITOR_DATA[31:00]                    |
    --           +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    -- Addr=0xEC |                     MW_MONITOR_DATA[63:32]                    |
    --           +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    -- Addr=0xF0 |                     MW_MONITOR_DVAL[31:00]                    |
    --           +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    -- Addr=0xF4 |                     MW_MONITOR_DVAL[63:32]                    |
    --           +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    -- Addr=0xF8 |                     MW_MONITOR_DRDY[31:00]                    |
    --           +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    -- Addr=0xFC |                     MW_MONITOR_DRDY[63:32]                    |
    --           +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    -------------------------------------------------------------------------------
    constant  MW_MONITOR_CTRL_ADDR       :  integer := 16#C0#;
    constant  MW_MONITOR_CTRL_BITS       :  integer := 64;
    constant  MW_MONITOR_CTRL_LO         :  integer := 8*MW_MONITOR_CTRL_ADDR;
    constant  MW_MONITOR_CTRL_HI         :  integer := 8*MW_MONITOR_CTRL_ADDR  + MW_MONITOR_CTRL_BITS -1;
    constant  MW_MONITOR_RESET_POS       :  integer := 8*MW_MONITOR_CTRL_ADDR  + 63;
    constant  MW_MONITOR_COUNT_ADDR      :  integer := 16#C8#;
    constant  MW_MONITOR_COUNT_BITS      :  integer := 64;
    constant  MW_MONITOR_COUNT_LO        :  integer := 8*MW_MONITOR_COUNT_ADDR;
    constant  MW_MONITOR_COUNT_HI        :  integer := 8*MW_MONITOR_COUNT_ADDR + MW_MONITOR_COUNT_BITS-1;
    constant  MW_MONITOR_ADDR_ADDR       :  integer := 16#D0#;
    constant  MW_MONITOR_ADDR_BITS       :  integer := 64;
    constant  MW_MONITOR_ADDR_LO         :  integer := 8*MW_MONITOR_ADDR_ADDR;
    constant  MW_MONITOR_ADDR_HI         :  integer := 8*MW_MONITOR_ADDR_ADDR  + MW_MONITOR_ADDR_BITS -1;
    constant  MW_MONITOR_AVAL_ADDR       :  integer := 16#D8#;
    constant  MW_MONITOR_AVAL_BITS       :  integer := 64;
    constant  MW_MONITOR_AVAL_LO         :  integer := 8*MW_MONITOR_AVAL_ADDR;
    constant  MW_MONITOR_AVAL_HI         :  integer := 8*MW_MONITOR_AVAL_ADDR  + MW_MONITOR_AVAL_BITS -1;
    constant  MW_MONITOR_ARDY_ADDR       :  integer := 16#E0#;
    constant  MW_MONITOR_ARDY_BITS       :  integer := 64;
    constant  MW_MONITOR_ARDY_LO         :  integer := 8*MW_MONITOR_ARDY_ADDR;
    constant  MW_MONITOR_ARDY_HI         :  integer := 8*MW_MONITOR_ARDY_ADDR  + MW_MONITOR_ARDY_BITS -1;
    constant  MW_MONITOR_DATA_ADDR       :  integer := 16#E8#;
    constant  MW_MONITOR_DATA_BITS       :  integer := 64;
    constant  MW_MONITOR_DATA_LO         :  integer := 8*MW_MONITOR_DATA_ADDR;
    constant  MW_MONITOR_DATA_HI         :  integer := 8*MW_MONITOR_DATA_ADDR  + MW_MONITOR_DATA_BITS -1;
    constant  MW_MONITOR_DVAL_ADDR       :  integer := 16#F0#;
    constant  MW_MONITOR_DVAL_BITS       :  integer := 64;
    constant  MW_MONITOR_DVAL_LO         :  integer := 8*MW_MONITOR_DVAL_ADDR;
    constant  MW_MONITOR_DVAL_HI         :  integer := 8*MW_MONITOR_DVAL_ADDR  + MW_MONITOR_DVAL_BITS -1;
    constant  MW_MONITOR_DRDY_ADDR       :  integer := 16#F8#;
    constant  MW_MONITOR_DRDY_BITS       :  integer := 64;
    constant  MW_MONITOR_DRDY_LO         :  integer := 8*MW_MONITOR_DRDY_ADDR;
    constant  MW_MONITOR_DRDY_HI         :  integer := 8*MW_MONITOR_DRDY_ADDR  + MW_MONITOR_DRDY_BITS -1;
begin
    -------------------------------------------------------------------------------
    -- 
    -------------------------------------------------------------------------------
    RST <= '1' when (ARESETn = '0') else '0';
    -------------------------------------------------------------------------------
    -- 
    -------------------------------------------------------------------------------
    CSR_IF: block
        constant sig_1          : std_logic := '1';
        signal   regs_req       : std_logic;
        signal   regs_write     : std_logic;
        signal   regs_ack       : std_logic;
        signal   regs_err       : std_logic;
        signal   regs_addr      : std_logic_vector(REGS_ADDR_WIDTH  -1 downto 0);
        signal   regs_ben       : std_logic_vector(REGS_DATA_WIDTH/8-1 downto 0);
        signal   regs_wdata     : std_logic_vector(REGS_DATA_WIDTH  -1 downto 0);
        signal   regs_rdata     : std_logic_vector(REGS_DATA_WIDTH  -1 downto 0);
    begin 
        ---------------------------------------------------------------------------
        --
        ---------------------------------------------------------------------------
        AXI4: AXI4_REGISTER_INTERFACE                  --
            generic map (                              -- 
                AXI4_ADDR_WIDTH => C_ADDR_WIDTH      , --
                AXI4_DATA_WIDTH => C_DATA_WIDTH      , --
                AXI4_ID_WIDTH   => C_ID_WIDTH        , --
                REGS_ADDR_WIDTH => REGS_ADDR_WIDTH   , --
                REGS_DATA_WIDTH => REGS_DATA_WIDTH     --
            )                                          -- 
            port map (                                 -- 
            -----------------------------------------------------------------------
            -- Clock and Reset Signals.
            -----------------------------------------------------------------------
                CLK             => ACLK              , -- In  :
                RST             => RST               , -- In  :
                CLR             => CLR               , -- In  :
            -----------------------------------------------------------------------
            -- AXI4 Read Address Channel Signals.
            -----------------------------------------------------------------------
                ARID            => C_ARID            , -- In  :
                ARADDR          => C_ARADDR          , -- In  :
                ARLEN           => C_ARLEN           , -- In  :
                ARSIZE          => C_ARSIZE          , -- In  :
                ARBURST         => C_ARBURST         , -- In  :
                ARVALID         => C_ARVALID         , -- In  :
                ARREADY         => C_ARREADY         , -- Out :
            -----------------------------------------------------------------------
            -- AXI4 Read Data Channel Signals.
            -----------------------------------------------------------------------
                RID             => C_RID             , -- Out :
                RDATA           => C_RDATA           , -- Out :
                RRESP           => C_RRESP           , -- Out :
                RLAST           => C_RLAST           , -- Out :
                RVALID          => C_RVALID          , -- Out :
                RREADY          => C_RREADY          , -- In  :
            -----------------------------------------------------------------------
            -- AXI4 Write Address Channel Signals.
            -----------------------------------------------------------------------
                AWID            => C_AWID            , -- In  :
                AWADDR          => C_AWADDR          , -- In  :
                AWLEN           => C_AWLEN           , -- In  :
                AWSIZE          => C_AWSIZE          , -- In  :
                AWBURST         => C_AWBURST         , -- In  :
                AWVALID         => C_AWVALID         , -- In  :
                AWREADY         => C_AWREADY         , -- Out :
            -----------------------------------------------------------------------
            -- AXI4 Write Data Channel Signals.
            -----------------------------------------------------------------------
                WDATA           => C_WDATA           , -- In  :
                WSTRB           => C_WSTRB           , -- In  :
                WLAST           => C_WLAST           , -- In  :
                WVALID          => C_WVALID          , -- In  :
                WREADY          => C_WREADY          , -- Out :
            -----------------------------------------------------------------------
            -- AXI4 Write Response Channel Signals.
            -----------------------------------------------------------------------
                BID             => C_BID             , -- Out :
                BRESP           => C_BRESP           , -- Out :
                BVALID          => C_BVALID          , -- Out :
                BREADY          => C_BREADY          , -- In  :
            -----------------------------------------------------------------------
            -- Register Interface.
            -----------------------------------------------------------------------
                REGS_REQ        => regs_req          , -- Out :
                REGS_WRITE      => regs_write        , -- Out :
                REGS_ACK        => regs_ack          , -- In  :
                REGS_ERR        => regs_err          , -- In  :
                REGS_ADDR       => regs_addr         , -- Out :
                REGS_BEN        => regs_ben          , -- Out :
                REGS_WDATA      => regs_wdata        , -- Out :
                REGS_RDATA      => regs_rdata          -- In  :
            );
        ---------------------------------------------------------------------------
        -- 
        ---------------------------------------------------------------------------
        DEC: REGISTER_ACCESS_ADAPTER                   -- 
            generic map (                              -- 
                ADDR_WIDTH      => REGS_ADDR_WIDTH   , -- 
                DATA_WIDTH      => REGS_DATA_WIDTH   , -- 
                WBIT_MIN        => regs_wbit'low     , -- 
                WBIT_MAX        => regs_wbit'high    , -- 
                RBIT_MIN        => regs_rbit'low     , -- 
                RBIT_MAX        => regs_rbit'high    , -- 
                I_CLK_RATE      => 1                 , -- 
                O_CLK_RATE      => 1                 , -- 
                O_CLK_REGS      => 0                   -- 
            )                                          -- 
            port map (                                 -- 
                RST             => RST               , -- In  :
                I_CLK           => ACLK              , -- In  :
                I_CLR           => CLR               , -- In  :
                I_CKE           => sig_1             , -- In  :
                I_REQ           => regs_req          , -- In  :
                I_SEL           => sig_1             , -- In  :
                I_WRITE         => regs_write        , -- In  :
                I_ADDR          => regs_addr         , -- In  :
                I_BEN           => regs_ben          , -- In  :
                I_WDATA         => regs_wdata        , -- In  :
                I_RDATA         => regs_rdata        , -- Out :
                I_ACK           => regs_ack          , -- Out :
                I_ERR           => regs_err          , -- Out :
                O_CLK           => ACLK              , -- In  :
                O_CLR           => CLR               , -- In  :
                O_CKE           => sig_1             , -- In  :
                O_WDATA         => regs_wbit         , -- Out :
                O_WLOAD         => regs_load         , -- Out :
                O_RDATA         => regs_rbit           -- In  :
            );                                         -- 
        ---------------------------------------------------------------------------
        -- 
        ---------------------------------------------------------------------------
        regs_rbit(VERSION_REGS_HI   downto VERSION_REGS_LO  ) <= VERSION_REGS_DATA;
        regs_rbit(MR_PARAM_REGS_HI  downto MR_PARAM_REGS_LO ) <= MR_PARAM_REGS_DATA;
        regs_rbit(MW_PARAM_REGS_HI  downto MW_PARAM_REGS_LO ) <= MW_PARAM_REGS_DATA;
        regs_rbit(RESERVED_REGS_HI  downto RESERVED_REGS_LO ) <= RESERVED_REGS_DATA;
    end block;
    -------------------------------------------------------------------------------
    -- Master Write Block
    -------------------------------------------------------------------------------
    MW: block
        constant  REQ_ADDR_BITS     :  integer := M_ADDR_WIDTH;
        constant  REQ_SIZE_VALID    :  integer :=  1;
        constant  REQ_SIZE_BITS     :  integer := 32;
        constant  WORD_BITS         :  integer := 32;
        constant  BUF_DEPTH         :  integer := MW_MAX_XFER_SIZE;
        constant  BUF_WIDTH         :  integer := M_DATA_WIDTH;
        constant  REQ_ID            :  std_logic_vector(M_ID_WIDTH   -1 downto 0)
                                    := std_logic_vector(to_unsigned(M_AXI_ID    , M_ID_WIDTH));
        constant  REQ_LOCK          :  AXI4_ALOCK_TYPE  := (others => '0');
        constant  REQ_QOS           :  AXI4_AQOS_TYPE   := (others => '0');
        constant  REQ_REGION        :  AXI4_AREGION_TYPE:= (others => '0');
        constant  FLOW_READY_LEVEL  :  std_logic_vector(BUF_DEPTH downto 0)
                                    := std_logic_vector(to_unsigned(2**MW_MAX_XFER_SIZE, BUF_DEPTH+1));
        constant  BUF_READY_LEVEL   :  std_logic_vector(BUF_DEPTH downto 0)
                                    := std_logic_vector(to_unsigned(2*(M_DATA_WIDTH/8) , BUF_DEPTH+1));
        signal    i_awvalid         :  std_logic;
        signal    i_awready         :  std_logic;
        signal    i_wvalid          :  std_logic;
        signal    i_wready          :  std_logic;
        signal    req_valid         :  std_logic;
        signal    req_addr          :  std_logic_vector(REQ_ADDR_BITS-1 downto 0);
        signal    req_size          :  std_logic_vector(REQ_SIZE_BITS-1 downto 0);
        signal    req_buf_ptr       :  std_logic_vector(BUF_DEPTH    -1 downto 0);
        signal    req_speculative   :  std_logic;
        signal    req_safety        :  std_logic;
        signal    req_cache         :  AXI4_ACACHE_TYPE;
        signal    req_prot          :  AXI4_APROT_TYPE;
        signal    req_first         :  std_logic;
        signal    req_last          :  std_logic;
        signal    req_none          :  std_logic;
        signal    req_ready         :  std_logic;
        signal    ack_valid         :  std_logic;
        signal    ack_size          :  std_logic_vector(BUF_DEPTH       downto 0);
        signal    ack_error         :  std_logic;
        signal    ack_next          :  std_logic;
        signal    ack_last          :  std_logic;
        signal    ack_stop          :  std_logic;
        signal    ack_none          :  std_logic;
        signal    xfer_busy         :  std_logic;
        signal    xfer_done         :  std_logic;
        signal    xfer_error        :  std_logic;
        signal    flow_ready        :  std_logic;
        signal    flow_pause        :  std_logic;
        signal    flow_stop         :  std_logic;
        signal    flow_last         :  std_logic;
        signal    flow_size         :  std_logic_vector(BUF_DEPTH       downto 0);
        signal    pull_fin_valid    :  std_logic;
        signal    pull_fin_last     :  std_logic;
        signal    pull_fin_error    :  std_logic;
        signal    pull_fin_size     :  std_logic_vector(BUF_DEPTH       downto 0);
        signal    pull_buf_reset    :  std_logic;
        signal    pull_buf_valid    :  std_logic;
        signal    pull_buf_last     :  std_logic;
        signal    pull_buf_error    :  std_logic;
        signal    pull_buf_size     :  std_logic_vector(BUF_DEPTH       downto 0);
        signal    pull_buf_ready    :  std_logic;
        signal    valve_open        :  std_logic;
        signal    buf_ren           :  std_logic;
        signal    buf_rptr          :  std_logic_vector(BUF_DEPTH    -1 downto 0);
        signal    buf_rdata         :  std_logic_vector(BUF_WIDTH    -1 downto 0);
    begin
        ---------------------------------------------------------------------------
        -- Master Write AXI I/F
        ---------------------------------------------------------------------------
        AXI_IF: AXI4_MASTER_WRITE_INTERFACE                -- 
            generic map (                                  -- 
                AXI4_ADDR_WIDTH     => M_ADDR_WIDTH      , -- 
                AXI4_DATA_WIDTH     => M_DATA_WIDTH      , --   
                AXI4_ID_WIDTH       => M_ID_WIDTH        , --   
                VAL_BITS            => 1                 , --   
                REQ_SIZE_BITS       => REQ_SIZE_BITS     , --   
                REQ_SIZE_VALID      => REQ_SIZE_VALID    , --   
                FLOW_VALID          => 1                 , --   
                FLOW_SIZE_VALID     => 0                 , --   
                BUF_DATA_WIDTH      => BUF_WIDTH         , --   
                BUF_PTR_BITS        => BUF_DEPTH         , --   
                ALIGNMENT_BITS      => WORD_BITS         , --   
                XFER_SIZE_BITS      => BUF_DEPTH+1       , --   
                XFER_MIN_SIZE       => MW_MAX_XFER_SIZE   , --   
                XFER_MAX_SIZE       => MW_MAX_XFER_SIZE   , --   
                QUEUE_SIZE          => MW_QUEUE_SIZE     , --   
                REQ_REGS            => MW_REQ_REGS       , --   
                ACK_REGS            => MW_ACK_REGS       , --   
                RESP_REGS           => MW_RESP_REGS      , --
                WDATA_PIPELINE      => MW_DATA_PIPELINE    -- 
            )                                              -- 
            port map(                                      --
            -----------------------------------------------------------------------
            -- Clock and Reset Signals.
            -----------------------------------------------------------------------
                CLK                 => ACLK              , -- In  :
                RST                 => RST               , -- In  :
                CLR                 => CLR               , -- In  :
            -----------------------------------------------------------------------
            -- AXI4 Write Address Channel Signals.
            -----------------------------------------------------------------------
                AWID                => M_AWID            , -- Out :
                AWADDR              => M_AWADDR          , -- Out :
                AWLEN               => M_AWLEN           , -- Out :
                AWSIZE              => M_AWSIZE          , -- Out :
                AWBURST             => M_AWBURST         , -- Out :
                AWLOCK              => M_AWLOCK          , -- Out :
                AWCACHE             => M_AWCACHE         , -- Out :
                AWPROT              => M_AWPROT          , -- Out :
                AWQOS               => M_AWQOS           , -- Out :
                AWREGION            => M_AWREGION        , -- Out :
                AWVALID             => i_awvalid         , -- Out :
                AWREADY             => i_awready         , -- In  :
            -----------------------------------------------------------------------
            -- AXI4 Write Data Channel Signals.
            -----------------------------------------------------------------------
                WID                 => M_WID             , -- Out :
                WDATA               => M_WDATA           , -- Out :
                WSTRB               => M_WSTRB           , -- Out :
                WLAST               => M_WLAST           , -- Out :
                WVALID              => i_wvalid          , -- Out :
                WREADY              => i_wready          , -- In  :
            -----------------------------------------------------------------------
            -- AXI4 Write Response Channel Signals.
            -----------------------------------------------------------------------
                BID                 => M_BID             , -- In  :
                BRESP               => M_BRESP           , -- In  :
                BVALID              => M_BVALID          , -- In  :
                BREADY              => M_BREADY          , -- Out :
            -----------------------------------------------------------------------
            -- Command Request Signals.
            -----------------------------------------------------------------------
                REQ_ADDR            => req_addr          , -- In  :
                REQ_SIZE            => req_size          , -- In  :
                REQ_ID              => REQ_ID            , -- In  :
                REQ_BURST           => AXI4_ABURST_INCR  , -- In  :
                REQ_LOCK            => REQ_LOCK          , -- In  :
                REQ_CACHE           => req_cache         , -- In  :
                REQ_PROT            => req_prot          , -- In  :
                REQ_QOS             => REQ_QOS           , -- In  :
                REQ_REGION          => REQ_REGION        , -- In  :
                REQ_BUF_PTR         => req_buf_ptr       , -- In  :
                REQ_FIRST           => req_first         , -- In  :
                REQ_LAST            => req_last          , -- In  :
                REQ_SPECULATIVE     => req_speculative   , -- In  :
                REQ_SAFETY          => req_safety        , -- In  :
                REQ_VAL(0)          => req_valid         , -- In  :
                REQ_RDY             => req_ready         , -- Out :
            -----------------------------------------------------------------------
            -- Command Acknowledge Signals.
            -----------------------------------------------------------------------
                ACK_VAL(0)          => ack_valid         , -- Out :
                ACK_NEXT            => ack_next          , -- Out :
                ACK_LAST            => ack_last          , -- Out :
                ACK_ERROR           => ack_error         , -- Out :
                ACK_STOP            => ack_stop          , -- Out :
                ACK_NONE            => ack_none          , -- Out :
                ACK_SIZE            => ack_size          , -- Out :
            -----------------------------------------------------------------------
            -- Transfer Status Signal.
            -----------------------------------------------------------------------
                XFER_BUSY(0)        => xfer_busy         , -- Out :
                XFER_ERROR(0)       => xfer_error        , -- Out :
                XFER_DONE(0)        => xfer_done         , -- Out :
            -----------------------------------------------------------------------
            -- Flow Control Signals.
            -----------------------------------------------------------------------
                FLOW_STOP           => flow_stop         , -- In  :
                FLOW_PAUSE          => flow_pause        , -- In  :
                FLOW_LAST           => flow_last         , -- In  :
                FLOW_SIZE           => flow_size         , -- In  :
            -----------------------------------------------------------------------
            -- Pull Final Size Signals.
            -----------------------------------------------------------------------
                PULL_FIN_VAL(0)     => pull_fin_valid    , -- Out :
                PULL_FIN_LAST       => pull_fin_last     , -- Out :
                PULL_FIN_ERROR      => pull_fin_error    , -- Out :
                PULL_FIN_SIZE       => pull_fin_size     , -- Out :
            -----------------------------------------------------------------------
            -- Pull Buffer Size Signals.
            -----------------------------------------------------------------------
                PULL_BUF_RESET(0)   => pull_buf_reset    , -- Out :
                PULL_BUF_VAL(0)     => pull_buf_valid    , -- Out :
                PULL_BUF_LAST       => pull_buf_last     , -- Out :
                PULL_BUF_ERROR      => pull_buf_error    , -- Out :
                PULL_BUF_SIZE       => pull_buf_size     , -- Out :
                PULL_BUF_RDY(0)     => pull_buf_ready    , -- In  :
            -----------------------------------------------------------------------
            -- Read Buffer Interface Signals.
            -----------------------------------------------------------------------
                BUF_REN(0)          => buf_ren           , -- Out :
                BUF_DATA            => buf_rdata         , -- In  :
                BUF_PTR             => buf_rptr            -- Out :
            );                                             --
        M_AWVALID <= i_awvalid;
        i_awready <= M_AWREADY;
        M_WVALID  <= i_wvalid;
        i_wready  <= M_WREADY;
        ---------------------------------------------------------------------------
        -- Master Write Controller
        ---------------------------------------------------------------------------
        CTRL: PUMP_CONTROLLER_OUTLET_SIDE                  -- 
            generic map (                                  -- 
                REQ_ADDR_BITS       => REQ_ADDR_BITS     , --   
                REG_ADDR_BITS       => MW_ADDR_REGS_BITS , --   
                REQ_SIZE_VALID      => REQ_SIZE_VALID    , --   
                REQ_SIZE_BITS       => REQ_SIZE_BITS     , --   
                REG_SIZE_BITS       => MW_SIZE_REGS_BITS , --   
                REG_MODE_BITS       => MW_MODE_REGS_BITS , --   
                REG_STAT_BITS       => MW_STAT_RESV_BITS , --   
                FIXED_FLOW_OPEN     => 1                 , --   
                FIXED_POOL_OPEN     => 1                 , --   
                USE_PULL_BUF_SIZE   => 0                 , --   
                USE_PUSH_RSV_SIZE   => 0                 , --   
                BUF_DEPTH           => BUF_DEPTH           --   
            )                                              -- 
            port map (                                     -- 
            -----------------------------------------------------------------------
            -- Clock/Reset Signals.
            -----------------------------------------------------------------------
                CLK                 => ACLK              , -- In  :
                RST                 => RST               , -- In  :
                CLR                 => CLR               , -- In  :
            -----------------------------------------------------------------------
            -- Outlet Control Status Register Interface.
            -----------------------------------------------------------------------
                REG_ADDR_L          => regs_load(MW_ADDR_REGS_HI downto MW_ADDR_REGS_LO), --  In  :
                REG_ADDR_D          => regs_wbit(MW_ADDR_REGS_HI downto MW_ADDR_REGS_LO), --  In  :
                REG_ADDR_Q          => regs_rbit(MW_ADDR_REGS_HI downto MW_ADDR_REGS_LO), --  Out :
                REG_SIZE_L          => regs_load(MW_SIZE_REGS_HI downto MW_SIZE_REGS_LO), --  In  :
                REG_SIZE_D          => regs_wbit(MW_SIZE_REGS_HI downto MW_SIZE_REGS_LO), --  In  :
                REG_SIZE_Q          => regs_rbit(MW_SIZE_REGS_HI downto MW_SIZE_REGS_LO), --  Out :
                REG_MODE_L          => regs_load(MW_MODE_REGS_HI downto MW_MODE_REGS_LO), --  In  :
                REG_MODE_D          => regs_wbit(MW_MODE_REGS_HI downto MW_MODE_REGS_LO), --  In  :
                REG_MODE_Q          => regs_rbit(MW_MODE_REGS_HI downto MW_MODE_REGS_LO), --  Out :
                REG_STAT_L          => regs_load(MW_STAT_RESV_HI downto MW_STAT_RESV_LO), --  In  :
                REG_STAT_D          => regs_wbit(MW_STAT_RESV_HI downto MW_STAT_RESV_LO), --  In  :
                REG_STAT_Q          => regs_rbit(MW_STAT_RESV_HI downto MW_STAT_RESV_LO), --  Out :
                REG_STAT_I          => MW_STAT_RESV_NULL                                , --  In  :
                REG_RESET_L         => regs_load(MW_CTRL_RESET_POS)                     , --  In  :
                REG_RESET_D         => regs_wbit(MW_CTRL_RESET_POS)                     , --  In  :
                REG_RESET_Q         => regs_rbit(MW_CTRL_RESET_POS)                     , --  Out :
                REG_START_L         => regs_load(MW_CTRL_START_POS)                     , --  In  :
                REG_START_D         => regs_wbit(MW_CTRL_START_POS)                     , --  In  :
                REG_START_Q         => regs_rbit(MW_CTRL_START_POS)                     , --  Out :
                REG_STOP_L          => regs_load(MW_CTRL_STOP_POS )                     , --  In  :
                REG_STOP_D          => regs_wbit(MW_CTRL_STOP_POS )                     , --  In  :
                REG_STOP_Q          => regs_rbit(MW_CTRL_STOP_POS )                     , --  Out :
                REG_PAUSE_L         => regs_load(MW_CTRL_PAUSE_POS)                     , --  In  :
                REG_PAUSE_D         => regs_wbit(MW_CTRL_PAUSE_POS)                     , --  In  :
                REG_PAUSE_Q         => regs_rbit(MW_CTRL_PAUSE_POS)                     , --  Out :
                REG_FIRST_L         => regs_load(MW_CTRL_FIRST_POS)                     , --  In  :
                REG_FIRST_D         => regs_wbit(MW_CTRL_FIRST_POS)                     , --  In  :
                REG_FIRST_Q         => regs_rbit(MW_CTRL_FIRST_POS)                     , --  Out :
                REG_LAST_L          => regs_load(MW_CTRL_LAST_POS )                     , --  In  :
                REG_LAST_D          => regs_wbit(MW_CTRL_LAST_POS )                     , --  In  :
                REG_LAST_Q          => regs_rbit(MW_CTRL_LAST_POS )                     , --  Out :
                REG_DONE_EN_L       => regs_load(MW_CTRL_DONE_POS )                     , --  In  :
                REG_DONE_EN_D       => regs_wbit(MW_CTRL_DONE_POS )                     , --  In  :
                REG_DONE_EN_Q       => regs_rbit(MW_CTRL_DONE_POS )                     , --  Out :
                REG_DONE_ST_L       => regs_load(MW_STAT_DONE_POS )                     , --  In  :
                REG_DONE_ST_D       => regs_wbit(MW_STAT_DONE_POS )                     , --  In  :
                REG_DONE_ST_Q       => regs_rbit(MW_STAT_DONE_POS )                     , --  Out :
                REG_ERR_ST_L        => regs_load(MW_STAT_ERROR_POS)                     , --  In  :
                REG_ERR_ST_D        => regs_wbit(MW_STAT_ERROR_POS)                     , --  In  :
                REG_ERR_ST_Q        => regs_rbit(MW_STAT_ERROR_POS)                     , --  Out :
            -----------------------------------------------------------------------
            -- Outlet Configuration Signals.
            -----------------------------------------------------------------------
                BUF_READY_LEVEL     => BUF_READY_LEVEL   , -- In  :
                FLOW_READY_LEVEL    => FLOW_READY_LEVEL  , -- In  :
            -----------------------------------------------------------------------
            -- Outlet Transaction Command Request Signals.
            -----------------------------------------------------------------------
                REQ_VALID           => req_valid         , -- Out :
                REQ_ADDR            => req_addr          , -- Out :
                REQ_SIZE            => req_size          , -- Out :
                REQ_BUF_PTR         => req_buf_ptr       , -- Out :
                REQ_FIRST           => req_first         , -- Out :
                REQ_LAST            => req_last          , -- Out :
                REQ_NONE            => req_none          , -- Out :
                REQ_READY           => req_ready         , -- In  :
            -----------------------------------------------------------------------
            -- Outlet Transaction Command Acknowledge Signals.
            -----------------------------------------------------------------------
                ACK_VALID           => ack_valid         , -- In  :
                ACK_SIZE            => ack_size          , -- In  :
                ACK_ERROR           => ack_error         , -- In  :
                ACK_NEXT            => ack_next          , -- In  :
                ACK_LAST            => ack_last          , -- In  :
                ACK_STOP            => ack_stop          , -- In  :
                ACK_NONE            => ack_none          , -- In  :
            -----------------------------------------------------------------------
            -- Outlet Transfer Status Signals.
            -----------------------------------------------------------------------
                XFER_BUSY           => xfer_busy         , -- In  :
                XFER_DONE           => xfer_done         , -- In  :
                XFER_ERROR          => xfer_error        , -- In  :
            -----------------------------------------------------------------------
            -- Outlet Flow Control Signals.
            -----------------------------------------------------------------------
                FLOW_READY          => flow_ready        , -- Out :
                FLOW_PAUSE          => flow_pause        , -- Out :
                FLOW_STOP           => flow_stop         , -- Out :
                FLOW_LAST           => flow_last         , -- Out :
                FLOW_SIZE           => flow_size         , -- Out :
                PULL_FIN_VALID      => pull_fin_valid    , -- In  :
                PULL_FIN_LAST       => pull_fin_last     , -- In  :
                PULL_FIN_ERROR      => pull_fin_error    , -- In  :
                PULL_FIN_SIZE       => pull_fin_size     , -- In  :
                PULL_BUF_RESET      => pull_buf_reset    , -- In  :
                PULL_BUF_VALID      => pull_buf_valid    , -- In  :
                PULL_BUF_LAST       => pull_buf_last     , -- In  :
                PULL_BUF_ERROR      => pull_buf_error    , -- In  :
                PULL_BUF_SIZE       => pull_buf_size     , -- In  :
                PULL_BUF_READY      => pull_buf_ready    , -- Out :
            -----------------------------------------------------------------------
            -- Intake Status Input.
            -----------------------------------------------------------------------
                I_OPEN              => valve_open        , -- In  :
            -----------------------------------------------------------------------
            -- Outlet Status Output.
            -----------------------------------------------------------------------
                O_OPEN              => valve_open        , -- Out :
            -----------------------------------------------------------------------
            -- Transaction Status Signals.
            -----------------------------------------------------------------------
                TRAN_BUSY           => open              , -- Out :
                TRAN_DONE           => open              , -- Out :
                TRAN_NONE           => open              , -- Out :
                TRAN_ERROR          => open                -- Out :
            );
        ---------------------------------------------------------------------------
        -- request transaction mode
        ---------------------------------------------------------------------------
        M_AWUSER        <= (others => '0');
        req_speculative <= regs_rbit(MW_MODE_SPECUL_POS);
        req_safety      <= regs_rbit(MW_MODE_SAFETY_POS);
        req_prot        <= regs_rbit(MW_MODE_PROT_HI  downto MW_MODE_PROT_LO );
        req_cache       <= regs_rbit(MW_MODE_CACHE_HI downto MW_MODE_CACHE_LO);
        ---------------------------------------------------------------------------
        -- regs_rbit
        ---------------------------------------------------------------------------
        regs_rbit(MW_CTRL_RESV_POS) <= '0';
        ---------------------------------------------------------------------------
        -- buf_rdata
        ---------------------------------------------------------------------------
        DATA: block
            constant  WORD_BYTES  :  integer := WORD_BITS/8;
            constant  WORDS       :  integer := BUF_WIDTH/WORD_BITS;
            constant  WORD_LO_LEN :  integer := CALC_BITS(WORDS);
            constant  WORD_LO     :  std_logic_vector(WORD_LO_LEN-1 downto 0)
                                  := (others => '0');
            constant  WORD_HI     :  std_logic_vector(WORD_BITS  -1 downto WORD_LO_LEN)
                                  := (others => '0');
            signal    curr_word   :  unsigned(WORD_BITS-1 downto 0);
        begin
            process (ACLK, RST)
                variable next_word :  unsigned(WORD_BITS-1 downto 0);
                variable word_data :  unsigned(WORD_BITS-1 downto 0);
            begin
                if (RST = '1') then
                        curr_word <= (others => '0');
                        buf_rdata <= (others => '0');
                elsif (ACLK'event and ACLK = '1') then
                    if (CLR = '1') then
                        curr_word <= (others => '0');
                        buf_rdata <= (others => '0');
                    else
                        if (pull_buf_valid = '1') then
                            next_word := curr_word + (unsigned(pull_buf_size)/WORD_BYTES);
                        else
                            next_word := curr_word;
                        end if;
                        if (valve_open = '1') then
                            curr_word <= next_word;
                        else
                            curr_word <= (others => '0');
                        end if;
                        if (WORDS > 1) then
                            for i in 0 to WORDS-1 loop
                                word_data(WORD_LO'range) := to_unsigned(i,WORD_LO'length);
                                word_data(WORD_HI'range) := next_word(WORD_HI'range);
                                buf_rdata((i+1)*WORD_BITS-1 downto i*WORD_BITS) <= std_logic_vector(word_data);
                            end loop;
                        else
                            buf_rdata <= std_logic_vector(next_word);
                        end if;
                    end if;
                end if;
            end process;
        end block;
        ---------------------------------------------------------------------------
        -- MONITOR
        ---------------------------------------------------------------------------
        MONITOR: block
            constant  ctrl_regs   :  std_logic_vector(MW_MONITOR_CTRL_BITS-1 downto 0)
                                  := (others => '0');
            constant  reset_data  :  std_logic := '1';
            signal    reset_load  :  std_logic;
            constant  start_data  :  std_logic := '1';
            signal    start_load  :  std_logic;
            constant  stop_data   :  std_logic := '1';
            signal    stop_load   :  std_logic;
            constant  pause_data  :  std_logic := '0';
            constant  pause_load  :  std_logic := '0';
            signal    valve_regs  :  std_logic;
        begin
            ----------------------------------------------------------------------------
            -- 
            ----------------------------------------------------------------------------
            reset_load <= '1' when (regs_rbit(MW_CTRL_RESET_POS) = '1') or
                                   (regs_wbit(MW_MONITOR_RESET_POS) = '1' and
                                    regs_load(MW_MONITOR_RESET_POS) = '1' ) else '0';
            ----------------------------------------------------------------------------
            -- 
            ----------------------------------------------------------------------------
            process (ACLK, RST) begin 
                if (RST = '1') then
                        valve_regs <= '0';
                elsif (ACLK'event and ACLK = '1') then
                    if (CLR = '1') then
                        valve_regs <= '0';
                    else
                        valve_regs <= valve_open;
                    end if;
                end if;
            end process;
            start_load <= '1' when (valve_regs = '0' and valve_open = '1') else '0';
            stop_load  <= '1' when (valve_regs = '1' and valve_open = '0') else '0';
            ----------------------------------------------------------------------------
            -- 
            ----------------------------------------------------------------------------
            U: AXI4_TRAFFIC_MONITOR                        --
                generic map (                              --
                    ENABLE      => 1                     , --
                    COUNT_BITS  => 64                    , --
                    REGS_BITS   => 64                      --
                )                                          --
                port map (                                 --
                -----------------------------------------------------------------------
                -- Clock/Reset Signals.
                -----------------------------------------------------------------------
                    CLK         => ACLK                  , -- In  :
                    RST         => RST                   , -- In  :
                    CLR         => CLR                   , -- In  :
                -----------------------------------------------------------------------
                -- Control Signals.
                -----------------------------------------------------------------------
                    RESET_L     => reset_load            , -- In
                    RESET_D     => reset_data            , -- In
                    RESET_Q     => open                  , -- Out
                    START_L     => start_load            , -- In
                    START_D     => start_data            , -- In
                    START_Q     => open                  , -- Out
                    STOP_L      => stop_load             , -- In
                    STOP_D      => stop_data             , -- In
                    STOP_Q      => open                  , -- Out
                    PAUSE_L     => pause_load            , -- In
                    PAUSE_D     => pause_data            , -- In
                    PAUSE_Q     => open                  , -- Out
                ----------------------------------------------------------------------
                -- AXI4 Address Channel Signals.
                ----------------------------------------------------------------------
                    AVALID      => i_awvalid             , -- In
                    AREADY      => i_awready             , -- In
                ----------------------------------------------------------------------
                -- AXI4 Data Channel Signals.
                ----------------------------------------------------------------------
                    DVALID      => i_wvalid              , -- In
                    DREADY      => i_wready              , -- In
                ----------------------------------------------------------------------
                -- Monitor Output Registers.
                ----------------------------------------------------------------------
                    TOTAL_REGS  => regs_rbit(MW_MONITOR_COUNT_HI downto MW_MONITOR_COUNT_LO), 
                    ADDR_REGS   => regs_rbit(MW_MONITOR_ADDR_HI  downto MW_MONITOR_ADDR_LO ), 
                    AVALID_REGS => regs_rbit(MW_MONITOR_AVAL_HI  downto MW_MONITOR_AVAL_LO ), 
                    AREADY_REGS => regs_rbit(MW_MONITOR_ARDY_HI  downto MW_MONITOR_ARDY_LO ), 
                    DATA_REGS   => regs_rbit(MW_MONITOR_DATA_HI  downto MW_MONITOR_DATA_LO ), 
                    DVALID_REGS => regs_rbit(MW_MONITOR_DVAL_HI  downto MW_MONITOR_DVAL_LO ), 
                    DREADY_REGS => regs_rbit(MW_MONITOR_DRDY_HI  downto MW_MONITOR_DRDY_LO )
                );
            regs_rbit(MW_MONITOR_CTRL_HI  downto MW_MONITOR_CTRL_LO ) <= ctrl_regs;
        end block;
    end block;
    -------------------------------------------------------------------------------
    -- Master Read Block
    -------------------------------------------------------------------------------
    MR: block
        constant  REQ_ADDR_BITS     :  integer := M_ADDR_WIDTH;
        constant  REQ_SIZE_VALID    :  integer :=  1;
        constant  REQ_SIZE_BITS     :  integer := 32;
        constant  WORD_BITS         :  integer := 32;
        constant  BUF_DEPTH         :  integer := MR_MAX_XFER_SIZE;
        constant  BUF_WIDTH         :  integer := M_DATA_WIDTH;
        constant  REQ_ID            :  std_logic_vector(M_ID_WIDTH   -1 downto 0)
                                    := std_logic_vector(to_unsigned(M_AXI_ID   , M_ID_WIDTH));
        constant  REQ_LOCK          :  AXI4_ALOCK_TYPE  := (others => '0');
        constant  REQ_QOS           :  AXI4_AQOS_TYPE   := (others => '0');
        constant  REQ_REGION        :  AXI4_AREGION_TYPE:= (others => '0');
        constant  FLOW_READY_LEVEL  :  std_logic_vector(BUF_DEPTH downto 0)
                                    := std_logic_vector(to_unsigned(2**MR_MAX_XFER_SIZE, BUF_DEPTH+1));
        constant  BUF_READY_LEVEL   :  std_logic_vector(BUF_DEPTH downto 0)
                                    := std_logic_vector(to_unsigned(2*(M_DATA_WIDTH/8) , BUF_DEPTH+1));
        signal    i_arvalid         :  std_logic;
        signal    i_arready         :  std_logic;
        signal    i_rvalid          :  std_logic;
        signal    i_rready          :  std_logic;
        signal    req_valid         :  std_logic;
        signal    req_addr          :  std_logic_vector(REQ_ADDR_BITS-1 downto 0);
        signal    req_size          :  std_logic_vector(REQ_SIZE_BITS-1 downto 0);
        signal    req_buf_ptr       :  std_logic_vector(BUF_DEPTH    -1 downto 0);
        signal    req_speculative   :  std_logic;
        signal    req_safety        :  std_logic;
        signal    req_cache         :  AXI4_ACACHE_TYPE;
        signal    req_prot          :  AXI4_APROT_TYPE;
        signal    req_first         :  std_logic;
        signal    req_last          :  std_logic;
        signal    req_none          :  std_logic;
        signal    req_ready         :  std_logic;
        signal    ack_valid         :  std_logic;
        signal    ack_size          :  std_logic_vector(BUF_DEPTH       downto 0);
        signal    ack_error         :  std_logic;
        signal    ack_next          :  std_logic;
        signal    ack_last          :  std_logic;
        signal    ack_stop          :  std_logic;
        signal    ack_none          :  std_logic;
        signal    xfer_busy         :  std_logic;
        signal    xfer_done         :  std_logic;
        signal    xfer_error        :  std_logic;
        signal    flow_ready        :  std_logic;
        signal    flow_pause        :  std_logic;
        signal    flow_stop         :  std_logic;
        signal    flow_last         :  std_logic;
        signal    flow_size         :  std_logic_vector(BUF_DEPTH       downto 0);
        signal    push_fin_valid    :  std_logic;
        signal    push_fin_last     :  std_logic;
        signal    push_fin_error    :  std_logic;
        signal    push_fin_size     :  std_logic_vector(BUF_DEPTH       downto 0);
        signal    push_buf_reset    :  std_logic;
        signal    push_buf_valid    :  std_logic;
        signal    push_buf_last     :  std_logic;
        signal    push_buf_error    :  std_logic;
        signal    push_buf_size     :  std_logic_vector(BUF_DEPTH       downto 0);
        signal    push_buf_ready    :  std_logic;
        signal    valve_open        :  std_logic;
        signal    buf_wen           :  std_logic;
        signal    buf_ben           :  std_logic_vector(BUF_WIDTH/8  -1 downto 0);
        signal    buf_wdata         :  std_logic_vector(BUF_WIDTH    -1 downto 0);
        signal    buf_wptr          :  std_logic_vector(BUF_DEPTH    -1 downto 0);
    begin
        ---------------------------------------------------------------------------
        -- Master Read AXI I/F
        ---------------------------------------------------------------------------
        AXI_IF: AXI4_MASTER_READ_INTERFACE                 -- 
            generic map (                                  -- 
                AXI4_ADDR_WIDTH     => M_ADDR_WIDTH      , -- 
                AXI4_DATA_WIDTH     => M_DATA_WIDTH      , --   
                AXI4_ID_WIDTH       => M_ID_WIDTH        , --   
                VAL_BITS            => 1                 , --   
                REQ_SIZE_BITS       => REQ_SIZE_BITS     , --   
                REQ_SIZE_VALID      => REQ_SIZE_VALID    , --   
                FLOW_VALID          => 1                 , --   
                FLOW_SIZE_VALID     => 0                 , --   
                BUF_DATA_WIDTH      => BUF_WIDTH         , --   
                BUF_PTR_BITS        => BUF_DEPTH         , --   
                ALIGNMENT_BITS      => WORD_BITS         , --   
                XFER_SIZE_BITS      => BUF_DEPTH+1       , --   
                XFER_MIN_SIZE       => MW_MAX_XFER_SIZE  , --   
                XFER_MAX_SIZE       => MW_MAX_XFER_SIZE  , --   
                QUEUE_SIZE          => MR_QUEUE_SIZE     , --   
                RDATA_REGS          => MR_DATA_REGS      , --   
                ACK_REGS            => MR_ACK_REGS       , --
                RDATA_PIPELINE      => MR_DATA_PIPELINE    --
            )                                              -- 
            port map(                                      --
            -----------------------------------------------------------------------
            -- Clock and Reset Signals.
            -----------------------------------------------------------------------
                CLK                 => ACLK              , -- In  :
                RST                 => RST               , -- In  :
                CLR                 => CLR               , -- In  :
            -----------------------------------------------------------------------
            -- AXI4 Read Address Channel Signals.
            -----------------------------------------------------------------------
                ARID                => M_ARID            , -- Out :
                ARADDR              => M_ARADDR          , -- Out :
                ARLEN               => M_ARLEN           , -- Out :
                ARSIZE              => M_ARSIZE          , -- Out :
                ARBURST             => M_ARBURST         , -- Out :
                ARLOCK              => M_ARLOCK          , -- Out :
                ARCACHE             => M_ARCACHE         , -- Out :
                ARPROT              => M_ARPROT          , -- Out :
                ARQOS               => M_ARQOS           , -- Out :
                ARREGION            => M_ARREGION        , -- Out :
                ARVALID             => i_arvalid         , -- Out :
                ARREADY             => i_arready         , -- In  :
            -----------------------------------------------------------------------
            -- AXI4 Read Data Channel Signals.
            -----------------------------------------------------------------------
                RID                 => M_RID             , -- In  :
                RDATA               => M_RDATA           , -- In  :
                RRESP               => M_RRESP           , -- In  :
                RLAST               => M_RLAST           , -- In  :
                RVALID              => i_rvalid          , -- In  :
                RREADY              => i_rready          , -- Out :
            -----------------------------------------------------------------------
            -- Command Request Signals.
            -----------------------------------------------------------------------
                REQ_ADDR            => req_addr          , -- In  :
                REQ_SIZE            => req_size          , -- In  :
                REQ_ID              => REQ_ID            , -- In  :
                REQ_BURST           => AXI4_ABURST_INCR  , -- In  :
                REQ_LOCK            => REQ_LOCK          , -- In  :
                REQ_CACHE           => req_cache         , -- In  :
                REQ_PROT            => req_prot          , -- In  :
                REQ_QOS             => REQ_QOS           , -- In  :
                REQ_REGION          => REQ_REGION        , -- In  :
                REQ_BUF_PTR         => req_buf_ptr       , -- In  :
                REQ_FIRST           => req_first         , -- In  :
                REQ_LAST            => req_last          , -- In  :
                REQ_SPECULATIVE     => req_speculative   , -- In  :
                REQ_SAFETY          => req_safety        , -- In  :
                REQ_VAL(0)          => req_valid         , -- In  :
                REQ_RDY             => req_ready         , -- Out :
            -----------------------------------------------------------------------
            -- Command Acknowledge Signals.
            -----------------------------------------------------------------------
                ACK_VAL(0)          => ack_valid         , -- Out :
                ACK_NEXT            => ack_next          , -- Out :
                ACK_LAST            => ack_last          , -- Out :
                ACK_ERROR           => ack_error         , -- Out :
                ACK_STOP            => ack_stop          , -- Out :
                ACK_NONE            => ack_none          , -- Out :
                ACK_SIZE            => ack_size          , -- Out :
            -----------------------------------------------------------------------
            -- Transfer Status Signal.
            -----------------------------------------------------------------------
                XFER_BUSY(0)        => xfer_busy         , -- Out :
                XFER_ERROR(0)       => xfer_error        , -- Out :
                XFER_DONE(0)        => xfer_done         , -- Out :
            -----------------------------------------------------------------------
            -- Flow Control Signals.
            -----------------------------------------------------------------------
                FLOW_STOP           => flow_stop         , -- In  :
                FLOW_PAUSE          => flow_pause        , -- In  :
                FLOW_LAST           => flow_last         , -- In  :
                FLOW_SIZE           => flow_size         , -- In  :
            -----------------------------------------------------------------------
            -- Push Final Size Signals.
            -----------------------------------------------------------------------
                PUSH_FIN_VAL(0)     => push_fin_valid    , -- Out :
                PUSH_FIN_LAST       => push_fin_last     , -- Out :
                PUSH_FIN_ERROR      => push_fin_error    , -- Out :
                PUSH_FIN_SIZE       => push_fin_size     , -- Out :
            -----------------------------------------------------------------------
            -- Push Buffer Size Signals.
            -----------------------------------------------------------------------
                PUSH_BUF_RESET(0)   => push_buf_reset    , -- Out :
                PUSH_BUF_VAL(0)     => push_buf_valid    , -- Out :
                PUSH_BUF_LAST       => push_buf_last     , -- Out :
                PUSH_BUF_ERROR      => push_buf_error    , -- Out :
                PUSH_BUF_SIZE       => push_buf_size     , -- Out :
                PUSH_BUF_RDY(0)     => push_buf_ready    , -- In  :
            -----------------------------------------------------------------------
            -- Read Buffer Interface Signals.
            -----------------------------------------------------------------------
                BUF_WEN(0)          => buf_wen           , -- Out :
                BUF_BEN             => buf_ben           , -- Out :
                BUF_DATA            => buf_wdata         , -- Out :
                BUF_PTR             => buf_wptr            -- Out :
            );
        M_ARVALID <= i_arvalid;
        i_arready <= M_ARREADY;
        i_rvalid  <= M_RVALID;
        M_RREADY  <= i_rready;
        ---------------------------------------------------------------------------
        -- Master Read Controller
        ---------------------------------------------------------------------------
        CTRL: PUMP_CONTROLLER_INTAKE_SIDE                  -- 
            generic map (                                  -- 
                REQ_ADDR_BITS       => REQ_ADDR_BITS     , --   
                REG_ADDR_BITS       => MR_ADDR_REGS_BITS , --   
                REQ_SIZE_VALID      => REQ_SIZE_VALID    , --   
                REQ_SIZE_BITS       => REQ_SIZE_BITS     , --   
                REG_SIZE_BITS       => MR_SIZE_REGS_BITS , --   
                REG_MODE_BITS       => MR_MODE_REGS_BITS , --   
                REG_STAT_BITS       => MR_STAT_RESV_BITS , --   
                FIXED_FLOW_OPEN     => 1                 , --   
                FIXED_POOL_OPEN     => 1                 , --   
                USE_PUSH_BUF_SIZE   => 0                 , --   
                USE_PULL_RSV_SIZE   => 0                 , --   
                BUF_DEPTH           => BUF_DEPTH           --   
            )                                              -- 
            port map (                                     -- 
            ---------------------------------------------------------------------------
            -- Clock/Reset Signals.
            ---------------------------------------------------------------------------
                CLK                 => ACLK              , -- In  :
                RST                 => RST               , -- In  :
                CLR                 => CLR               , -- In  :
            ---------------------------------------------------------------------------
            -- Intake Control Status Register Interface.
            ---------------------------------------------------------------------------
                REG_ADDR_L          => regs_load(MR_ADDR_REGS_HI downto MR_ADDR_REGS_LO), --  In  :
                REG_ADDR_D          => regs_wbit(MR_ADDR_REGS_HI downto MR_ADDR_REGS_LO), --  In  :
                REG_ADDR_Q          => regs_rbit(MR_ADDR_REGS_HI downto MR_ADDR_REGS_LO), --  Out :
                REG_SIZE_L          => regs_load(MR_SIZE_REGS_HI downto MR_SIZE_REGS_LO), --  In  :
                REG_SIZE_D          => regs_wbit(MR_SIZE_REGS_HI downto MR_SIZE_REGS_LO), --  In  :
                REG_SIZE_Q          => regs_rbit(MR_SIZE_REGS_HI downto MR_SIZE_REGS_LO), --  Out :
                REG_MODE_L          => regs_load(MR_MODE_REGS_HI downto MR_MODE_REGS_LO), --  In  :
                REG_MODE_D          => regs_wbit(MR_MODE_REGS_HI downto MR_MODE_REGS_LO), --  In  :
                REG_MODE_Q          => regs_rbit(MR_MODE_REGS_HI downto MR_MODE_REGS_LO), --  Out :
                REG_STAT_L          => regs_load(MR_STAT_RESV_HI downto MR_STAT_RESV_LO), --  In  :
                REG_STAT_D          => regs_wbit(MR_STAT_RESV_HI downto MR_STAT_RESV_LO), --  In  :
                REG_STAT_Q          => regs_rbit(MR_STAT_RESV_HI downto MR_STAT_RESV_LO), --  Out :
                REG_STAT_I          => MR_STAT_RESV_NULL                                , --  In  :
                REG_RESET_L         => regs_load(MR_CTRL_RESET_POS)                     , --  In  :
                REG_RESET_D         => regs_wbit(MR_CTRL_RESET_POS)                     , --  In  :
                REG_RESET_Q         => regs_rbit(MR_CTRL_RESET_POS)                     , --  Out :
                REG_START_L         => regs_load(MR_CTRL_START_POS)                     , --  In  :
                REG_START_D         => regs_wbit(MR_CTRL_START_POS)                     , --  In  :
                REG_START_Q         => regs_rbit(MR_CTRL_START_POS)                     , --  Out :
                REG_STOP_L          => regs_load(MR_CTRL_STOP_POS )                     , --  In  :
                REG_STOP_D          => regs_wbit(MR_CTRL_STOP_POS )                     , --  In  :
                REG_STOP_Q          => regs_rbit(MR_CTRL_STOP_POS )                     , --  Out :
                REG_PAUSE_L         => regs_load(MR_CTRL_PAUSE_POS)                     , --  In  :
                REG_PAUSE_D         => regs_wbit(MR_CTRL_PAUSE_POS)                     , --  In  :
                REG_PAUSE_Q         => regs_rbit(MR_CTRL_PAUSE_POS)                     , --  Out :
                REG_FIRST_L         => regs_load(MR_CTRL_FIRST_POS)                     , --  In  :
                REG_FIRST_D         => regs_wbit(MR_CTRL_FIRST_POS)                     , --  In  :
                REG_FIRST_Q         => regs_rbit(MR_CTRL_FIRST_POS)                     , --  Out :
                REG_LAST_L          => regs_load(MR_CTRL_LAST_POS )                     , --  In  :
                REG_LAST_D          => regs_wbit(MR_CTRL_LAST_POS )                     , --  In  :
                REG_LAST_Q          => regs_rbit(MR_CTRL_LAST_POS )                     , --  Out :
                REG_DONE_EN_L       => regs_load(MR_CTRL_DONE_POS )                     , --  In  :
                REG_DONE_EN_D       => regs_wbit(MR_CTRL_DONE_POS )                     , --  In  :
                REG_DONE_EN_Q       => regs_rbit(MR_CTRL_DONE_POS )                     , --  Out :
                REG_DONE_ST_L       => regs_load(MR_STAT_DONE_POS )                     , --  In  :
                REG_DONE_ST_D       => regs_wbit(MR_STAT_DONE_POS )                     , --  In  :
                REG_DONE_ST_Q       => regs_rbit(MR_STAT_DONE_POS )                     , --  Out :
                REG_ERR_ST_L        => regs_load(MR_STAT_ERROR_POS)                     , --  In  :
                REG_ERR_ST_D        => regs_wbit(MR_STAT_ERROR_POS)                     , --  In  :
                REG_ERR_ST_Q        => regs_rbit(MR_STAT_ERROR_POS)                     , --  Out :
            ---------------------------------------------------------------------------
            -- Intake Configuration Signals.
            ---------------------------------------------------------------------------
                BUF_READY_LEVEL     => BUF_READY_LEVEL   , -- In  :
                FLOW_READY_LEVEL    => FLOW_READY_LEVEL  , -- In  :
            ---------------------------------------------------------------------------
            -- Intake Transaction Command Request Signals.
            ---------------------------------------------------------------------------
                REQ_VALID           => req_valid         , -- Out :
                REQ_ADDR            => req_addr          , -- Out :
                REQ_SIZE            => req_size          , -- Out :
                REQ_BUF_PTR         => req_buf_ptr       , -- Out :
                REQ_FIRST           => req_first         , -- Out :
                REQ_LAST            => req_last          , -- Out :
                REQ_NONE            => req_none          , -- Out :
                REQ_READY           => req_ready         , -- In  :
            ---------------------------------------------------------------------------
            -- Intake Transaction Command Acknowledge Signals.
            ---------------------------------------------------------------------------
                ACK_VALID           => ack_valid         , -- In  :
                ACK_SIZE            => ack_size          , -- In  :
                ACK_ERROR           => ack_error         , -- In  :
                ACK_NEXT            => ack_next          , -- In  :
                ACK_LAST            => ack_last          , -- In  :
                ACK_STOP            => ack_stop          , -- In  :
                ACK_NONE            => ack_none          , -- In  :
            ---------------------------------------------------------------------------
            -- Intake_Transfer Status Signals.
            ---------------------------------------------------------------------------
                XFER_BUSY           => xfer_busy         , -- In  :
                XFER_DONE           => xfer_done         , -- In  :
                XFER_ERROR          => xfer_error        , -- In  :
            ---------------------------------------------------------------------------
            -- Intake Flow Control Signals.
            ---------------------------------------------------------------------------
                FLOW_READY          => flow_ready        , -- Out :
                FLOW_PAUSE          => flow_pause        , -- Out :
                FLOW_STOP           => flow_stop         , -- Out :
                FLOW_LAST           => flow_last         , -- Out :
                FLOW_SIZE           => flow_size         , -- Out :
                PUSH_FIN_VALID      => push_fin_valid    , -- In  :
                PUSH_FIN_LAST       => push_fin_last     , -- In  :
                PUSH_FIN_ERROR      => push_fin_error    , -- In  :
                PUSH_FIN_SIZE       => push_fin_size     , -- In  :
                PUSH_BUF_RESET      => push_buf_reset    , -- In  :
                PUSH_BUF_VALID      => push_buf_valid    , -- In  :
                PUSH_BUF_LAST       => push_buf_last     , -- In  :
                PUSH_BUF_ERROR      => push_buf_error    , -- In  :
                PUSH_BUF_SIZE       => push_buf_size     , -- In  :
                PUSH_BUF_READY      => push_buf_ready    , -- Out :
            ---------------------------------------------------------------------------
            -- Outlet Status Input.
            ---------------------------------------------------------------------------
                O_OPEN              => valve_open        , -- In  :
            ---------------------------------------------------------------------------
            -- Intake Status Output.
            ---------------------------------------------------------------------------
                I_OPEN              => valve_open        , -- Out :
            ---------------------------------------------------------------------------
            -- Transaction Status Signals.
            ---------------------------------------------------------------------------
                TRAN_BUSY           => open              , -- Out :
                TRAN_DONE           => open              , -- Out :
                TRAN_NONE           => open              , -- Out :
                TRAN_ERROR          => open                -- Out :
        );
        ---------------------------------------------------------------------------
        -- request transaction mode
        ---------------------------------------------------------------------------
        M_ARUSER        <= (others => '0');
        req_speculative <= regs_rbit(MR_MODE_SPECUL_POS);
        req_safety      <= regs_rbit(MR_MODE_SAFETY_POS);
        req_prot        <= regs_rbit(MR_MODE_PROT_HI  downto MR_MODE_PROT_LO );
        req_cache       <= regs_rbit(MR_MODE_CACHE_HI downto MR_MODE_CACHE_LO);
        ---------------------------------------------------------------------------
        -- regs_rbit
        ---------------------------------------------------------------------------
        regs_rbit(MR_CTRL_RESV_POS) <= '0';
        ---------------------------------------------------------------------------
        -- MONITOR
        ---------------------------------------------------------------------------
        MONITOR: block
            constant  ctrl_regs   :  std_logic_vector(MR_MONITOR_CTRL_BITS-1 downto 0)
                                  := (others => '0');
            constant  reset_data  :  std_logic := '1';
            signal    reset_load  :  std_logic;
            constant  start_data  :  std_logic := '1';
            signal    start_load  :  std_logic;
            constant  stop_data   :  std_logic := '1';
            signal    stop_load   :  std_logic;
            constant  pause_data  :  std_logic := '0';
            constant  pause_load  :  std_logic := '0';
            signal    valve_regs  :  std_logic;
        begin
            ----------------------------------------------------------------------------
            -- 
            ----------------------------------------------------------------------------
            reset_load <= '1' when (regs_rbit(MR_CTRL_RESET_POS) = '1') or
                                   (regs_wbit(MR_MONITOR_RESET_POS) = '1' and
                                    regs_load(MR_MONITOR_RESET_POS) = '1' ) else '0';
            ----------------------------------------------------------------------------
            -- 
            ----------------------------------------------------------------------------
            process (ACLK, RST) begin 
                if (RST = '1') then
                        valve_regs <= '0';
                elsif (ACLK'event and ACLK = '1') then
                    if (CLR = '1') then
                        valve_regs <= '0';
                    else
                        valve_regs <= valve_open;
                    end if;
                end if;
            end process;
            start_load <= '1' when (valve_regs = '0' and valve_open = '1') else '0';
            stop_load  <= '1' when (valve_regs = '1' and valve_open = '0') else '0';
            ----------------------------------------------------------------------------
            -- 
            ----------------------------------------------------------------------------
            U: AXI4_TRAFFIC_MONITOR                        --
                generic map (                              --
                    ENABLE      => 1                     , --
                    COUNT_BITS  => 64                    , --
                    REGS_BITS   => 64                      --
                )                                          --
                port map (                                 --
                -----------------------------------------------------------------------
                -- Clock/Reset Signals.
                -----------------------------------------------------------------------
                    CLK         => ACLK                  , -- In  :
                    RST         => RST                   , -- In  :
                    CLR         => CLR                   , -- In  :
                -----------------------------------------------------------------------
                -- Control Signals.
                -----------------------------------------------------------------------
                    RESET_L     => reset_load            , -- In
                    RESET_D     => reset_data            , -- In
                    RESET_Q     => open                  , -- Out
                    START_L     => start_load            , -- In
                    START_D     => start_data            , -- In
                    START_Q     => open                  , -- Out
                    STOP_L      => stop_load             , -- In
                    STOP_D      => stop_data             , -- In
                    STOP_Q      => open                  , -- Out
                    PAUSE_L     => pause_load            , -- In
                    PAUSE_D     => pause_data            , -- In
                    PAUSE_Q     => open                  , -- Out
                ----------------------------------------------------------------------
                -- AXI4 Address Channel Signals.
                ----------------------------------------------------------------------
                    AVALID      => i_arvalid             , -- In
                    AREADY      => i_arready             , -- In
                ----------------------------------------------------------------------
                -- AXI4 Data Channel Signals.
                ----------------------------------------------------------------------
                    DVALID      => i_rvalid              , -- In
                    DREADY      => i_rready              , -- In
                ----------------------------------------------------------------------
                -- Monitor Output Registers.
                ----------------------------------------------------------------------
                    TOTAL_REGS  => regs_rbit(MR_MONITOR_COUNT_HI downto MR_MONITOR_COUNT_LO), 
                    ADDR_REGS   => regs_rbit(MR_MONITOR_ADDR_HI  downto MR_MONITOR_ADDR_LO ), 
                    AVALID_REGS => regs_rbit(MR_MONITOR_AVAL_HI  downto MR_MONITOR_AVAL_LO ), 
                    AREADY_REGS => regs_rbit(MR_MONITOR_ARDY_HI  downto MR_MONITOR_ARDY_LO ), 
                    DATA_REGS   => regs_rbit(MR_MONITOR_DATA_HI  downto MR_MONITOR_DATA_LO ), 
                    DVALID_REGS => regs_rbit(MR_MONITOR_DVAL_HI  downto MR_MONITOR_DVAL_LO ), 
                    DREADY_REGS => regs_rbit(MR_MONITOR_DRDY_HI  downto MR_MONITOR_DRDY_LO )
                );
            regs_rbit(MR_MONITOR_CTRL_HI  downto MR_MONITOR_CTRL_LO ) <= ctrl_regs;
        end block;
    end block;
    -------------------------------------------------------------------------------
    -- Interrupt Request Signal
    -------------------------------------------------------------------------------
    process (ACLK, RST) begin
        if (RST = '1') then
                IRQ <= '0';
        elsif (ACLK'event and ACLK = '1') then
            if (CLR = '1') then
                IRQ <= '0';
            elsif (regs_rbit(MW_STAT_DONE_POS ) = '1' and regs_rbit(MW_MODE_DONE_POS ) = '1') or
                  (regs_rbit(MW_STAT_ERROR_POS) = '1' and regs_rbit(MW_MODE_ERROR_POS) = '1') or
                  (regs_rbit(MR_STAT_DONE_POS ) = '1' and regs_rbit(MR_MODE_DONE_POS ) = '1') or
                  (regs_rbit(MR_STAT_ERROR_POS) = '1' and regs_rbit(MR_MODE_ERROR_POS) = '1') then
                IRQ <= '1';
            else
                IRQ <= '0';
            end if;
        end if;
    end process;
end RTL;
