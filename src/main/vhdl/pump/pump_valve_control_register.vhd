-----------------------------------------------------------------------------------
--!     @file    pump_valve_control_register.vhd
--!     @brief   PUMP VALVE CONTROL REGISTER
--!     @version 1.0.1
--!     @date    2013/1/4
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
--! @brief   PUMP VALVE CONTROL REGISTER :
-----------------------------------------------------------------------------------
entity  PUMP_VALVE_CONTROL_REGISTER is
    generic (
        MODE_BITS       : --! @brief MODE REGISTER BITS :
                          integer := 32;
        STAT_BITS       : --! @brief STATUS REGISTER BITS :
                          integer := 32;
        SIZE_BITS       : --! @brief COUNTER SIZE BITS :
                          --! 各種サイズ信号のビット数を指定する.
                          integer := 32;
        FLOW_SINK       : --! @brief FLOW SINK MODE :
                          integer := 0
    );
    port (
    -------------------------------------------------------------------------------
    -- Clock & Reset Signals.
    -------------------------------------------------------------------------------
        CLK             : --! @brief CLOCK :
                          --! クロック信号
                          in  std_logic; 
        RST             : --! @brief ASYNCRONOUSE RESET :
                          --! 非同期リセット信号.アクティブハイ.
                          in  std_logic;
        CLR             : --! @brief SYNCRONOUSE RESET :
                          --! 同期リセット信号.アクティブハイ.
                          in  std_logic;
    -------------------------------------------------------------------------------
    -- RESET Bit Register Access Interface.
    -------------------------------------------------------------------------------
        RESET_WRITE     : in  std_logic;
        RESET_WDATA     : in  std_logic;
        RESET_RDATA     : out std_logic;
    -------------------------------------------------------------------------------
    -- START Bit Register Access Interface.
    -------------------------------------------------------------------------------
        START_WRITE     : in  std_logic;
        START_WDATA     : in  std_logic;
        START_RDATA     : out std_logic;
    -------------------------------------------------------------------------------
    -- STOP Bit Register Access Interface.
    -------------------------------------------------------------------------------
        STOP_WRITE      : in  std_logic;
        STOP_WDATA      : in  std_logic;
        STOP_RDATA      : out std_logic;
    -------------------------------------------------------------------------------
    -- PAUSE Bit Register Access Interface.
    -------------------------------------------------------------------------------
        PAUSE_WRITE     : in  std_logic;
        PAUSE_WDATA     : in  std_logic;
        PAUSE_RDATA     : out std_logic;
    -------------------------------------------------------------------------------
    -- FIRST Bit Register Access Interface.
    -------------------------------------------------------------------------------
        FIRST_WRITE     : in  std_logic;
        FIRST_WDATA     : in  std_logic;
        FIRST_RDATA     : out std_logic;
    -------------------------------------------------------------------------------
    -- LAST Bit Register Access Interface.
    -------------------------------------------------------------------------------
        LAST_WRITE      : in  std_logic;
        LAST_WDATA      : in  std_logic;
        LAST_RDATA      : out std_logic;
    -------------------------------------------------------------------------------
    -- DONE Status Bit Register Access Interface.
    -------------------------------------------------------------------------------
        DONE_WRITE      : in  std_logic;
        DONE_WDATA      : in  std_logic;
        DONE_RDATA      : out std_logic;
    -------------------------------------------------------------------------------
    -- ERROR Status Bit Register Access Interface.
    -------------------------------------------------------------------------------
        ERROR_WRITE     : in  std_logic;
        ERROR_WDATA     : in  std_logic;
        ERROR_RDATA     : out std_logic;
    -------------------------------------------------------------------------------
    -- MODE Register Access Interface.
    -------------------------------------------------------------------------------
        MODE_WRITE      : in  std_logic_vector(MODE_BITS-1 downto 0);
        MODE_WDATA      : in  std_logic_vector(MODE_BITS-1 downto 0);
        MODE_RDATA      : out std_logic_vector(MODE_BITS-1 downto 0);
    -------------------------------------------------------------------------------
    -- STAT Register Access Interface.
    -------------------------------------------------------------------------------
        STAT_WRITE      : in  std_logic_vector(STAT_BITS-1 downto 0);
        STAT_WDATA      : in  std_logic_vector(STAT_BITS-1 downto 0);
        STAT_RDATA      : out std_logic_vector(STAT_BITS-1 downto 0);
    -------------------------------------------------------------------------------
    -- Transaction Command Request Signals.
    -------------------------------------------------------------------------------
        REQ_VALID       : out std_logic;
        REQ_FIRST       : out std_logic;
        REQ_LAST        : out std_logic;
        REQ_READY       : in  std_logic;
    -------------------------------------------------------------------------------
    -- Transaction Command Response Signals.
    -------------------------------------------------------------------------------
        RES_VALID       : in  std_logic;
        RES_ERROR       : in  std_logic;
        RES_DONE        : in  std_logic;
        RES_LAST        : in  std_logic;
        RES_STOP        : in  std_logic;
        RES_NONE        : in  std_logic;
    -------------------------------------------------------------------------------
    -- Flow Control Signals.
    -------------------------------------------------------------------------------
        BUFFER_SIZE     : in  std_logic_vector(SIZE_BITS-1 downto 0);
        THRESHOLD_SIZE  : in  std_logic_vector(SIZE_BITS-1 downto 0);
    -------------------------------------------------------------------------------
    -- Flow Control Signals.
    -------------------------------------------------------------------------------
        FLOW_PAUSE      : out std_logic;
        FLOW_STOP       : out std_logic;
        FLOW_LAST       : out std_logic;
        FLOW_SIZE       : out std_logic_vector(SIZE_BITS-1 downto 0);
    -------------------------------------------------------------------------------
    -- Push Size Signals.
    -------------------------------------------------------------------------------
        PUSH_VAL        : in  std_logic;
        PUSH_LAST       : in  std_logic;
        PUSH_SIZE       : in  std_logic_vector(SIZE_BITS-1 downto 0);
    -------------------------------------------------------------------------------
    -- Pull Size Signals.
    -------------------------------------------------------------------------------
        PULL_VAL        : in  std_logic;
        PULL_LAST       : in  std_logic;
        PULL_SIZE       : in  std_logic_vector(SIZE_BITS-1 downto 0);
    -------------------------------------------------------------------------------
    -- Flow Counter.
    -------------------------------------------------------------------------------
        FLOW_COUNT      : out std_logic_vector(SIZE_BITS-1 downto 0);
        FLOW_NEG        : out std_logic;
    -------------------------------------------------------------------------------
    -- Status
    -------------------------------------------------------------------------------
        STAT_IN         : in  std_logic_vector(STAT_BITS-1 downto 0);
        PAUSED          : out std_logic;
        DONE            : out std_logic;
        RUNNING         : out std_logic
    );
