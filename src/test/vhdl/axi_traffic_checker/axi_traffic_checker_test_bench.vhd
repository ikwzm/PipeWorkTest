-----------------------------------------------------------------------------------
--!     @file    axi_traffic_checker_test_bench.vhd
--!     @brief   AXI Traffic Checker Test Bench
--!     @version 0.1.0
--!     @date    2024/3/8
--!     @author  Ichiro Kawazome <ichiro_k@ca2.so-net.ne.jp>
-----------------------------------------------------------------------------------
--
--      Copyright (C) 2024 Ichiro Kawazome
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
library ieee;
use     ieee.std_logic_1164.all;
library DUMMY_PLUG;
use     DUMMY_PLUG.AXI4_TYPES.all;
entity  AXI_TRAFFIC_CHECKER_TEST_BENCH is
    generic (
        NAME            : STRING                                 := "test";
        SCENARIO_FILE   : STRING                                 := "test.snr";
        M_DATA_WIDTH    : integer range 8 to AXI4_DATA_MAX_WIDTH := 32;
        M_MAX_XFER_SIZE : integer                                :=  6;
        MW_QUEUE_SIZE   : integer                                :=  2;
        MW_REQ_REGS     : integer                                :=  1;
        MW_ACK_REGS     : integer                                :=  1;
        MW_RESP_REGS    : integer                                :=  1;
        MW_DATA_PIPELINE: integer                                :=  0;
        MR_QUEUE_SIZE   : integer                                :=  1;
        MR_ACK_REGS     : integer                                :=  1;
        MR_DATA_REGS    : integer                                :=  1;
        MR_DATA_PIPELINE: integer                                :=  0;
        FINISH_ABORT    : boolean                                := FALSE
    );
