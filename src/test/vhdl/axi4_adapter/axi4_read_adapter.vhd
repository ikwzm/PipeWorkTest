-----------------------------------------------------------------------------------
--!     @file    aix4_read_adapter.vhd
--!     @brief   AXI4_READ_ADPATER
--!     @version 0.0.1
--!     @date    2013/5/16
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
library PIPEWORK;
use     PIPEWORK.AXI4_TYPES.all;
-----------------------------------------------------------------------------------
--! @brief   AXI4-AXI4 Read Adapter
-----------------------------------------------------------------------------------
entity  AXI4_READ_ADAPTER is
    -------------------------------------------------------------------------------
    -- ジェネリック変数.
    -------------------------------------------------------------------------------
    generic (
        AXI4_ID_WIDTH       : --! @brief AXI4 ID WIDTH :
                              --! AXI4 アドレスチャネルおよびライトレスポンスチャネ
                              --! ルのID信号のビット幅.
                              integer range 1 to AXI4_ID_MAX_WIDTH;
        AXI4_AUSER_WIDTH    : --! @brief AXI4 ADDRESS USER WIDTH :
                              --! AXI4 アドレスチャネルおよびライトレスポンスチャネ
                              --! ルのAUSER信号のビット幅.
                              integer := 1;
        AXI4_ADDR_WIDTH     : --! @brief RESPONDER AIX4 ADDRESS CHANNEL ADDR WIDTH :
                              --! AXI4 ライトアドレスチャネルのAWADDR信号のビット幅.
                              integer range 1 to AXI4_ADDR_MAX_WIDTH := 32;
        T_CLK_RATE          : --! @brief RESPONDER CLOCK RATE :
                              --! M_CLK_RATEとペアでレスポンダ側のクロック(T_CLK)と
                              --! リクエスト側のクロック(M_CLK)との関係を指定する.
                              --! 詳細は PipeWork.Components の SYNCRONIZER を参照.
                              integer :=  1;
        T_DATA_WIDTH        : --! @brief RESPONDER AXI4 WRITE DATA CHANNEL DATA WIDTH :
                              --! AXI4 ライトデータチャネルのWDATA信号のビット幅.
                              integer range 8 to AXI4_DATA_MAX_WIDTH := 32;
        M_CLK_RATE          : --! @brief REQUESTER CLOCK RATE :
                              --! T_CLK_RATEとペアでレスポンダ側のクロック(T_CLK)と
                              --! リクエスト側のクロック(M_CLK)との関係を指定する.
                              --! 詳細は PipeWork.Components の SYNCRONIZER を参照.
                              integer :=  1;
        M_DATA_WIDTH        : --! @brief REQUESTER AXI4 WRITE DATA CHANNEL DATA WIDTH :
                              --! AXI4 ライトデータチャネルのWDATA信号のビット幅.
                              integer range 8 to AXI4_DATA_MAX_WIDTH := 32;
        M_MAX_XFER_SIZE     : integer := 12;
        BUF_DEPTH           : --! @brief Buffer Depth :
                              --! バッファの容量(バイト数)を２のべき乗値で指定する.
                              integer := 12
    );
    port(
    ------------------------------------------------------------------------------
    -- Reset Signals.
    ------------------------------------------------------------------------------
        RST                 : in    std_logic;
    ------------------------------------------------------------------------------
    -- Responder Signals.
    ------------------------------------------------------------------------------
        T_CLK               : in    std_logic;
        T_CKE               : in    std_logic;
        T_CLR               : in    std_logic;
        T_ARID              : in    std_logic_vector(AXI4_ID_WIDTH   -1 downto 0);
        T_ARUSER            : in    std_logic_vector(AXI4_AUSER_WIDTH-1 downto 0);
        T_ARADDR            : in    std_logic_vector(AXI4_ADDR_WIDTH -1 downto 0);
        T_ARLEN             : in    AXI4_ALEN_TYPE;
        T_ARSIZE            : in    AXI4_ASIZE_TYPE;
        T_ARBURST           : in    AXI4_ABURST_TYPE;
        T_ARLOCK            : in    AXI4_ALOCK_TYPE;
        T_ARCACHE           : in    AXI4_ACACHE_TYPE;
        T_ARPROT            : in    AXI4_APROT_TYPE;
        T_ARQOS             : in    AXI4_AQOS_TYPE;
        T_ARREGION          : in    AXI4_AREGION_TYPE;
        T_ARVALID           : in    std_logic;
        T_ARREADY           : out   std_logic;
        T_RID               : out   std_logic_vector(AXI4_ID_WIDTH   -1 downto 0);
        T_RDATA             : out   std_logic_vector(T_DATA_WIDTH    -1 downto 0);
        T_RRESP             : out   AXI4_RESP_TYPE;
        T_RLAST             : out   std_logic;
        T_RVALID            : out   std_logic;
        T_RREADY            : in    std_logic;
    ------------------------------------------------------------------------------
    -- Requester Signals.
    ------------------------------------------------------------------------------
        M_CLK               : in    std_logic;
        M_CKE               : in    std_logic;
        M_CLR               : in    std_logic;
        M_ARID              : out   std_logic_vector(AXI4_ID_WIDTH   -1 downto 0);
        M_ARUSER            : out   std_logic_vector(AXI4_AUSER_WIDTH-1 downto 0);
        M_ARADDR            : out   std_logic_vector(AXI4_ADDR_WIDTH -1 downto 0);
        M_ARLEN             : out   AXI4_ALEN_TYPE;
        M_ARSIZE            : out   AXI4_ASIZE_TYPE;
        M_ARBURST           : out   AXI4_ABURST_TYPE;
        M_ARLOCK            : out   AXI4_ALOCK_TYPE;
        M_ARCACHE           : out   AXI4_ACACHE_TYPE;
        M_ARPROT            : out   AXI4_APROT_TYPE;
        M_ARQOS             : out   AXI4_AQOS_TYPE;
        M_ARREGION          : out   AXI4_AREGION_TYPE;
        M_ARVALID           : out   std_logic;
        M_ARREADY           : in    std_logic;
        M_RID               : in    std_logic_vector(AXI4_ID_WIDTH   -1 downto 0);
        M_RDATA             : in    std_logic_vector(M_DATA_WIDTH    -1 downto 0);
        M_RRESP             : in    AXI4_RESP_TYPE;
        M_RLAST             : in    std_logic;
        M_RVALID            : in    std_logic;
        M_RREADY            : out   std_logic
    );