end PUMP_VALVE_CONTROL_REGISTER;
-----------------------------------------------------------------------------------
-- 
-----------------------------------------------------------------------------------
library ieee;
use     ieee.std_logic_1164.all;
use     ieee.numeric_std.all;
architecture RTL of PUMP_VALVE_CONTROL_REGISTER is
    -------------------------------------------------------------------------------
    -- Register Bits.
    -------------------------------------------------------------------------------
    signal   reset_bit          : std_logic;
    signal   start_bit          : std_logic;
    signal   stop_bit           : std_logic;
    signal   pause_bit          : std_logic;
    signal   first_bit          : std_logic;
    signal   last_bit           : std_logic;
    signal   done_bit           : std_logic;
    signal   error_bit          : std_logic;
    signal   mode_regs          : std_logic_vector(MODE_BITS-1 downto 0);
    signal   stat_regs          : std_logic_vector(STAT_BITS-1 downto 0);
    -------------------------------------------------------------------------------
    -- Flow Counter.
    -------------------------------------------------------------------------------
    signal   flow_counter       : unsigned(SIZE_BITS-1 downto 0);
    signal   flow_negative      : boolean;
    signal   flow_positive      : boolean;
    signal   flow_zero          : boolean;
    -------------------------------------------------------------------------------
    -- State Machine.
    -------------------------------------------------------------------------------
    type     STATE_TYPE     is  ( IDLE_STATE, REQ_STATE, RES_STATE, TURN_AR, DONE_STATE);
    signal   curr_state         : STATE_TYPE;
    -------------------------------------------------------------------------------
    -- Other Flags.
    -------------------------------------------------------------------------------
    signal   push_last_flag     : boolean;
    signal   pull_last_flag     : boolean;