end     AXI_TRAFFIC_CHECKER_TEST_BENCH;
-----------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------
library ieee;
use     ieee.std_logic_1164.all;
use     ieee.numeric_std.all;
use     std.textio.all;
library DUMMY_PLUG;
use     DUMMY_PLUG.AXI4_TYPES.all;
use     DUMMY_PLUG.AXI4_MODELS.AXI4_MASTER_PLAYER;
use     DUMMY_PLUG.AXI4_MODELS.AXI4_SLAVE_PLAYER;
use     DUMMY_PLUG.AXI4_MODELS.AXI4_SIGNAL_PRINTER;
use     DUMMY_PLUG.SYNC.all;
use     DUMMY_PLUG.CORE.MARCHAL;
use     DUMMY_PLUG.CORE.REPORT_STATUS_TYPE;
use     DUMMY_PLUG.CORE.REPORT_STATUS_VECTOR;
use     DUMMY_PLUG.CORE.MARGE_REPORT_STATUS;
architecture MODEL of AXI_TRAFFIC_CHECKER_TEST_BENCH is
    -------------------------------------------------------------------------------
    -- 各種定数
    -------------------------------------------------------------------------------
    constant  PERIOD            :  time    :=  10 ns;
    constant  DELAY             :  time    :=  1 ns;
    constant  AXI4_ADDR_WIDTH   :  integer := 32;
    constant  C_WIDTH           :  AXI4_SIGNAL_WIDTH_TYPE := (
                                     ID          => 4,
                                     AWADDR      => AXI4_ADDR_WIDTH,
                                     ARADDR      => AXI4_ADDR_WIDTH,
                                     ALEN        => AXI4_ALEN_WIDTH,
                                     ALOCK       => AXI4_ALOCK_WIDTH,
                                     WDATA       => 32,
                                     RDATA       => 32,
                                     ARUSER      => 1,
                                     AWUSER      => 1,
                                     WUSER       => 1,
                                     RUSER       => 1,
                                     BUSER       => 1);
    constant  M_WIDTH           :  AXI4_SIGNAL_WIDTH_TYPE := (
                                     ID          => 4,
                                     AWADDR      => AXI4_ADDR_WIDTH,
                                     ARADDR      => AXI4_ADDR_WIDTH,
                                     ALEN        => AXI4_ALEN_WIDTH,
                                     ALOCK       => AXI4_ALOCK_WIDTH,
                                     WDATA       => M_DATA_WIDTH,
                                     RDATA       => M_DATA_WIDTH,
                                     ARUSER      => 1,
                                     AWUSER      => 1,
                                     WUSER       => 1,
                                     RUSER       => 1,
                                     BUSER       => 1);
    constant   M_AXI_ID         :  integer :=  1;
    constant   SYNC_WIDTH       :  integer :=  2;
    constant   GPO_WIDTH        :  integer :=  8;
    constant   GPI_WIDTH        :  integer :=  GPO_WIDTH;
    -------------------------------------------------------------------------------
    -- グローバルシグナル.
    -------------------------------------------------------------------------------
    signal    ARESETn           :  std_logic;
    signal    RESET             :  std_logic;
    constant  CLEAR             :  std_logic := '0';
    signal    ACLK              :  std_logic;
    ------------------------------------------------------------------------------
    -- CSR I/F 
    ------------------------------------------------------------------------------
    signal    C_ARADDR          :  std_logic_vector(C_WIDTH.ARADDR -1 downto 0);
    signal    C_ARLEN           :  std_logic_vector(C_WIDTH.ALEN   -1 downto 0);
    signal    C_ARSIZE          :  AXI4_ASIZE_TYPE;
    signal    C_ARBURST         :  AXI4_ABURST_TYPE;
    signal    C_ARLOCK          :  std_logic_vector(C_WIDTH.ALOCK  -1 downto 0);
    signal    C_ARCACHE         :  AXI4_ACACHE_TYPE;
    signal    C_ARPROT          :  AXI4_APROT_TYPE;
    signal    C_ARQOS           :  AXI4_AQOS_TYPE;
    signal    C_ARREGION        :  AXI4_AREGION_TYPE;
    signal    C_ARUSER          :  std_logic_vector(C_WIDTH.ARUSER -1 downto 0);
    signal    C_ARID            :  std_logic_vector(C_WIDTH.ID     -1 downto 0);
    signal    C_ARVALID         :  std_logic;
    signal    C_ARREADY         :  std_logic;
    signal    C_RVALID          :  std_logic;
    signal    C_RLAST           :  std_logic;
    signal    C_RDATA           :  std_logic_vector(C_WIDTH.RDATA  -1 downto 0);
    signal    C_RRESP           :  AXI4_RESP_TYPE;
    signal    C_RUSER           :  std_logic_vector(C_WIDTH.RUSER  -1 downto 0);
    signal    C_RID             :  std_logic_vector(C_WIDTH.ID     -1 downto 0);
    signal    C_RREADY          :  std_logic;
    signal    C_AWADDR          :  std_logic_vector(C_WIDTH.AWADDR -1 downto 0);
    signal    C_AWLEN           :  std_logic_vector(C_WIDTH.ALEN   -1 downto 0);
    signal    C_AWSIZE          :  AXI4_ASIZE_TYPE;
    signal    C_AWBURST         :  AXI4_ABURST_TYPE;
    signal    C_AWLOCK          :  std_logic_vector(C_WIDTH.ALOCK  -1 downto 0);
    signal    C_AWCACHE         :  AXI4_ACACHE_TYPE;
    signal    C_AWPROT          :  AXI4_APROT_TYPE;
    signal    C_AWQOS           :  AXI4_AQOS_TYPE;
    signal    C_AWREGION        :  AXI4_AREGION_TYPE;
    signal    C_AWUSER          :  std_logic_vector(C_WIDTH.AWUSER -1 downto 0);
    signal    C_AWID            :  std_logic_vector(C_WIDTH.ID     -1 downto 0);
    signal    C_AWVALID         :  std_logic;
    signal    C_AWREADY         :  std_logic;
    signal    C_WLAST           :  std_logic;
    signal    C_WDATA           :  std_logic_vector(C_WIDTH.WDATA  -1 downto 0);
    signal    C_WSTRB           :  std_logic_vector(C_WIDTH.WDATA/8-1 downto 0);
    signal    C_WUSER           :  std_logic_vector(C_WIDTH.WUSER  -1 downto 0);
    signal    C_WID             :  std_logic_vector(C_WIDTH.ID     -1 downto 0);
    signal    C_WVALID          :  std_logic;
    signal    C_WREADY          :  std_logic;
    signal    C_BRESP           :  AXI4_RESP_TYPE;
    signal    C_BUSER           :  std_logic_vector(C_WIDTH.BUSER  -1 downto 0);
    signal    C_BID             :  std_logic_vector(C_WIDTH.ID     -1 downto 0);
    signal    C_BVALID          :  std_logic;
    signal    C_BREADY          :  std_logic;
    ------------------------------------------------------------------------------
    -- Out I/F 
    ------------------------------------------------------------------------------
    signal    M_ARADDR          :  std_logic_vector(M_WIDTH.ARADDR -1 downto 0);
    signal    M_ARLEN           :  std_logic_vector(M_WIDTH.ALEN   -1 downto 0);
    signal    M_ARSIZE          :  AXI4_ASIZE_TYPE;
    signal    M_ARBURST         :  AXI4_ABURST_TYPE;
    signal    M_ARLOCK          :  std_logic_vector(M_WIDTH.ALOCK  -1 downto 0);
    signal    M_ARCACHE         :  AXI4_ACACHE_TYPE;
    signal    M_ARPROT          :  AXI4_APROT_TYPE;
    signal    M_ARQOS           :  AXI4_AQOS_TYPE;
    signal    M_ARREGION        :  AXI4_AREGION_TYPE;
    signal    M_ARUSER          :  std_logic_vector(M_WIDTH.ARUSER -1 downto 0);
    signal    M_ARID            :  std_logic_vector(M_WIDTH.ID     -1 downto 0);
    signal    M_ARVALID         :  std_logic;
    signal    M_ARREADY         :  std_logic;
    signal    M_RVALID          :  std_logic;
    signal    M_RLAST           :  std_logic;
    signal    M_RDATA           :  std_logic_vector(M_WIDTH.RDATA  -1 downto 0);
    signal    M_RRESP           :  AXI4_RESP_TYPE;
    signal    M_RUSER           :  std_logic_vector(M_WIDTH.RUSER  -1 downto 0);
    signal    M_RID             :  std_logic_vector(M_WIDTH.ID     -1 downto 0);
    signal    M_RREADY          :  std_logic;
    signal    M_AWADDR          :  std_logic_vector(M_WIDTH.AWADDR -1 downto 0);
    signal    M_AWLEN           :  std_logic_vector(M_WIDTH.ALEN   -1 downto 0);
    signal    M_AWSIZE          :  AXI4_ASIZE_TYPE;
    signal    M_AWBURST         :  AXI4_ABURST_TYPE;
    signal    M_AWLOCK          :  std_logic_vector(M_WIDTH.ALOCK  -1 downto 0);
    signal    M_AWCACHE         :  AXI4_ACACHE_TYPE;
    signal    M_AWPROT          :  AXI4_APROT_TYPE;
    signal    M_AWQOS           :  AXI4_AQOS_TYPE;
    signal    M_AWREGION        :  AXI4_AREGION_TYPE;
    signal    M_AWUSER          :  std_logic_vector(M_WIDTH.AWUSER -1 downto 0);
    signal    M_AWID            :  std_logic_vector(M_WIDTH.ID     -1 downto 0);
    signal    M_AWVALID         :  std_logic;
    signal    M_AWREADY         :  std_logic;
    signal    M_WLAST           :  std_logic;
    signal    M_WDATA           :  std_logic_vector(M_WIDTH.WDATA  -1 downto 0);
    signal    M_WSTRB           :  std_logic_vector(M_WIDTH.WDATA/8-1 downto 0);
    signal    M_WUSER           :  std_logic_vector(M_WIDTH.WUSER  -1 downto 0);
    signal    M_WID             :  std_logic_vector(M_WIDTH.ID     -1 downto 0);
    signal    M_WVALID          :  std_logic;
    signal    M_WREADY          :  std_logic;
    signal    M_BRESP           :  AXI4_RESP_TYPE;
    signal    M_BUSER           :  std_logic_vector(M_WIDTH.BUSER  -1 downto 0);
    signal    M_BID             :  std_logic_vector(M_WIDTH.ID     -1 downto 0);
    signal    M_BVALID          :  std_logic;
    signal    M_BREADY          :  std_logic;
    -------------------------------------------------------------------------------
    -- 
    -------------------------------------------------------------------------------
    signal    IRQ               :  std_logic;
    -------------------------------------------------------------------------------
    -- シンクロ用信号
    -------------------------------------------------------------------------------
    signal    SYNC              :  SYNC_SIG_VECTOR (SYNC_WIDTH   -1 downto 0);
    -------------------------------------------------------------------------------
    -- GPIO(General Purpose Input/Output)
    -------------------------------------------------------------------------------
    signal    C_GPI             :  std_logic_vector(GPI_WIDTH    -1 downto 0);
    signal    C_GPO             :  std_logic_vector(GPO_WIDTH    -1 downto 0);
    signal    M_GPI             :  std_logic_vector(GPI_WIDTH    -1 downto 0);
    signal    M_GPO             :  std_logic_vector(GPO_WIDTH    -1 downto 0);
    -------------------------------------------------------------------------------
    -- 各種状態出力.
    -------------------------------------------------------------------------------
    signal    N_REPORT          :  REPORT_STATUS_TYPE;
    signal    C_REPORT          :  REPORT_STATUS_TYPE;
    signal    M_REPORT          :  REPORT_STATUS_TYPE;
    signal    N_FINISH          :  std_logic;
    signal    C_FINISH          :  std_logic;
    signal    M_FINISH          :  std_logic;
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
begin
    -------------------------------------------------------------------------------
    -- 
    -------------------------------------------------------------------------------
    DUT: entity work.AXI_TRAFFIC_CHECKER             -- 
        generic map(                                 -- 
            C_ADDR_WIDTH    => C_WIDTH.AWADDR      , -- 
            C_DATA_WIDTH    => C_WIDTH.WDATA       , -- 
            C_ID_WIDTH      => C_WIDTH.ID          , -- 
            M_AXI_ID        => M_AXI_ID            , -- 
            M_ADDR_WIDTH    => M_WIDTH.AWADDR      , -- 
            M_DATA_WIDTH    => M_WIDTH.WDATA       , -- 
            M_ID_WIDTH      => M_WIDTH.ID          , -- 
            M_AUSER_WIDTH   => M_WIDTH.AWUSER      , -- 
            MW_MAX_XFER_SIZE=> M_MAX_XFER_SIZE     , -- 
            MW_QUEUE_SIZE   => MW_QUEUE_SIZE       , -- 
            MW_REQ_REGS     => MW_REQ_REGS         , --
            MW_ACK_REGS     => MW_ACK_REGS         , --
            MW_RESP_REGS    => MW_RESP_REGS        , -- 
            MW_DATA_PIPELINE=> MW_DATA_PIPELINE    , -- 
            MR_MAX_XFER_SIZE=> M_MAX_XFER_SIZE     , -- 
            MR_QUEUE_SIZE   => MR_QUEUE_SIZE       , -- 
            MR_ACK_REGS     => MR_ACK_REGS         , -- 
            MR_DATA_REGS    => MR_DATA_REGS        , -- 
            MR_DATA_PIPELINE=> MR_DATA_PIPELINE      -- 
        )                                            -- 
        port map (                                   -- 
        ---------------------------------------------------------------------------
        -- Reset Signals.
        ---------------------------------------------------------------------------
            ARESETn         => ARESETn             , -- In  :
        ---------------------------------------------------------------------------
        -- Pump Intake I/F Clock.
        ---------------------------------------------------------------------------
            ACLK            => ACLK                , -- In  :
        ---------------------------------------------------------------------------
        -- Control Status Register I/F AXI4 Read Address Channel Signals.
        ---------------------------------------------------------------------------
            C_ARID          => C_ARID              , -- In  :
            C_ARADDR        => C_ARADDR            , -- In  :
            C_ARLEN         => C_ARLEN             , -- In  :
            C_ARSIZE        => C_ARSIZE            , -- In  :
            C_ARBURST       => C_ARBURST           , -- In  :
            C_ARVALID       => C_ARVALID           , -- In  :
            C_ARREADY       => C_ARREADY           , -- Out :
        ---------------------------------------------------------------------------
        -- Control Status Register I/F AXI4 Read Data Channel Signals.
        ---------------------------------------------------------------------------
            C_RID           => C_RID               , -- Out :
            C_RDATA         => C_RDATA             , -- Out :
            C_RRESP         => C_RRESP             , -- Out :
            C_RLAST         => C_RLAST             , -- Out :
            C_RVALID        => C_RVALID            , -- Out :
            C_RREADY        => C_RREADY            , -- In  :
        ---------------------------------------------------------------------------
        -- Control Status Register I/F AXI4 Write Address Channel Signals.
        ---------------------------------------------------------------------------
            C_AWID          => C_AWID              , -- In  :
            C_AWADDR        => C_AWADDR            , -- In  :
            C_AWLEN         => C_AWLEN             , -- In  :
            C_AWSIZE        => C_AWSIZE            , -- In  :
            C_AWBURST       => C_AWBURST           , -- In  :
            C_AWVALID       => C_AWVALID           , -- In  :
            C_AWREADY       => C_AWREADY           , -- Out :
        ---------------------------------------------------------------------------
        -- Control Status Register I/F AXI4 Write Data Channel Signals.
        ---------------------------------------------------------------------------
            C_WDATA         => C_WDATA             , -- In  :
            C_WSTRB         => C_WSTRB             , -- In  :
            C_WLAST         => C_WLAST             , -- In  :
            C_WVALID        => C_WVALID            , -- In  :
            C_WREADY        => C_WREADY            , -- Out :
        ---------------------------------------------------------------------------
        -- Control Status Register I/F AXI4 Write Response Channel Signals.
        ---------------------------------------------------------------------------
            C_BID           => C_BID               , -- Out :
            C_BRESP         => C_BRESP             , -- Out :
            C_BVALID        => C_BVALID            , -- Out :
            C_BREADY        => C_BREADY            , -- In  :
        ---------------------------------------------------------------------------
        -- Traffic I/F AXI4 Write Address Channel Signals.
        ---------------------------------------------------------------------------
            M_AWID          => M_AWID              , -- Out :
            M_AWADDR        => M_AWADDR            , -- Out :
            M_AWLEN         => M_AWLEN             , -- Out :
            M_AWSIZE        => M_AWSIZE            , -- Out :
            M_AWBURST       => M_AWBURST           , -- Out :
            M_AWLOCK        => M_AWLOCK            , -- Out :
            M_AWCACHE       => M_AWCACHE           , -- Out :
            M_AWPROT        => M_AWPROT            , -- Out :
            M_AWQOS         => M_AWQOS             , -- Out :
            M_AWREGION      => M_AWREGION          , -- Out :
            M_AWUSER        => M_AWUSER            , -- Out :
            M_AWVALID       => M_AWVALID           , -- Out :
            M_AWREADY       => M_AWREADY           , -- In  :
        ---------------------------------------------------------------------------
        -- Traffic I/F AXI4 Write Data Channel Signals.
        ---------------------------------------------------------------------------
            M_WID           => M_WID               , -- Out :
            M_WDATA         => M_WDATA             , -- Out :
            M_WSTRB         => M_WSTRB             , -- Out :
            M_WLAST         => M_WLAST             , -- Out :
            M_WVALID        => M_WVALID            , -- Out :
            M_WREADY        => M_WREADY            , -- In  :
        ---------------------------------------------------------------------------
        -- Traffic I/F AXI4 Write Response Channel Signals.
        ---------------------------------------------------------------------------
            M_BID           => M_BID               , -- In  :
            M_BRESP         => M_BRESP             , -- In  :
            M_BVALID        => M_BVALID            , -- In  :
            M_BREADY        => M_BREADY            , -- Out :
        ---------------------------------------------------------------------------
        -- Traffic I/F AXI4 Read Address Channel Signals.
        ---------------------------------------------------------------------------
            M_ARID          => M_ARID              , -- Out :
            M_ARADDR        => M_ARADDR            , -- Out :
            M_ARLEN         => M_ARLEN             , -- Out :
            M_ARSIZE        => M_ARSIZE            , -- Out :
            M_ARBURST       => M_ARBURST           , -- Out :
            M_ARLOCK        => M_ARLOCK            , -- Out :
            M_ARCACHE       => M_ARCACHE           , -- Out :
            M_ARPROT        => M_ARPROT            , -- Out :
            M_ARQOS         => M_ARQOS             , -- Out :
            M_ARREGION      => M_ARREGION          , -- Out :
            M_ARUSER        => M_ARUSER            , -- Out :
            M_ARVALID       => M_ARVALID           , -- Out :
            M_ARREADY       => M_ARREADY           , -- In  :
        ---------------------------------------------------------------------------
        -- Traffic I/F AXI4 Read Data Channel Signals.
        ---------------------------------------------------------------------------
            M_RID           => M_RID               , -- In  :
            M_RDATA         => M_RDATA             , -- In  :
            M_RRESP         => M_RRESP             , -- In  :
            M_RLAST         => M_RLAST             , -- In  :
            M_RVALID        => M_RVALID            , -- In  :
            M_RREADY        => M_RREADY            , -- Out :
        ---------------------------------------------------------------------------
        -- Interrupt Request Signals.
        ---------------------------------------------------------------------------
            IRQ             => IRQ                   -- Out :
        );
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
            CLK             => ACLK            , -- In  :
            RESET           => RESET           , -- In  :
            SYNC(0)         => SYNC(0)         , -- I/O :
            SYNC(1)         => SYNC(1)         , -- I/O :
            REPORT_STATUS   => N_REPORT        , -- Out :
            FINISH          => N_FINISH          -- Out :
        );
    ------------------------------------------------------------------------------
    -- AXI4_MASTER_PLAYER
    ------------------------------------------------------------------------------
    C: AXI4_MASTER_PLAYER
        generic map (
            SCENARIO_FILE   => SCENARIO_FILE   ,
            NAME            => "CSR"           ,
            READ_ENABLE     => TRUE            ,
            WRITE_ENABLE    => TRUE            ,
            OUTPUT_DELAY    => DELAY           ,
            WIDTH           => C_WIDTH         ,
            SYNC_PLUG_NUM   => 2               ,
            SYNC_WIDTH      => SYNC_WIDTH      ,
            GPI_WIDTH       => GPI_WIDTH       ,
            GPO_WIDTH       => GPO_WIDTH       ,
            FINISH_ABORT    => FALSE
        )
        port map(
        ---------------------------------------------------------------------------
        -- グローバルシグナル.
        ---------------------------------------------------------------------------
            ACLK            => ACLK            , -- In  :
            ARESETn         => ARESETn         , -- In  :
        ---------------------------------------------------------------------------
        -- リードアドレスチャネルシグナル.
        ---------------------------------------------------------------------------
            ARADDR          => C_ARADDR        , -- I/O : 
            ARLEN           => C_ARLEN         , -- I/O : 
            ARSIZE          => C_ARSIZE        , -- I/O : 
            ARBURST         => C_ARBURST       , -- I/O : 
            ARLOCK          => C_ARLOCK        , -- I/O : 
            ARCACHE         => C_ARCACHE       , -- I/O : 
            ARPROT          => C_ARPROT        , -- I/O : 
            ARQOS           => C_ARQOS         , -- I/O : 
            ARREGION        => C_ARREGION      , -- I/O : 
            ARUSER          => C_ARUSER        , -- I/O : 
            ARID            => C_ARID          , -- I/O : 
            ARVALID         => C_ARVALID       , -- I/O : 
            ARREADY         => C_ARREADY       , -- In  :    
        ---------------------------------------------------------------------------
        -- リードデータチャネルシグナル.
        ---------------------------------------------------------------------------
            RLAST           => C_RLAST         , -- In  :    
            RDATA           => C_RDATA         , -- In  :    
            RRESP           => C_RRESP         , -- In  :    
            RUSER           => C_RUSER         , -- In  :    
            RID             => C_RID           , -- In  :    
            RVALID          => C_RVALID        , -- In  :    
            RREADY          => C_RREADY        , -- I/O : 
        --------------------------------------------------------------------------
        -- ライトアドレスチャネルシグナル.
        --------------------------------------------------------------------------
            AWADDR          => C_AWADDR        , -- I/O : 
            AWLEN           => C_AWLEN         , -- I/O : 
            AWSIZE          => C_AWSIZE        , -- I/O : 
            AWBURST         => C_AWBURST       , -- I/O : 
            AWLOCK          => C_AWLOCK        , -- I/O : 
            AWCACHE         => C_AWCACHE       , -- I/O : 
            AWPROT          => C_AWPROT        , -- I/O : 
            AWQOS           => C_AWQOS         , -- I/O : 
            AWREGION        => C_AWREGION      , -- I/O : 
            AWUSER          => C_AWUSER        , -- I/O : 
            AWID            => C_AWID          , -- I/O : 
            AWVALID         => C_AWVALID       , -- I/O : 
            AWREADY         => C_AWREADY       , -- In  :    
        --------------------------------------------------------------------------
        -- ライトデータチャネルシグナル.
        --------------------------------------------------------------------------
            WLAST           => C_WLAST         , -- I/O : 
            WDATA           => C_WDATA         , -- I/O : 
            WSTRB           => C_WSTRB         , -- I/O : 
            WUSER           => C_WUSER         , -- I/O : 
            WID             => C_WID           , -- I/O : 
            WVALID          => C_WVALID        , -- I/O : 
            WREADY          => C_WREADY        , -- In  :    
        --------------------------------------------------------------------------
        -- ライト応答チャネルシグナル.
        --------------------------------------------------------------------------
            BRESP           => C_BRESP         , -- In  :    
            BUSER           => C_BUSER         , -- In  :    
            BID             => C_BID           , -- In  :    
            BVALID          => C_BVALID        , -- In  :    
            BREADY          => C_BREADY        , -- I/O : 
        --------------------------------------------------------------------------
        -- シンクロ用信号
        --------------------------------------------------------------------------
            SYNC(0)         => SYNC(0)         , -- I/O :
            SYNC(1)         => SYNC(1)         , -- I/O :
        --------------------------------------------------------------------------
        -- GPIO
        --------------------------------------------------------------------------
            GPI             => C_GPI           , -- In  :
            GPO             => C_GPO           , -- Out :
        --------------------------------------------------------------------------
        -- 各種状態出力.
        --------------------------------------------------------------------------
            REPORT_STATUS   => C_REPORT        , -- Out :
            FINISH          => C_FINISH          -- Out :
        );
    ------------------------------------------------------------------------------
    -- AXI4_SLAVE_PLAYER
    ------------------------------------------------------------------------------
    M: AXI4_SLAVE_PLAYER
        generic map (
            SCENARIO_FILE   => SCENARIO_FILE   ,
            NAME            => "M"             ,
            READ_ENABLE     => TRUE            ,
            WRITE_ENABLE    => TRUE            ,
            OUTPUT_DELAY    => DELAY           ,
            WIDTH           => M_WIDTH         ,
            SYNC_PLUG_NUM   => 3               ,
            SYNC_WIDTH      => SYNC_WIDTH      ,
            GPI_WIDTH       => GPI_WIDTH       ,
            GPO_WIDTH       => GPO_WIDTH       ,
            FINISH_ABORT    => FALSE
        )
        port map(
        ---------------------------------------------------------------------------
        -- グローバルシグナル.
        ---------------------------------------------------------------------------
            ACLK            => ACLK            , -- In  :
            ARESETn         => ARESETn         , -- In  :
        ---------------------------------------------------------------------------
        -- リードアドレスチャネルシグナル.
        ---------------------------------------------------------------------------
            ARADDR          => M_ARADDR        , -- In  :    
            ARLEN           => M_ARLEN         , -- In  :    
            ARSIZE          => M_ARSIZE        , -- In  :    
            ARBURST         => M_ARBURST       , -- In  :    
            ARLOCK          => M_ARLOCK        , -- In  :    
            ARCACHE         => M_ARCACHE       , -- In  :    
            ARPROT          => M_ARPROT        , -- In  :    
            ARQOS           => M_ARQOS         , -- In  :    
            ARREGION        => M_ARREGION      , -- In  :    
            ARUSER          => M_ARUSER        , -- In  :    
            ARID            => M_ARID          , -- In  :    
            ARVALID         => M_ARVALID       , -- In  :    
            ARREADY         => M_ARREADY       , -- I/O : 
        ---------------------------------------------------------------------------
        -- リードデータチャネルシグナル.
        ---------------------------------------------------------------------------
            RLAST           => M_RLAST         , -- I/O : 
            RDATA           => M_RDATA         , -- I/O : 
            RRESP           => M_RRESP         , -- I/O : 
            RUSER           => M_RUSER         , -- I/O : 
            RID             => M_RID           , -- I/O : 
            RVALID          => M_RVALID        , -- I/O : 
            RREADY          => M_RREADY        , -- In  :    
        ---------------------------------------------------------------------------
        -- ライトアドレスチャネルシグナル.
        ---------------------------------------------------------------------------
            AWADDR          => M_AWADDR        , -- In  :    
            AWLEN           => M_AWLEN         , -- In  :    
            AWSIZE          => M_AWSIZE        , -- In  :    
            AWBURST         => M_AWBURST       , -- In  :    
            AWLOCK          => M_AWLOCK        , -- In  :    
            AWCACHE         => M_AWCACHE       , -- In  :    
            AWPROT          => M_AWPROT        , -- In  :    
            AWQOS           => M_AWQOS         , -- In  :    
            AWREGION        => M_AWREGION      , -- In  :    
            AWUSER          => M_AWUSER        , -- In  :    
            AWID            => M_AWID          , -- In  :    
            AWVALID         => M_AWVALID       , -- In  :    
            AWREADY         => M_AWREADY       , -- I/O : 
        ---------------------------------------------------------------------------
        -- ライトデータチャネルシグナル.
        ---------------------------------------------------------------------------
            WLAST           => M_WLAST         , -- In  :    
            WDATA           => M_WDATA         , -- In  :    
            WSTRB           => M_WSTRB         , -- In  :    
            WUSER           => M_WUSER         , -- In  :    
            WID             => M_WID           , -- In  :    
            WVALID          => M_WVALID        , -- In  :    
            WREADY          => M_WREADY        , -- I/O : 
        --------------------------------------------------------------------------
        -- ライト応答チャネルシグナル.
        --------------------------------------------------------------------------
            BRESP           => M_BRESP         , -- I/O : 
            BUSER           => M_BUSER         , -- I/O : 
            BID             => M_BID           , -- I/O : 
            BVALID          => M_BVALID        , -- I/O : 
            BREADY          => M_BREADY        , -- In  :    
        ---------------------------------------------------------------------------
        -- シンクロ用信号
        ---------------------------------------------------------------------------
            SYNC(0)         => SYNC(0)         , -- I/O :
            SYNC(1)         => SYNC(1)         , -- I/O :
        --------------------------------------------------------------------------
        -- GPIO
        --------------------------------------------------------------------------
            GPI             => M_GPI           , -- In  :
            GPO             => M_GPO           , -- Out :
        --------------------------------------------------------------------------
        -- 各種状態出力.
        --------------------------------------------------------------------------
            REPORT_STATUS   => M_REPORT        , -- Out :
            FINISH          => M_FINISH          -- Out :
    );
    -------------------------------------------------------------------------------
    -- 
    -------------------------------------------------------------------------------
    process begin
        loop
            ACLK <= '0'; wait for PERIOD / 2;
            ACLK <= '1'; wait for PERIOD / 2;
            exit when(C_FINISH = '1');
        end loop;
            ACLK <= '0';
        wait;
    end process;

    ARESETn  <= '1' when (RESET = '0') else '0';
    C_GPI(0) <= IRQ;
    C_GPI(C_GPI'high downto 1) <= (C_GPI'high downto 1 => '0');
    M_GPI    <= (others => '0');
        
    process
        variable L   : LINE;
        constant T   : STRING(1 to 7) := "  ***  ";
    begin
        wait until (C_FINISH'event and C_FINISH = '1');
        wait for DELAY;
        WRITE(L,T);                                                   WRITELINE(OUTPUT,L);
        WRITE(L,T & "ERROR REPORT " & NAME);                          WRITELINE(OUTPUT,L);
        WRITE(L,T & "[ CSR ]");                                       WRITELINE(OUTPUT,L);
        WRITE(L,T & "  Error    : ");WRITE(L,C_REPORT.error_count   );WRITELINE(OUTPUT,L);
        WRITE(L,T & "  Mismatch : ");WRITE(L,C_REPORT.mismatch_count);WRITELINE(OUTPUT,L);
        WRITE(L,T & "  Warning  : ");WRITE(L,C_REPORT.warning_count );WRITELINE(OUTPUT,L);
        WRITE(L,T);                                                   WRITELINE(OUTPUT,L);
        WRITE(L,T & "[ TRAFFIC ]");                                   WRITELINE(OUTPUT,L);
        WRITE(L,T & "  Error    : ");WRITE(L,M_REPORT.error_count   );WRITELINE(OUTPUT,L);
        WRITE(L,T & "  Mismatch : ");WRITE(L,M_REPORT.mismatch_count);WRITELINE(OUTPUT,L);
        WRITE(L,T & "  Warning  : ");WRITE(L,M_REPORT.warning_count );WRITELINE(OUTPUT,L);
        WRITE(L,T);                                                   WRITELINE(OUTPUT,L);
        assert (C_REPORT.error_count    = 0 and
                M_REPORT.error_count    = 0)
            report "Simulation complete(error)."    severity FAILURE;
        assert (C_REPORT.mismatch_count = 0 and
                M_REPORT.mismatch_count = 0)
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
library DUMMY_PLUG;
use     DUMMY_PLUG.AXI4_TYPES.all;
entity  AXI_TRAFFIC_CHECKER_TEST_BENCH_32_64 is
    generic (
        NAME            : STRING                                 := "test_32_64";
        SCENARIO_FILE   : STRING                                 := "test_32_64.snr";
        M_DATA_WIDTH    : integer range 8 to AXI4_DATA_MAX_WIDTH := 32;
        M_MAX_XFER_SIZE : integer                                :=  6;
        FINISH_ABORT    : boolean                                := FALSE
    );
end     AXI_TRAFFIC_CHECKER_TEST_BENCH_32_64;
architecture MODEL of AXI_TRAFFIC_CHECKER_TEST_BENCH_32_64 is
begin
    TB: entity work.AXI_TRAFFIC_CHECKER_TEST_BENCH generic map(
        NAME            => NAME            ,
        SCENARIO_FILE   => SCENARIO_FILE   ,   
        M_DATA_WIDTH    => M_DATA_WIDTH    ,
        M_MAX_XFER_SIZE => M_MAX_XFER_SIZE ,
        FINISH_ABORT    => FINISH_ABORT
    );
end MODEL;
-----------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------
library ieee;
use     ieee.std_logic_1164.all;
library DUMMY_PLUG;
use     DUMMY_PLUG.AXI4_TYPES.all;
entity  AXI_TRAFFIC_CHECKER_TEST_BENCH_64_64 is
    generic (
        NAME            : STRING                                 := "test_64_64";
        SCENARIO_FILE   : STRING                                 := "test_64_64.snr";
        M_DATA_WIDTH    : integer range 8 to AXI4_DATA_MAX_WIDTH := 64;
        M_MAX_XFER_SIZE : integer                                :=  6;
        FINISH_ABORT    : boolean                                := FALSE
    );
end     AXI_TRAFFIC_CHECKER_TEST_BENCH_64_64;
architecture MODEL of AXI_TRAFFIC_CHECKER_TEST_BENCH_64_64 is
begin
    TB: entity work.AXI_TRAFFIC_CHECKER_TEST_BENCH generic map(
        NAME            => NAME            ,
        SCENARIO_FILE   => SCENARIO_FILE   ,   
        M_DATA_WIDTH    => M_DATA_WIDTH    ,
        M_MAX_XFER_SIZE => M_MAX_XFER_SIZE ,
        FINISH_ABORT    => FINISH_ABORT
    );
end MODEL;