end AXI4_READ_ADAPTER;
-----------------------------------------------------------------------------------
-- 
-----------------------------------------------------------------------------------
library ieee;
use     ieee.std_logic_1164.all;
use     ieee.numeric_std.all;
library PIPEWORK;
use     PIPEWORK.COMPONENTS.SDPRAM;
use     PIPEWORK.PIPE_COMPONENTS.PIPE_CORE_UNIT;
use     PIPEWORK.AXI4_COMPONENTS.AXI4_MASTER_READ_INTERFACE;
use     PIPEWORK.AXI4_COMPONENTS.AXI4_SLAVE_READ_INTERFACE;
architecture RTL of AXI4_READ_ADAPTER is
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    function  CALC_BUF_WIDTH return integer is
        variable bits  : integer;
        variable width : integer;
    begin
        if (M_DATA_WIDTH > T_DATA_WIDTH) then
            bits := M_DATA_WIDTH;
        else
            bits := T_DATA_WIDTH;
        end if;
        width := 0;
        while (2**width < bits) loop
            width := width + 1;
        end loop;
        return width;
    end function;
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    constant  BUF_WIDTH         : integer := CALC_BUF_WIDTH;
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    constant  MODE_LO           : integer := 0;
    constant  MODE_ID_LO        : integer := MODE_LO;
    constant  MODE_ID_HI        : integer := MODE_ID_LO     + AXI4_ID_WIDTH     - 1;
    constant  MODE_ABURST_LO    : integer := MODE_ID_HI     + 1;
    constant  MODE_ABURST_HI    : integer := MODE_ABURST_LO + AXI4_ABURST_WIDTH - 1;
    constant  MODE_ALOCK_LO     : integer := MODE_ABURST_HI + 1;
    constant  MODE_ALOCK_HI     : integer := MODE_ALOCK_LO  + AXI4_ALOCK_WIDTH  - 1;
    constant  MODE_ACACHE_LO    : integer := MODE_ALOCK_HI  + 1;
    constant  MODE_ACACHE_HI    : integer := MODE_ACACHE_LO + AXI4_ACACHE_WIDTH - 1;
    constant  MODE_APROT_LO     : integer := MODE_ACACHE_HI + 1;
    constant  MODE_APROT_HI     : integer := MODE_APROT_LO  + AXI4_APROT_WIDTH  - 1;
    constant  MODE_AQOS_LO      : integer := MODE_APROT_HI  + 1;
    constant  MODE_AQOS_HI      : integer := MODE_AQOS_LO   + AXI4_AQOS_WIDTH   - 1;
    constant  MODE_AREGION_LO   : integer := MODE_AQOS_HI   + 1;
    constant  MODE_AREGION_HI   : integer := MODE_AREGION_LO+ AXI4_AREGION_WIDTH- 1;
    constant  MODE_AUSER_LO     : integer := MODE_AREGION_HI+ 1;
    constant  MODE_AUSER_HI     : integer := MODE_AUSER_LO  + AXI4_AUSER_WIDTH  - 1;
    constant  MODE_HI           : integer := MODE_AUSER_HI;
    constant  MODE_BITS         : integer := MODE_HI        + 1;
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    constant  SIZE_BITS         : integer := 13;
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    constant  T_MAX_XFER_SIZE   : integer := 12;
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    function  MAKE_POOL_SIZE return std_logic_vector is
        variable pool_size : std_logic_vector(SIZE_BITS-1 downto 0);
    begin
        for i in pool_size'range loop
            if (BUF_DEPTH <= pool_size'high and i = BUF_DEPTH     ) or
               (BUF_DEPTH  > pool_size'high and i = pool_size'high) then
                pool_size(i) := '1';
            else
                pool_size(i) := '0';
            end if;
        end loop;
        return pool_size;
    end function;
    constant  POOL_SIZE         : std_logic_vector(SIZE_BITS-1 downto 0) := MAKE_POOL_SIZE;
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    signal    t_req_id          : std_logic_vector(AXI4_ID_WIDTH  -1 downto 0);
    signal    t_req_addr        : std_logic_vector(AXI4_ADDR_WIDTH-1 downto 0);
    signal    t_req_size        : std_logic_vector(SIZE_BITS-1 downto 0);
    signal    t_req_buf_ptr     : std_logic_vector(BUF_DEPTH-1 downto 0);
    signal    t_req_mode        : std_logic_vector(MODE_BITS-1 downto 0);
    signal    t_req_burst       : AXI4_ABURST_TYPE;
    constant  t_req_dir         : std_logic := '0';
    signal    t_req_first       : std_logic;
    signal    t_req_last        : std_logic;
    signal    t_req_valid       : std_logic;
    signal    t_req_ready       : std_logic;
    signal    t_ack_valid       : std_logic;
    signal    t_ack_next        : std_logic;
    signal    t_ack_last        : std_logic;
    signal    t_ack_error       : std_logic;
    signal    t_ack_stop        : std_logic;
    signal    t_ack_size        : std_logic_vector(SIZE_BITS-1 downto 0);
    constant  t_i_valve_open    : std_logic := '1';
    signal    t_i_flow_rdy      : std_logic;
    signal    t_i_flow_pause    : std_logic;
    signal    t_i_flow_stop     : std_logic;
    signal    t_i_flow_last     : std_logic;
    signal    t_i_flow_size     : std_logic_vector(SIZE_BITS-1 downto 0);
    signal    t_i_pool_rdy      : std_logic;
    constant  t_i_flow_rdy_lvl  : std_logic_vector(SIZE_BITS-1 downto 0) := (others => '0');
    constant  t_i_pool_rdy_lvl  : std_logic_vector(SIZE_BITS-1 downto 0) := (others => '0');
    constant  t_push_fin_val    : std_logic := '0';
    constant  t_push_fin_last   : std_logic := '0';
    constant  t_push_fin_err    : std_logic := '0';
    constant  t_push_fin_size   : std_logic_vector(SIZE_BITS-1 downto 0) := (others => '0');
    constant  t_push_rsv_val    : std_logic := '0';
    constant  t_push_rsv_last   : std_logic := '0';
    constant  t_push_rsv_err    : std_logic := '0';
    constant  t_push_rsv_size   : std_logic_vector(SIZE_BITS-1 downto 0) := (others => '0');
    signal    t_o_valve_open    : std_logic;
    signal    t_o_flow_rdy      : std_logic;
    signal    t_o_flow_pause    : std_logic;
    signal    t_o_flow_stop     : std_logic;
    signal    t_o_flow_last     : std_logic;
    signal    t_o_flow_size     : std_logic_vector(SIZE_BITS-1 downto 0);
    signal    t_o_pool_rdy      : std_logic;
    constant  t_o_flow_rdy_lvl  : std_logic_vector(SIZE_BITS-1 downto 0)
                               := std_logic_vector(to_unsigned(2**M_MAX_XFER_SIZE, SIZE_BITS));
    constant  t_o_pool_rdy_lvl  : std_logic_vector(SIZE_BITS-1 downto 0)
                               := std_logic_vector(to_unsigned(M_DATA_WIDTH      , SIZE_BITS));
    signal    t_pull_fin_val    : std_logic;
    signal    t_pull_fin_last   : std_logic;
    signal    t_pull_fin_err    : std_logic;
    signal    t_pull_fin_size   : std_logic_vector(SIZE_BITS-1 downto 0);
    signal    t_pull_rsv_val    : std_logic;
    signal    t_pull_rsv_last   : std_logic;
    signal    t_pull_rsv_err    : std_logic;
    signal    t_pull_rsv_size   : std_logic_vector(SIZE_BITS-1 downto 0);
    signal    t_pool_read       : std_logic;
    signal    t_pool_ben        : std_logic_vector(2**(BUF_WIDTH-3)-1 downto 0);
    signal    t_pool_rdata      : std_logic_vector(2**(BUF_WIDTH  )-1 downto 0);
    signal    t_pool_rptr       : std_logic_vector(BUF_DEPTH-1 downto 0);
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    constant  m_req_speculative : std_logic := '0';
    constant  m_req_safety      : std_logic := '0';
    constant  m_xfer_size_sel   : std_logic_vector(M_MAX_XFER_SIZE downto M_MAX_XFER_SIZE) := "1";
    signal    m_req_id          : std_logic_vector(AXI4_ID_WIDTH  -1 downto 0);
    signal    m_req_addr        : std_logic_vector(AXI4_ADDR_WIDTH-1 downto 0);
    signal    m_req_size        : std_logic_vector(SIZE_BITS-1 downto 0);
    signal    m_req_buf_ptr     : std_logic_vector(BUF_DEPTH-1 downto 0);
    signal    m_req_mode        : std_logic_vector(MODE_BITS-1 downto 0);
    signal    m_req_burst       : AXI4_ABURST_TYPE;
    signal    m_req_lock        : AXI4_ALOCK_TYPE;
    signal    m_req_cache       : AXI4_ACACHE_TYPE;
    signal    m_req_prot        : AXI4_APROT_TYPE;
    signal    m_req_qos         : AXI4_AQOS_TYPE;
    signal    m_req_region      : AXI4_AREGION_TYPE;
    signal    m_req_dir         : std_logic;
    signal    m_req_first       : std_logic;
    signal    m_req_last        : std_logic;
    signal    m_req_valid       : std_logic;
    signal    m_req_ready       : std_logic;
    signal    m_ack_valid       : std_logic;
    signal    m_ack_next        : std_logic;
    signal    m_ack_last        : std_logic;
    signal    m_ack_error       : std_logic;
    signal    m_ack_stop        : std_logic;
    signal    m_ack_none        : std_logic;
    signal    m_ack_size        : std_logic_vector(SIZE_BITS-1 downto 0);
    signal    m_i_flow_pause    : std_logic;
    signal    m_i_flow_stop     : std_logic;
    signal    m_i_flow_last     : std_logic;
    signal    m_i_flow_size     : std_logic_vector(SIZE_BITS-1 downto 0);
    signal    m_i_flow_rdy      : std_logic;
    signal    m_i_pool_rdy      : std_logic;
    constant  m_i_flow_rdy_lvl  : std_logic_vector(SIZE_BITS-1 downto 0)
                               := std_logic_vector(to_unsigned(2**BUF_DEPTH-2**M_MAX_XFER_SIZE, SIZE_BITS));
    constant  m_i_pool_rdy_lvl  : std_logic_vector(SIZE_BITS-1 downto 0)
                               := std_logic_vector(to_unsigned(2**BUF_DEPTH-M_DATA_WIDTH      , SIZE_BITS));
    signal    m_push_fin_val    : std_logic;
    signal    m_push_fin_last   : std_logic;
    signal    m_push_fin_err    : std_logic;
    signal    m_push_fin_size   : std_logic_vector(SIZE_BITS-1 downto 0);
    signal    m_push_rsv_val    : std_logic;
    signal    m_push_rsv_last   : std_logic;
    signal    m_push_rsv_err    : std_logic;
    signal    m_push_rsv_size   : std_logic_vector(SIZE_BITS-1 downto 0);
    signal    m_o_flow_pause    : std_logic;
    signal    m_o_flow_stop     : std_logic;
    signal    m_o_flow_last     : std_logic;
    signal    m_o_flow_size     : std_logic_vector(SIZE_BITS-1 downto 0);
    signal    m_o_flow_rdy      : std_logic;
    signal    m_o_pool_rdy      : std_logic;
    constant  m_o_flow_rdy_lvl  : std_logic_vector(SIZE_BITS-1 downto 0) := (others => '0');
    constant  m_o_pool_rdy_lvl  : std_logic_vector(SIZE_BITS-1 downto 0) := (others => '0');
    constant  m_pull_fin_val    : std_logic := '0';
    constant  m_pull_fin_last   : std_logic := '0';
    constant  m_pull_fin_err    : std_logic := '0';
    constant  m_pull_fin_size   : std_logic_vector(SIZE_BITS-1 downto 0) := (others => '0');
    constant  m_pull_rsv_val    : std_logic := '0';
    constant  m_pull_rsv_last   : std_logic := '0';
    constant  m_pull_rsv_err    : std_logic := '0';
    constant  m_pull_rsv_size   : std_logic_vector(SIZE_BITS-1 downto 0) := (others => '0');
    signal    m_pool_rdy        : std_logic;
    signal    m_pool_write      : std_logic;
    signal    m_pool_wdata      : std_logic_vector(2**(BUF_WIDTH  )-1 downto 0);
    signal    m_pool_ben        : std_logic_vector(2**(BUF_WIDTH-3)-1 downto 0);
    signal    m_pool_we         : std_logic_vector(2**(BUF_WIDTH-3)-1 downto 0);
    signal    m_pool_wptr       : std_logic_vector(BUF_DEPTH-1 downto 0);
begin
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    T_IF: AXI4_SLAVE_READ_INTERFACE                      -- 
        generic map (                                    -- 
            AXI4_ADDR_WIDTH     => AXI4_ADDR_WIDTH     , -- 
            AXI4_ID_WIDTH       => AXI4_ID_WIDTH       , -- 
            AXI4_DATA_WIDTH     => T_DATA_WIDTH        , -- 
            SIZE_BITS           => SIZE_BITS           , -- 
            BUF_DATA_WIDTH      => 2**BUF_WIDTH        , -- 
            BUF_PTR_BITS        => BUF_DEPTH             -- 
        )                                                -- 
        port map(                                        -- 
        ---------------------------------------------------------------------------
        -- Clock and Reset Signals.
        ---------------------------------------------------------------------------
            RST                 => RST                 , -- In  :
            CLK                 => T_CLK               , -- In  :
            CLR                 => T_CLR               , -- In  :
        ---------------------------------------------------------------------------
        -- AXI4 Write Signals.
        ---------------------------------------------------------------------------
            ARID                => T_ARID              , -- In  :
            ARADDR              => T_ARADDR            , -- In  :
            ARLEN               => T_ARLEN             , -- In  :
            ARSIZE              => T_ARSIZE            , -- In  :
            ARBURST             => T_ARBURST           , -- In  :
            ARVALID             => T_ARVALID           , -- In  :
            ARREADY             => T_ARREADY           , -- Out :
            RID                 => T_RID               , -- Out :
            RDATA               => T_RDATA             , -- Out :
            RRESP               => T_RRESP             , -- Out :
            RLAST               => T_RLAST             , -- Out :
            RVALID              => T_RVALID            , -- Out :
            RREADY              => T_RREADY            , -- In  :
        ---------------------------------------------------------------------------
        -- Command Request Signals.
        ---------------------------------------------------------------------------
            REQ_ADDR            => t_req_addr          , -- Out :
            REQ_SIZE            => t_req_size          , -- Out :
            REQ_ID              => t_req_id            , -- Out :
            REQ_BURST           => t_req_burst         , -- Out :
            REQ_BUF_PTR         => t_req_buf_ptr       , -- Out :
            REQ_FIRST           => t_req_first         , -- Out :
            REQ_LAST            => t_req_last          , -- Out :
            REQ_VAL             => t_req_valid         , -- Out :
            REQ_RDY             => t_req_ready         , -- In  :
        ---------------------------------------------------------------------------
        -- Command Acknowledge Signals.
        ---------------------------------------------------------------------------
            ACK_VAL             => t_ack_valid         , -- In  :
            ACK_NEXT            => t_ack_next          , -- In  :
            ACK_LAST            => t_ack_last          , -- In  :
            ACK_ERROR           => t_ack_error         , -- In  :
            ACK_SIZE            => t_ack_size          , -- In  :
        ---------------------------------------------------------------------------
        -- Transfer Status Signal.
        ---------------------------------------------------------------------------
            XFER_BUSY           => open                , -- Out :
        ---------------------------------------------------------------------------
        -- Flow Control Signals.
        ---------------------------------------------------------------------------
            VALVE_OPEN          => t_o_valve_open      , -- Out :
        ---------------------------------------------------------------------------
        -- Reserve Size Signals.
        ---------------------------------------------------------------------------
            RESV_VAL            => t_pull_rsv_val      , -- Out :
            RESV_LAST           => t_pull_rsv_last     , -- Out :
            RESV_ERROR          => t_pull_rsv_err      , -- Out :
            RESV_SIZE           => t_pull_rsv_size     , -- Out :
        ---------------------------------------------------------------------------
        -- Push Size Signals.
        ---------------------------------------------------------------------------
            PULL_VAL            => t_pull_fin_val      , -- Out :
            PULL_LAST           => t_pull_fin_last     , -- Out :
            PULL_ERROR          => t_pull_fin_err      , -- Out :
            PULL_SIZE           => t_pull_fin_size     , -- Out :
        ---------------------------------------------------------------------------
        -- Read Buffer Interface Signals.
        ---------------------------------------------------------------------------
            BUF_REN             => t_pool_read         , -- Out :
            BUF_BEN             => t_pool_ben          , -- Out :
            BUF_DATA            => t_pool_rdata        , -- In  :
            BUF_PTR             => t_pool_rptr         , -- Out :
            BUF_RDY             => t_o_pool_rdy          -- In  :
        );
    t_req_mode(MODE_ID_HI      downto MODE_ID_LO     ) <= t_req_id;
    t_req_mode(MODE_ABURST_HI  downto MODE_ABURST_LO ) <= t_req_burst;
    t_req_mode(MODE_ALOCK_HI   downto MODE_ALOCK_LO  ) <= T_ARLOCK;
    t_req_mode(MODE_ACACHE_HI  downto MODE_ACACHE_LO ) <= T_ARCACHE;
    t_req_mode(MODE_APROT_HI   downto MODE_APROT_LO  ) <= T_ARPROT;
    t_req_mode(MODE_AQOS_HI    downto MODE_AQOS_LO   ) <= T_ARQOS;
    t_req_mode(MODE_AREGION_HI downto MODE_AREGION_LO) <= T_ARREGION;
    t_req_mode(MODE_AUSER_HI   downto MODE_AUSER_LO  ) <= T_ARUSER;
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    PIPE: PIPE_CORE_UNIT                                 -- 
        generic map (                                    -- 
            PUSH_VALID          => 0                   , --
            PULL_VALID          => 1                   , --
            T_CLK_RATE          => T_CLK_RATE          , --
            M_CLK_RATE          => M_CLK_RATE          , --
            ADDR_BITS           => AXI4_ADDR_WIDTH     , --
            ADDR_VALID          => 1                   , --
            SIZE_BITS           => SIZE_BITS           , --
            SIZE_VALID          => 1                   , --
            MODE_BITS           => MODE_BITS           , --
            BUF_DEPTH           => BUF_DEPTH           , --
            M_COUNT_BITS        => SIZE_BITS           , --
            T_COUNT_BITS        => SIZE_BITS           , --
            M_O_VALVE_FIXED     => 1                   , --
            M_O_VALVE_PRECEDE   => 0                   , --
            M_I_VALVE_FIXED     => 0                   , --
            M_I_VALVE_PRECEDE   => 0                   , --
            T_O_VALVE_FIXED     => 0                   , --
            T_O_VALVE_PRECEDE   => 1                   , --
            T_I_VALVE_FIXED     => 1                   , --
            T_I_VALVE_PRECEDE   => 0                   , --
            T2M_PUSH_FIN_DELAY  => 1                   , --
            M2T_PUSH_FIN_DELAY  => 0                   , --
            T_XFER_MAX_SIZE     => T_MAX_XFER_SIZE       --
        )                                                --
        port map (                                       --
        ---------------------------------------------------------------------------
        -- リセット信号.
        ---------------------------------------------------------------------------
            RST                 => RST                 , -- In  :
        ---------------------------------------------------------------------------
        -- レスポンダ側クロック.
        ---------------------------------------------------------------------------
            T_CLK               => T_CLK               , -- In  :
            T_CLR               => T_CLR               , -- In  :
            T_CKE               => T_CKE               , -- In  :
        ---------------------------------------------------------------------------
        -- レスポンダ側からの要求信号入力.
        ---------------------------------------------------------------------------
            T_REQ_ADDR          => t_req_addr          , -- In  :
            T_REQ_SIZE          => t_req_size          , -- In  :
            T_REQ_BUF_PTR       => t_req_buf_ptr       , -- In  :
            T_REQ_MODE          => t_req_mode          , -- In  :
            T_REQ_DIR           => t_req_dir           , -- In  :
            T_REQ_FIRST         => t_req_first         , -- In  :
            T_REQ_LAST          => t_req_last          , -- In  :
            T_REQ_VALID         => t_req_valid         , -- In  :
            T_REQ_READY         => t_req_ready         , -- Out :
        ---------------------------------------------------------------------------
        -- レスポンダ側への応答信号出力.
        ---------------------------------------------------------------------------
            T_ACK_VALID         => t_ack_valid         , -- Out :
            T_ACK_NEXT          => t_ack_next          , -- Out :
            T_ACK_LAST          => t_ack_last          , -- Out :
            T_ACK_ERROR         => t_ack_error         , -- Out :
            T_ACK_STOP          => t_ack_stop          , -- Out :
            T_ACK_SIZE          => t_ack_size          , -- Out :
        ---------------------------------------------------------------------------
        -- レスポンダ側からデータ入力のフロー制御信号入出力.
        ---------------------------------------------------------------------------
            T_I_VALVE_OPEN      => t_i_valve_open      , -- In  :
            T_I_FLOW_RDY        => t_i_flow_rdy        , -- Out :
            T_I_FLOW_PAUSE      => t_i_flow_pause      , -- Out :
            T_I_FLOW_STOP       => t_i_flow_stop       , -- Out :
            T_I_FLOW_LAST       => t_i_flow_last       , -- Out :
            T_I_FLOW_SIZE       => t_i_flow_size       , -- Out :
            T_I_POOL_RDY        => t_i_pool_rdy        , -- Out :
            T_I_FLOW_RDY_LVL    => t_i_flow_rdy_lvl    , -- In  :
            T_I_POOL_RDY_LVL    => t_i_pool_rdy_lvl    , -- In  :
            T_I_POOL_SIZE       => POOL_SIZE           , -- In  :
            T_PUSH_FIN_VAL      => t_push_fin_val      , -- In  :
            T_PUSH_FIN_LAST     => t_push_fin_last     , -- In  :
            T_PUSH_FIN_ERR      => t_push_fin_err      , -- In  :
            T_PUSH_FIN_SIZE     => t_push_fin_size     , -- In  :
            T_PUSH_RSV_VAL      => t_push_rsv_val      , -- In  :
            T_PUSH_RSV_LAST     => t_push_rsv_last     , -- In  :
            T_PUSH_RSV_ERR      => t_push_rsv_err      , -- In  :
            T_PUSH_RSV_SIZE     => t_push_rsv_size     , -- In  :
        ---------------------------------------------------------------------------
        -- レスポンダ側へのデータ出力のフロー制御信号入出力
        ---------------------------------------------------------------------------
            T_O_VALVE_OPEN      => t_o_valve_open      , -- In  :
            T_O_FLOW_RDY        => t_o_flow_rdy        , -- Out :
            T_O_FLOW_PAUSE      => t_o_flow_pause      , -- Out :
            T_O_FLOW_STOP       => t_o_flow_stop       , -- Out :
            T_O_FLOW_LAST       => t_o_flow_last       , -- Out :
            T_O_FLOW_SIZE       => t_o_flow_size       , -- Out :
            T_O_POOL_RDY        => t_o_pool_rdy        , -- Out :
            T_O_FLOW_RDY_LVL    => t_o_flow_rdy_lvl    , -- In  :
            T_O_POOL_RDY_LVL    => t_o_pool_rdy_lvl    , -- In  :
            T_PULL_FIN_VAL      => t_pull_fin_val      , -- In  :
            T_PULL_FIN_LAST     => t_pull_fin_last     , -- In  :
            T_PULL_FIN_ERR      => t_pull_fin_err      , -- In  :
            T_PULL_FIN_SIZE     => t_pull_fin_size     , -- In  :
            T_PULL_RSV_VAL      => t_pull_rsv_val      , -- In  :
            T_PULL_RSV_LAST     => t_pull_rsv_last     , -- In  :
            T_PULL_RSV_ERR      => t_pull_rsv_err      , -- In  :
            T_PULL_RSV_SIZE     => t_pull_rsv_size     , -- In  :
        ---------------------------------------------------------------------------
        -- リクエスト側クロック.
        ---------------------------------------------------------------------------
            M_CLK               => M_CLK               , -- In  :
            M_CLR               => M_CLR               , -- In  :
            M_CKE               => M_CKE               , -- In  :
        ---------------------------------------------------------------------------
        -- リクエスタ側への要求信号出力.
        ---------------------------------------------------------------------------
            M_REQ_ADDR          => m_req_addr          , -- Out :
            M_REQ_SIZE          => m_req_size          , -- Out :
            M_REQ_BUF_PTR       => m_req_buf_ptr       , -- Out :
            M_REQ_MODE          => m_req_mode          , -- Out :
            M_REQ_DIR           => m_req_dir           , -- Out :
            M_REQ_FIRST         => m_req_first         , -- Out :
            M_REQ_LAST          => m_req_last          , -- Out :
            M_REQ_VALID         => m_req_valid         , -- Out :
            M_REQ_READY         => m_req_ready         , -- In  :
        ---------------------------------------------------------------------------
        -- リクエスタ側からの応答信号入力.
        ---------------------------------------------------------------------------
            M_ACK_VALID         => m_ack_valid         , -- In  :
            M_ACK_NEXT          => m_ack_next          , -- In  :
            M_ACK_LAST          => m_ack_last          , -- In  :
            M_ACK_ERROR         => m_ack_error         , -- In  :
            M_ACK_STOP          => m_ack_stop          , -- In  :
            M_ACK_NONE          => m_ack_none          , -- In  :
            M_ACK_SIZE          => m_ack_size          , -- In  :
        ---------------------------------------------------------------------------
        -- リクエスタ側からデータ入力のフロー制御信号入出力.
        ---------------------------------------------------------------------------
            M_I_FLOW_PAUSE      => m_i_flow_pause      , -- Out :
            M_I_FLOW_STOP       => m_i_flow_stop       , -- Out :
            M_I_FLOW_LAST       => m_i_flow_last       , -- Out :
            M_I_FLOW_SIZE       => m_i_flow_size       , -- Out :
            M_I_FLOW_RDY        => m_i_flow_rdy        , -- Out :
            M_I_POOL_RDY        => m_pool_rdy          , -- Out :
            M_I_FLOW_RDY_LVL    => m_i_flow_rdy_lvl    , -- In  :
            M_I_POOL_RDY_LVL    => m_i_pool_rdy_lvl    , -- In  :
            M_I_POOL_SIZE       => POOL_SIZE           , -- In  :
            M_PUSH_FIN_VAL      => m_push_fin_val      , -- In  :
            M_PUSH_FIN_LAST     => m_push_fin_last     , -- In  :
            M_PUSH_FIN_ERR      => m_push_fin_err      , -- In  :
            M_PUSH_FIN_SIZE     => m_push_fin_size     , -- In  :
            M_PUSH_RSV_VAL      => m_push_rsv_val      , -- In  :
            M_PUSH_RSV_LAST     => m_push_rsv_last     , -- In  :
            M_PUSH_RSV_ERR      => m_push_rsv_err      , -- In  :
            M_PUSH_RSV_SIZE     => m_push_rsv_size     , -- In  :
        ---------------------------------------------------------------------------
        -- リクエスタ側へのデータ出力のフロー制御信号入出力
        ---------------------------------------------------------------------------
            M_O_FLOW_PAUSE      => m_o_flow_pause      , -- Out :
            M_O_FLOW_STOP       => m_o_flow_stop       , -- Out :
            M_O_FLOW_LAST       => m_o_flow_last       , -- Out :
            M_O_FLOW_SIZE       => m_o_flow_size       , -- Out :
            M_O_FLOW_RDY        => m_o_flow_rdy        , -- Out :
            M_O_POOL_RDY        => m_o_pool_rdy        , -- Out :
            M_O_FLOW_RDY_LVL    => m_o_flow_rdy_lvl    , -- In  :
            M_O_POOL_RDY_LVL    => m_o_pool_rdy_lvl    , -- In  :
            M_PULL_FIN_VAL      => m_pull_fin_val      , -- In  :
            M_PULL_FIN_LAST     => m_pull_fin_last     , -- In  :
            M_PULL_FIN_ERR      => m_pull_fin_err      , -- In  :
            M_PULL_FIN_SIZE     => m_pull_fin_size     , -- In  :
            M_PULL_RSV_VAL      => m_pull_rsv_val      , -- In  :
            M_PULL_RSV_LAST     => m_pull_rsv_last     , -- In  :
            M_PULL_RSV_ERR      => m_pull_rsv_err      , -- In  :
            M_PULL_RSV_SIZE     => m_pull_rsv_size       -- In  :
        );
    m_req_id     <= m_req_mode(MODE_ID_HI      downto MODE_ID_LO     );
    m_req_burst  <= m_req_mode(MODE_ABURST_HI  downto MODE_ABURST_LO );
    m_req_lock   <= m_req_mode(MODE_ALOCK_HI   downto MODE_ALOCK_LO  );
    m_req_cache  <= m_req_mode(MODE_ACACHE_HI  downto MODE_ACACHE_LO );
    m_req_prot   <= m_req_mode(MODE_APROT_HI   downto MODE_APROT_LO  );
    m_req_qos    <= m_req_mode(MODE_AQOS_HI    downto MODE_AQOS_LO   );
    m_req_region <= m_req_mode(MODE_AREGION_HI downto MODE_AREGION_LO);
    M_ARUSER     <= m_req_mode(MODE_AUSER_HI   downto MODE_AUSER_LO  );
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    POOL: SDPRAM                                         --
        generic map (                                    --
            DEPTH   => BUF_DEPTH+3                     , --
            RWIDTH  => BUF_WIDTH                       , --
            WWIDTH  => BUF_WIDTH                       , --
            WEBIT   => BUF_WIDTH-3                     , --
            ID      => 0                                 --
        )                                                --
        port map (                                       --
            WCLK    => M_CLK                           , -- In  :
            WE      => m_pool_we                       , -- In  :
            WADDR   => m_pool_wptr(BUF_DEPTH-1 downto BUF_WIDTH-3), 
            WDATA   => m_pool_wdata                    , -- In  :
            RCLK    => T_CLK                           , -- In  :
            RADDR   => t_pool_rptr(BUF_DEPTH-1 downto BUF_WIDTH-3),
            RDATA   => t_pool_rdata                      -- Out :
        );
    m_pool_we <= m_pool_ben when (m_pool_write = '1') else (others => '0');
    -------------------------------------------------------------------------------
    --
    -------------------------------------------------------------------------------
    M_IF: AXI4_MASTER_READ_INTERFACE                     -- 
        generic map (                                    -- 
            AXI4_ADDR_WIDTH     => AXI4_ADDR_WIDTH     , -- 
            AXI4_ID_WIDTH       => AXI4_ID_WIDTH       , -- 
            AXI4_DATA_WIDTH     => M_DATA_WIDTH        , -- 
            VAL_BITS            => 1                   , -- 
            SIZE_BITS           => SIZE_BITS           , -- 
            REQ_SIZE_BITS       => SIZE_BITS           , -- 
            REQ_SIZE_VALID      => 1                   , -- 
            FLOW_VALID          => 1                   , -- 
            BUF_DATA_WIDTH      => 2**BUF_WIDTH        , -- 
            BUF_PTR_BITS        => BUF_DEPTH           , -- 
            XFER_MIN_SIZE       => M_MAX_XFER_SIZE     , -- 
            XFER_MAX_SIZE       => M_MAX_XFER_SIZE     , -- 
            QUEUE_SIZE          => 1                     -- 
        )                                                -- 
        port map(                                        -- 
        ---------------------------------------------------------------------------
        -- Clock and Reset Signals.
        ---------------------------------------------------------------------------
            RST                 => RST                 , -- In  :
            CLK                 => M_CLK               , -- In  :
            CLR                 => M_CLR               , -- In  :
        ---------------------------------------------------------------------------
        -- AXI4 Write Signals.
        ---------------------------------------------------------------------------
            ARID                => M_ARID              , -- Out :
            ARADDR              => M_ARADDR            , -- Out :
            ARLEN               => M_ARLEN             , -- Out :
            ARSIZE              => M_ARSIZE            , -- Out :
            ARBURST             => M_ARBURST           , -- Out :
            ARLOCK              => M_ARLOCK            , -- Out :
            ARCACHE             => M_ARCACHE           , -- Out :
            ARPROT              => M_ARPROT            , -- Out :
            ARQOS               => M_ARQOS             , -- Out :
            ARREGION            => M_ARREGION          , -- Out :
            ARVALID             => M_ARVALID           , -- Out :
            ARREADY             => M_ARREADY           , -- In  :
            RID                 => M_RID               , -- In  :
            RDATA               => M_RDATA             , -- In  :
            RRESP               => M_RRESP             , -- In  :
            RLAST               => M_RLAST             , -- In  :
            RVALID              => M_RVALID            , -- In  :
            RREADY              => M_RREADY            , -- Out :
        ---------------------------------------------------------------------------
        -- Command Request Signals.
        ---------------------------------------------------------------------------
            XFER_SIZE_SEL       => m_xfer_size_sel     , -- In  :
            REQ_ADDR            => m_req_addr          , -- In  :
            REQ_SIZE            => m_req_size          , -- In  :
            REQ_ID              => m_req_id            , -- In  :
            REQ_BURST           => m_req_burst         , -- In  :
            REQ_LOCK            => m_req_lock          , -- In  :
            REQ_CACHE           => m_req_cache         , -- In  :
            REQ_PROT            => m_req_prot          , -- In  :
            REQ_QOS             => m_req_qos           , -- In  :
            REQ_REGION          => m_req_region        , -- In  :
            REQ_BUF_PTR         => m_req_buf_ptr       , -- In  :
            REQ_FIRST           => m_req_first         , -- In  :
            REQ_LAST            => m_req_last          , -- In  :
            REQ_SPECULATIVE     => m_req_speculative   , -- In  :
            REQ_SAFETY          => m_req_safety        , -- In  :
            REQ_VAL(0)          => m_req_valid         , -- In  :
            REQ_RDY             => m_req_ready         , -- Out :
        ---------------------------------------------------------------------------
        -- Command Acknowledge Signals.
        ---------------------------------------------------------------------------
            ACK_VAL(0)          => m_ack_valid         , -- Out :
            ACK_NEXT            => m_ack_next          , -- Out :
            ACK_LAST            => m_ack_last          , -- Out :
            ACK_ERROR           => m_ack_error         , -- Out :
            ACK_STOP            => m_ack_stop          , -- Out :
            ACK_NONE            => m_ack_none          , -- Out :
            ACK_SIZE            => m_ack_size          , -- Out :
        ---------------------------------------------------------------------------
        -- Transfer Status Signal.
        ---------------------------------------------------------------------------
            XFER_BUSY           => open                , -- Out :
        ---------------------------------------------------------------------------
        -- Flow Control Signals.
        ---------------------------------------------------------------------------
            FLOW_STOP           => m_i_flow_stop       , -- In  :
            FLOW_PAUSE          => m_i_flow_pause      , -- In  :
            FLOW_LAST           => m_i_flow_last       , -- In  :
            FLOW_SIZE           => m_i_flow_size       , -- In  :
        ---------------------------------------------------------------------------
        -- Reserve Size Signals.
        ---------------------------------------------------------------------------
            RESV_VAL(0)         => m_push_rsv_val      , -- Out :
            RESV_LAST           => m_push_rsv_last     , -- Out :
            RESV_ERROR          => m_push_rsv_err      , -- Out :
            RESV_SIZE           => m_push_rsv_size     , -- Out :
        ---------------------------------------------------------------------------
        -- Pull Size Signals.
        ---------------------------------------------------------------------------
            PUSH_VAL(0)         => m_push_fin_val      , -- Out :
            PUSH_LAST           => m_push_fin_last     , -- Out :
            PUSH_ERROR          => m_push_fin_err      , -- Out :
            PUSH_SIZE           => m_push_fin_size     , -- Out :
        ---------------------------------------------------------------------------
        -- Read Buffer Interface Signals.
        ---------------------------------------------------------------------------
            BUF_WEN(0)          => m_pool_write        , -- Out :
            BUF_BEN             => m_pool_ben          , -- Out :
            BUF_DATA            => m_pool_wdata        , -- Out :
            BUF_PTR             => m_pool_wptr         , -- Out :
            BUF_RDY             => m_pool_rdy            -- In  :
        );
end RTL;