begin
    -------------------------------------------------------------------------------
    -- 
    -------------------------------------------------------------------------------
    process (CLK, RST)
        variable next_state : STATE_TYPE;
    begin
        if    (RST = '1') then
                curr_state <= IDLE_STATE;
                reset_bit  <= '0';
                start_bit  <= '0';
                stop_bit   <= '0';
                pause_bit  <= '0';
                first_bit  <= '0';
                last_bit   <= '0';
                done_bit   <= '0';
                error_bit  <= '0';
                mode_regs  <= (others => '0');
                stat_regs  <= (others => '0');
        elsif (CLK'event and CLK = '1') then
            if (CLR   = '1') then
                curr_state <= IDLE_STATE;
                reset_bit  <= '0';
                start_bit  <= '0';
                stop_bit   <= '0';
                pause_bit  <= '0';
                first_bit  <= '0';
                last_bit   <= '0';
                done_bit   <= '0';
                error_bit  <= '0';
                mode_regs  <= (others => '0');
                stat_regs  <= (others => '0');
            else
                -------------------------------------------------------------------
                -- ステートマシン
                -------------------------------------------------------------------
                case curr_state is
                    when IDLE_STATE =>
                        if (start_bit = '1') then
                            next_state := REQ_STATE;
                        else
                            next_state := IDLE_STATE;
                        end if;
                    when REQ_STATE  =>
                        if    (REQ_READY = '0') then
                                next_state := REQ_STATE;
                        elsif (RES_VALID = '1') then
                            if (RES_DONE = '1' or RES_ERROR = '1' or RES_STOP = '1' or RES_NONE = '1') then
                                next_state := DONE_STATE;
                            else
                                next_state := TURN_AR;
                            end if;
                        else
                                next_state := RES_STATE;
                        end if;
                    when RES_STATE  =>
                        if (RES_VALID = '1') then
                            if (RES_DONE = '1' or RES_ERROR = '1' or RES_STOP = '1' or RES_NONE = '1') then
                                next_state := DONE_STATE;
                            else
                                next_state := TURN_AR;
                            end if;
                        else
                                next_state := RES_STATE;
                        end if;
                    when TURN_AR    =>
                                next_state := REQ_STATE;
                    when DONE_STATE =>
                                next_state := IDLE_STATE;
                    when others =>
                                next_state := IDLE_STATE;
                end case;
                if (reset_bit = '1') then
                    curr_state <= IDLE_STATE;
                else
                    curr_state <= next_state;
                end if;
                -------------------------------------------------------------------
                -- RESET BIT
                -------------------------------------------------------------------
                if    (RESET_WRITE = '1') then
                    reset_bit <= RESET_WDATA;
                end if;
                -------------------------------------------------------------------
                -- START BIT
                -------------------------------------------------------------------
                if    (reset_bit = '1') then
                    start_bit <= '0';
                elsif (START_WRITE = '1' and START_WDATA = '1') then
                    start_bit <= '1';
                elsif (next_state = DONE_STATE) then
                    start_bit <= '0';
                end if;
                -------------------------------------------------------------------
                -- STOP BIT
                -------------------------------------------------------------------
                if    (STOP_WRITE  = '1' and STOP_WDATA  = '1') then
                    stop_bit  <= '1';
                elsif (next_state = DONE_STATE) then
                    stop_bit  <= '0';
                end if;
                -------------------------------------------------------------------
                -- PAUSE BIT
                -------------------------------------------------------------------
                if    (PAUSE_WRITE = '1') then
                    pause_bit <= PAUSE_WDATA;
                end if;
                -------------------------------------------------------------------
                -- FIRST BIT
                -------------------------------------------------------------------
                if    (FIRST_WRITE = '1') then
                    first_bit <= FIRST_WDATA;
                end if;
                -------------------------------------------------------------------
                -- LAST BIT
                -------------------------------------------------------------------
                if    (LAST_WRITE  = '1') then
                    last_bit  <= LAST_WDATA;
                end if;
                -------------------------------------------------------------------
                -- DONE BIT
                -------------------------------------------------------------------
                if    (reset_bit = '1') then
                    done_bit  <= '0';
                elsif (next_state = DONE_STATE) then
                    done_bit  <= '1';
                elsif (DONE_WRITE  = '1' and DONE_WDATA  = '0') then
                    done_bit  <= '0';
                end if;
                -------------------------------------------------------------------
                -- ERROR BIT
                -------------------------------------------------------------------
                if    (reset_bit = '1') then
                    error_bit <= '0';
                elsif (next_state = DONE_STATE and RES_ERROR = '1') then
                    error_bit <= '1';
                elsif (ERROR_WRITE = '1' and ERROR_WDATA = '0') then
                    error_bit  <= '0';
                end if;
                -------------------------------------------------------------------
                -- MODE REGISTER
                -------------------------------------------------------------------
                if (reset_bit = '1') then
                    mode_regs <= (others => '0');
                else
                    for i in mode_regs'range loop
                        if (MODE_WRITE(i) = '1') then
                            mode_regs(i) <= MODE_WDATA(i);
                        end if;
                    end loop;
                end if;
                -------------------------------------------------------------------
                -- STATUS REGISTER
                -------------------------------------------------------------------
                if (reset_bit = '1') then
                    stat_regs <= (others => '0');
                else
                    for i in stat_regs'range loop
                        if    (STAT_WRITE(i) = '1' and STAT_WDATA(i) = '0') then
                            stat_regs(i) <= '0';
                        elsif (STAT_IN(i) = '1') then
                            stat_regs(i) <= '1';
                        end if;
                    end loop;
                end if;
            end if;
        end if;
    end process;
    -------------------------------------------------------------------------------
    -- Register Output Signals.
    -------------------------------------------------------------------------------
    RESET_RDATA <= reset_bit;
    START_RDATA <= start_bit;
    STOP_RDATA  <= stop_bit;
    PAUSE_RDATA <= pause_bit;
    FIRST_RDATA <= first_bit;
    LAST_RDATA  <= last_bit;
    DONE_RDATA  <= done_bit;
    ERROR_RDATA <= error_bit;
    MODE_RDATA  <= mode_regs;
    STAT_RDATA  <= stat_regs;
    -------------------------------------------------------------------------------
    -- Status
    -------------------------------------------------------------------------------
    RUNNING     <= start_bit;
    DONE        <= '1' when (curr_state = DONE_STATE) else '0';
    -------------------------------------------------------------------------------
    -- Transaction Command Request Signals.
    -------------------------------------------------------------------------------
    REQ_VALID   <= '1' when (curr_state = REQ_STATE ) else '0';
    REQ_FIRST   <= first_bit;
    REQ_LAST    <= last_bit;
    -------------------------------------------------------------------------------
    -- Flow Counter.
    -------------------------------------------------------------------------------
    process (CLK, RST)
        variable next_counter : unsigned(SIZE_BITS downto 0);
    begin
        if    (RST = '1') then
                flow_counter  <= (others => '0');
                flow_positive <= FALSE;
                flow_negative <= FALSE;
                flow_zero     <= TRUE;
        elsif (CLK'event and CLK = '1') then
            if (CLR   = '1' or reset_bit = '1') then
                flow_counter  <= (others => '0');
                flow_positive <= FALSE;
                flow_negative <= FALSE;
                flow_zero     <= TRUE;
            else
                next_counter := "0" & flow_counter;
                if (PUSH_VAL = '1') then
                    next_counter := next_counter + unsigned(PUSH_SIZE);
                end if;
                if (PULL_VAL = '1') then
                    next_counter := next_counter - unsigned(PULL_SIZE);
                end if;
                if    (next_counter(next_counter'high) = '1') then
                    flow_positive <= FALSE;
                    flow_negative <= TRUE;
                    flow_zero     <= FALSE;
                    next_counter  := (others => '0');
                elsif (next_counter > 0) then
                    flow_positive <= TRUE;
                    flow_negative <= FALSE;
                    flow_zero     <= FALSE;
                else
                    flow_positive <= FALSE;
                    flow_negative <= FALSE;
                    flow_zero     <= TRUE;
                end if;
                flow_counter <= next_counter(flow_counter'range);
            end if;
        end if;
    end process;
    FLOW_COUNT <= std_logic_vector(flow_counter);
    FLOW_NEG   <= '1' when (flow_negative) else '0';
    -------------------------------------------------------------------------------
    -- 
    -------------------------------------------------------------------------------
    process (CLK, RST) begin
        if    (RST = '1') then
                pull_last_flag <= FALSE;
        elsif (CLK'event and CLK = '1') then
            if (CLR   = '1' or reset_bit = '1' or curr_state = DONE_STATE) then
                pull_last_flag <= FALSE;
            elsif (PULL_VAL = '1' and PULL_LAST = '1') then
                pull_last_flag <= TRUE;
            end if;
        end if;
    end process;
    -------------------------------------------------------------------------------
    -- 
    -------------------------------------------------------------------------------
    process (CLK, RST) begin
        if    (RST = '1') then
                push_last_flag <= FALSE;
        elsif (CLK'event and CLK = '1') then
            if (CLR   = '1' or reset_bit = '1' or curr_state = DONE_STATE) then
                push_last_flag <= FALSE;
            elsif (PUSH_VAL = '1' and PUSH_LAST = '1') then
                push_last_flag <= TRUE;
            end if;
        end if;
    end process;
    -------------------------------------------------------------------------------
    -- Flow Control (Flow Sink Mode)
    -------------------------------------------------------------------------------
    FLOW_SINK_MODE : if (FLOW_SINK /= 0) generate
        FLOW_STOP  <= '1' when (stop_bit  = '1') or
                               (pull_last_flag) else '0';
        FLOW_PAUSE <= '1' when (pause_bit = '1') or
                               (to_01(flow_counter) > to_01(unsigned(THRESHOLD_SIZE))) else '0';
        PAUSED     <= '1' when (pause_bit = '1') or
                               (to_01(flow_counter) > to_01(unsigned(THRESHOLD_SIZE))) else '0';
        FLOW_LAST  <= '0';
        FLOW_SIZE  <= std_logic_vector(to_01(unsigned(BUFFER_SIZE)) - to_01(unsigned(THRESHOLD_SIZE)));
    end generate;
    -------------------------------------------------------------------------------
    -- Flow Control (Flow Source Mode)
    -------------------------------------------------------------------------------
    FLOW_SOURCE_MODE : if (FLOW_SINK  = 0) generate
        FLOW_STOP  <= '1' when (stop_bit  = '1') or
                               (push_last_flag and flow_negative) else '0';
        FLOW_PAUSE <= '1' when (pause_bit = '1') or
                               (push_last_flag = TRUE  and flow_zero) or
                               (push_last_flag = FALSE and to_01(flow_counter) <  to_01(unsigned(THRESHOLD_SIZE))) else '0';
        PAUSED     <= '1' when (pause_bit = '1') or
                               (push_last_flag = TRUE  and flow_zero) or
                               (push_last_flag = FALSE and to_01(flow_counter) <  to_01(unsigned(THRESHOLD_SIZE))) else '0';
        FLOW_LAST  <= '1' when (push_last_flag = TRUE  and to_01(flow_counter) <= to_01(unsigned(THRESHOLD_SIZE))) else '0';
        FLOW_SIZE  <= std_logic_vector(flow_counter);
    end generate;
end RTL;
