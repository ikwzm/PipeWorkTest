-----------------------------------------------------------------------------------
--!     @file    image_window_player.vhd
--!     @brief   Image Window Dummy Plug Player.
--!     @version 1.8.0
--!     @date    2018/11/27
--!     @author  Ichiro Kawazome <ichiro_k@ca2.so-net.ne.jp>
-----------------------------------------------------------------------------------
--
--      Copyright (C) 2018 Ichiro Kawazome
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
use     PIPEWORK.IMAGE_TYPES.all;
library DUMMY_PLUG;
use     DUMMY_PLUG.CORE.REPORT_STATUS_TYPE;
use     DUMMY_PLUG.SYNC.SYNC_REQ_VECTOR;
use     DUMMY_PLUG.SYNC.SYNC_ACK_VECTOR;
-----------------------------------------------------------------------------------
--! @brief   IMAGE_WINDOW_PLAYER :
-----------------------------------------------------------------------------------
entity  IMAGE_WINDOW_PLAYER is
    -------------------------------------------------------------------------------
    -- ジェネリック変数.
    -------------------------------------------------------------------------------
    generic (
        SCENARIO_FILE   : --! @brief シナリオファイルの名前.
                          STRING;
        NAME            : --! @brief 固有名詞.
                          STRING;
        FULL_NAME       : --! @brief メッセージ出力用の固有名詞.
                          STRING;
        MASTER          : --! @brief マスターモードを指定する.
                          boolean   := FALSE;
        SLAVE           : --! @brief スレーブモードを指定する.
                          boolean   := FALSE;
        PARAM           : --! @brief Image Window Parameter
                          IMAGE_WINDOW_PARAM_TYPE;
        OUTPUT_DELAY    : --! @brief 出力信号遅延時間
                          time;
        SYNC_WIDTH      : --! @brief シンクロ用信号の本数.
                          integer :=  1;
        GPI_WIDTH       : --! @brief GPI(General Purpose Input)信号のビット幅.
                          integer := 8;
        GPO_WIDTH       : --! @brief GPO(General Purpose Output)信号のビット幅.
                          integer := 8;
        FINISH_ABORT    : --! @brief FINISH コマンド実行時にシミュレーションを
                          --!        アボートするかどうかを指定するフラグ.
                          boolean := true
    );
    -------------------------------------------------------------------------------
    -- 入出力ポートの定義.
    -------------------------------------------------------------------------------
    port(
        ---------------------------------------------------------------------------
        -- グローバルシグナル.
        ---------------------------------------------------------------------------
        CLK             : in    std_logic;
        RST             : in    std_logic;
        ---------------------------------------------------------------------------
        -- Image Window Signals
        ---------------------------------------------------------------------------
        DATA_I          : in    std_logic_vector(PARAM.DATA.SIZE-1 downto 0);
        DATA_O          : out   std_logic_vector(PARAM.DATA.SIZE-1 downto 0);
        VALID_I         : in    std_logic;
        VALID_O         : out   std_logic;
        READY_I         : in    std_logic;
        READY_O         : out   std_logic;
        ---------------------------------------------------------------------------
        -- シンクロ用信号.
        ---------------------------------------------------------------------------
        SYNC_REQ        : out   SYNC_REQ_VECTOR (SYNC_WIDTH   -1 downto 0);
        SYNC_ACK        : in    SYNC_ACK_VECTOR (SYNC_WIDTH   -1 downto 0);
        --------------------------------------------------------------------------
        -- General Purpose Input 信号
        --------------------------------------------------------------------------
        GPI             : in    std_logic_vector(GPI_WIDTH-1 downto 0) := (others => '0');
        --------------------------------------------------------------------------
        -- General Purpose Output 信号
        --------------------------------------------------------------------------
        GPO             : out   std_logic_vector(GPO_WIDTH-1 downto 0);
        --------------------------------------------------------------------------
        -- レポートステータス出力.
        --------------------------------------------------------------------------
        REPORT_STATUS   : out   REPORT_STATUS_TYPE;
        --------------------------------------------------------------------------
        -- シミュレーション終了通知信号.
        --------------------------------------------------------------------------
        FINISH          : out   std_logic
    );
end IMAGE_WINDOW_PLAYER;
-----------------------------------------------------------------------------------
--
-----------------------------------------------------------------------------------
library ieee;
use     ieee.std_logic_1164.all;
use     ieee.numeric_std.all;
use     std.textio.all;
library PIPEWORK;
use     PIPEWORK.IMAGE_TYPES.all;
library DUMMY_PLUG;
use     DUMMY_PLUG.CORE.all;
use     DUMMY_PLUG.SYNC.all;
use     DUMMY_PLUG.UTIL.all;
use     DUMMY_PLUG.READER.all;
-----------------------------------------------------------------------------------
--! @brief   IMAGE_WINDOW_PLAYER :
-----------------------------------------------------------------------------------
architecture MODEL of IMAGE_WINDOW_PLAYER is
    -------------------------------------------------------------------------------
    --! @brief Image Window の ELEMENT 信号の定義
    -------------------------------------------------------------------------------
    subtype   IMAGE_ELEM_SIGNAL_TYPE    is std_logic_vector(PARAM.ELEM_BITS-1 downto 0);
    type      IMAGE_ELEM_SIGNAL_WINDOW  is array (integer range <>,
                                                  integer range <>,
                                                  integer range <>) of IMAGE_ELEM_SIGNAL_TYPE;
    -------------------------------------------------------------------------------
    --! @brief Image Window の ATTRIBUTE 信号の定義
    -------------------------------------------------------------------------------
    subtype   IMAGE_ATRB_SIGNAL_TYPE    is std_logic_vector(PARAM.ATRB_BITS-1 downto 0);
    type      IMAGE_ATRB_SIGNAL_VECTOR  is array (integer range <>) of IMAGE_ATRB_SIGNAL_TYPE;
    type      IMAGE_ATRB_SIGNAL_WINDOW  is record
                  Y         :  IMAGE_ATRB_SIGNAL_VECTOR(PARAM.SHAPE.Y.LO to PARAM.SHAPE.Y.HI);
                  X         :  IMAGE_ATRB_SIGNAL_VECTOR(PARAM.SHAPE.X.LO to PARAM.SHAPE.X.HI);
                  C         :  IMAGE_ATRB_SIGNAL_VECTOR(PARAM.SHAPE.C.LO to PARAM.SHAPE.C.HI);
    end record;
    -------------------------------------------------------------------------------
    --! @brief Image Window 信号のレコード宣言.
    -------------------------------------------------------------------------------
    type      IMAGE_WINDOW_SIGNAL_TYPE is record
                  ELEM      :  IMAGE_ELEM_SIGNAL_WINDOW(PARAM.SHAPE.Y.LO to PARAM.SHAPE.Y.HI,
                                                        PARAM.SHAPE.X.LO to PARAM.SHAPE.X.HI,
                                                        PARAM.SHAPE.C.LO to PARAM.SHAPE.C.HI);
                  ATRB      :  IMAGE_ATRB_SIGNAL_WINDOW;
                  DATA      :  std_logic_vector(PARAM.DATA.SIZE-1 downto 0);
                  VALID     :  std_logic;
                  READY     :  std_logic;
    end record;
    -------------------------------------------------------------------------------
    --! @brief Image Window 信号を値で埋めるプロシージャ
    -------------------------------------------------------------------------------
    procedure FILL_DATA_TO_IMAGE_WINDOW_SIGNAL(
                  W         : inout IMAGE_WINDOW_SIGNAL_TYPE;
                  D         : in    std_logic)
    is
    begin
        for y_pos in PARAM.SHAPE.Y.LO to PARAM.SHAPE.Y.HI loop
        for x_pos in PARAM.SHAPE.X.LO to PARAM.SHAPE.X.HI loop
        for c_pos in PARAM.SHAPE.C.LO to PARAM.SHAPE.C.HI loop
            for i in IMAGE_ELEM_SIGNAL_TYPE'range loop
                W.ELEM(y_pos, x_pos, c_pos)(i) := D;
            end loop;
            SET_ELEMENT_TO_IMAGE_WINDOW_DATA(
                PARAM   => PARAM,
                C       => c_pos,
                X       => x_pos,
                Y       => y_pos,
                ELEMENT => W.ELEM(y_pos, x_pos, c_pos),
                DATA    => W.DATA
            );
        end loop;
        end loop;
        end loop;
        for y_pos in PARAM.SHAPE.Y.LO to PARAM.SHAPE.Y.HI loop
            for i in IMAGE_ATRB_SIGNAL_TYPE'range loop
                W.ATRB.Y(y_pos)(i) := D;
            end loop;
            SET_ATRB_Y_TO_IMAGE_WINDOW_DATA(
                PARAM   => PARAM,
                Y       => y_pos,
                ATRB    => W.ATRB.Y(y_pos),
                DATA    => W.DATA
            );
        end loop;
        for x_pos in PARAM.SHAPE.X.LO to PARAM.SHAPE.X.HI loop
            for i in IMAGE_ATRB_SIGNAL_TYPE'range loop
                W.ATRB.X(x_pos)(i) := D;
            end loop;
            SET_ATRB_X_TO_IMAGE_WINDOW_DATA(
                PARAM   => PARAM,
                X       => x_pos,
                ATRB    => W.ATRB.X(x_pos),
                DATA    => W.DATA
            );
        end loop;
        for c_pos in PARAM.SHAPE.C.LO to PARAM.SHAPE.C.HI loop
            for i in IMAGE_ATRB_SIGNAL_TYPE'range loop
                W.ATRB.C(c_pos)(i) := D;
            end loop;
            SET_ATRB_C_TO_IMAGE_WINDOW_DATA(
                PARAM   => PARAM,
                C       => c_pos,
                ATRB    => W.ATRB.C(c_pos),
                DATA    => W.DATA
            );
        end loop;
    end procedure;
    -------------------------------------------------------------------------------
    --! @brief Image Window 信号を値で埋める関数
    -------------------------------------------------------------------------------
    function  INIT_IMAGE_WINDOW_SIGNAL(D: std_logic) return IMAGE_WINDOW_SIGNAL_TYPE
    is
        variable win_signal : IMAGE_WINDOW_SIGNAL_TYPE;
    begin
        FILL_DATA_TO_IMAGE_WINDOW_SIGNAL(win_signal, D);
        return win_signal;
    end function;
    -------------------------------------------------------------------------------
    --! @brief Image Window 信号の初期値
    -------------------------------------------------------------------------------
    constant  IMAGE_WINDOW_SIGNAL_NULL      : IMAGE_WINDOW_SIGNAL_TYPE := INIT_IMAGE_WINDOW_SIGNAL('0');
    constant  IMAGE_WINDOW_SIGNAL_DONTCARE  : IMAGE_WINDOW_SIGNAL_TYPE := INIT_IMAGE_WINDOW_SIGNAL('-');
    -------------------------------------------------------------------------------
    --! @brief 入力信号のどれかに変化があるまで待つサブプログラム.
    -------------------------------------------------------------------------------
    procedure wait_on_signals is
    begin
        wait on 
            CLK        , -- In  :
            RST        , -- In  :
            DATA_I     , -- In  :
            VALID_I    , -- In  :
            READY_I    , -- In  :
            GPI        ; -- In  :
    end procedure;
    -------------------------------------------------------------------------------
    --! @brief Image Window の期待値と信号の値を比較するサブプログラム.
    --! - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    --! @param    signals     信号の期待値.
    --! @param    match       比較した結果。マッチすれば TRUE、しなければ FALSE.
    -------------------------------------------------------------------------------
    procedure match_image_window_signals(
                  signals   : in    IMAGE_WINDOW_SIGNAL_TYPE;
                  match     : out   boolean
    ) is
    begin
        match := MATCH_STD_LOGIC(signals.VALID, VALID_I) and 
                 MATCH_STD_LOGIC(signals.READY, READY_I) and 
                 MATCH_STD_LOGIC(signals.DATA , DATA_I );
    end procedure;
    -------------------------------------------------------------------------------
    --! @brief Image Window の期待値と信号の値を比較するサブプログラム.
    --! - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    --! @param    core        コア変数.
    --! @param    signals     信号の期待値.
    --! @param    match       比較した結果。マッチすれば TRUE、しなければ FALSE.
    -------------------------------------------------------------------------------
    procedure match_image_window_signals(
        variable  core      : inout CORE_TYPE;
                  signals   : in    IMAGE_WINDOW_SIGNAL_TYPE;
                  match     : out   boolean
    ) is
        variable  elem_i    :       std_logic_vector(PARAM.ELEM_BITS-1 downto 0);
        variable  atrb_i    :       std_logic_vector(PARAM.ATRB_BITS-1 downto 0);
        variable  match_s   :       boolean;
    begin
        match_image_window_signals(signals, match_s);
        match := match_s;
        if (match_s = TRUE) then
            return;
        end if;
        if (MATCH_STD_LOGIC(signals.VALID , VALID_I) = FALSE) then
            REPORT_MISMATCH(core, "VALID " & 
                            BIN_TO_STRING(  VALID_I ) & " /= " &
                            BIN_TO_STRING(  signals.VALID) );
        end if;
        if (MATCH_STD_LOGIC(signals.READY , READY_I) = FALSE) then
            REPORT_MISMATCH(core, "READY " &
                            BIN_TO_STRING(  READY_I ) & " /= " &
                            BIN_TO_STRING(  signals.READY) );
        end if;
        for y_pos in PARAM.SHAPE.Y.LO to PARAM.SHAPE.Y.HI loop
        for x_pos in PARAM.SHAPE.X.LO to PARAM.SHAPE.X.HI loop
        for c_pos in PARAM.SHAPE.C.LO to PARAM.SHAPE.C.HI loop
            elem_i := GET_ELEMENT_FROM_IMAGE_WINDOW_DATA(
                          PARAM  => PARAM,
                          C      => c_pos,
                          X      => x_pos,
                          Y      => y_pos,
                          DATA   => DATA_I
                      );
            if (MATCH_STD_LOGIC(signals.ELEM(y_pos, x_pos, c_pos) , elem_i) = FALSE) then
                REPORT_MISMATCH(core, "ELEM[" &
                                INTEGER_TO_STRING(y_pos) & "][" &
                                INTEGER_TO_STRING(x_pos) & "][ " & 
                                INTEGER_TO_STRING(c_pos) & "] " & 
                                HEX_TO_STRING(elem_i)    & " /= " &
                                HEX_TO_STRING(signals.ELEM(y_pos, x_pos, c_pos)));
            end if;
        end loop;
        end loop;
        end loop;
        for y_pos in PARAM.SHAPE.Y.LO to PARAM.SHAPE.Y.HI loop
            atrb_i := GET_ATRB_Y_FROM_IMAGE_WINDOW_DATA(
                              PARAM  => PARAM,
                              Y      => y_pos,
                              DATA   => DATA_I
                          );
            if (MATCH_STD_LOGIC(signals.ATRB.Y(y_pos), atrb_i) = FALSE) then
                REPORT_MISMATCH(core, "ATRB.Y[" &
                                INTEGER_TO_STRING(y_pos) & "] " &
                                HEX_TO_STRING(atrb_i)    & " /= " &
                                HEX_TO_STRING(signals.ATRB.Y(y_pos)));
            end if;
        end loop;
        for x_pos in PARAM.SHAPE.X.LO to PARAM.SHAPE.X.HI loop
            atrb_i := GET_ATRB_X_FROM_IMAGE_WINDOW_DATA(
                              PARAM  => PARAM,
                              X      => x_pos,
                              DATA   => DATA_I
                          );
            if (MATCH_STD_LOGIC(signals.ATRB.X(x_pos), atrb_i) = FALSE) then
                REPORT_MISMATCH(core, "ATRB.X[" &
                                INTEGER_TO_STRING(x_pos) & "] " &
                                HEX_TO_STRING(atrb_i)    & " /= " &
                                HEX_TO_STRING(signals.ATRB.X(x_pos)));
            end if;
        end loop;
        for c_pos in PARAM.SHAPE.C.LO to PARAM.SHAPE.C.HI loop
            atrb_i := GET_ATRB_C_FROM_IMAGE_WINDOW_DATA(
                              PARAM  => PARAM,
                              C      => c_pos,
                              DATA   => DATA_I
                          );
            if (MATCH_STD_LOGIC(signals.ATRB.C(c_pos) , atrb_i) = FALSE) then
                REPORT_MISMATCH(core, "ATRB.C[" &
                                INTEGER_TO_STRING(c_pos) & "] " &
                                HEX_TO_STRING(atrb_i)    & " /= " &
                                HEX_TO_STRING(signals.ATRB.C(c_pos)));
            end if;
        end loop;
    end procedure;
    -------------------------------------------------------------------------------
    -- キーワードの定義.
    -------------------------------------------------------------------------------
    subtype   KEYWORD_TYPE is STRING(1 to 6);
    constant  KEY_NULL      : KEYWORD_TYPE := "      ";
    constant  KEY_SAY       : KEYWORD_TYPE := "SAY   ";
    constant  KEY_SYNC      : KEYWORD_TYPE := "SYNC  ";
    constant  KEY_WAIT      : KEYWORD_TYPE := "WAIT  ";
    constant  KEY_CHECK     : KEYWORD_TYPE := "CHECK ";
    constant  KEY_OUT       : KEYWORD_TYPE := "OUT   ";
    constant  KEY_DEBUG     : KEYWORD_TYPE := "DEBUG ";
    constant  KEY_REPORT    : KEYWORD_TYPE := "REPORT";
    constant  KEY_XFER      : KEYWORD_TYPE := "XFER  ";
    constant  KEY_DATA      : KEYWORD_TYPE := "DATA  ";
    constant  KEY_ELEM      : KEYWORD_TYPE := "ELEM  ";
    constant  KEY_ATRB      : KEYWORD_TYPE := "ATRB  ";
    constant  KEY_C         : KEYWORD_TYPE := "C     ";
    constant  KEY_X         : KEYWORD_TYPE := "X     ";
    constant  KEY_Y         : KEYWORD_TYPE := "Y     ";
    constant  KEY_VALID     : KEYWORD_TYPE := "VALID ";
    constant  KEY_READY     : KEYWORD_TYPE := "READY ";
begin 
    -------------------------------------------------------------------------------
    -- メインプロセス
    -------------------------------------------------------------------------------
    process
        ---------------------------------------------------------------------------
        -- 各種変数の定義.
        ---------------------------------------------------------------------------
        file      stream        : TEXT;
        variable  core          : CORE_TYPE;
        variable  keyword       : KEYWORD_TYPE;
        variable  operation     : OPERATION_TYPE;
        variable  out_signals   : IMAGE_WINDOW_SIGNAL_TYPE;
        variable  chk_signals   : IMAGE_WINDOW_SIGNAL_TYPE;
        variable  gpo_signals   : std_logic_vector(GPO'range);
        variable  gpi_signals   : std_logic_vector(GPI'range);
        ---------------------------------------------------------------------------
        --! @brief  SYNCオペレーション. 
        --! - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
        --! @param    OPERATION   オペレーション.
        ---------------------------------------------------------------------------
        procedure execute_sync(
                      operation : in    OPERATION_TYPE
        ) is
            constant  proc_name : string := "EXECUTE_SYNC";
            variable  port_num  : integer;
            variable  wait_num  : integer;
        begin
            REPORT_DEBUG  (core, proc_name, "BEGIN");
            READ_SYNC_ARGS(core, stream, operation, port_num, wait_num);
            REPORT_DEBUG  (core, proc_name, "PORT=" & INTEGER_TO_STRING(port_num) &
                                           " WAIT=" & INTEGER_TO_STRING(wait_num));
            if (SYNC_REQ'low <= port_num and port_num <= SYNC_REQ'high) then
                CORE_SYNC(core, port_num, wait_num, SYNC_REQ, SYNC_ACK);
            end if;
            REPORT_DEBUG  (core, proc_name, "END");
        end procedure;
    begin 
        ---------------------------------------------------------------------------
        -- ダミープラグコアの初期化.
        ---------------------------------------------------------------------------
        CORE_INIT(
            SELF        => core,          -- 初期化するコア変数.
            NAME        => NAME,          -- コアの名前.
            VOCAL_NAME  => FULL_NAME,     -- メッセージ出力用の名前.
            STREAM      => stream,        -- シナリオのストリーム.
            STREAM_NAME => SCENARIO_FILE, -- シナリオのストリーム名.
            OPERATION   => operation      -- コアのオペレーション.
        );
        ---------------------------------------------------------------------------
        -- 変数の初期化.
        ---------------------------------------------------------------------------
        out_signals := IMAGE_WINDOW_SIGNAL_NULL;
        chk_signals := IMAGE_WINDOW_SIGNAL_DONTCARE;
        gpo_signals := (others => 'Z');
        gpi_signals := (others => '-');
        core.debug  := 0;
        ---------------------------------------------------------------------------
        -- 信号の初期化
        ---------------------------------------------------------------------------
        SYNC_REQ      <= (0 =>0, others => -1);
        FINISH        <= '0';
        REPORT_STATUS <= core.report_status;
        if (MASTER) then
            DATA_O  <= (others => '0');
            VALID_O <= '0';
        end if;
        if (SLAVE) then
            READY_O <= '0';
        end if;
        ---------------------------------------------------------------------------
        -- リセット解除待ち
        ---------------------------------------------------------------------------
        wait until(CLK'event and CLK = '1' and RST = '0');
        ---------------------------------------------------------------------------
        -- メインオペレーションループ
        ---------------------------------------------------------------------------
        while (operation /= OP_FINISH) loop
            REPORT_STATUS <= core.report_status;
            READ_OPERATION(core, stream, operation, keyword);
            case operation is
                when OP_DOC_BEGIN => execute_sync(operation);
                when OP_FINISH    => exit;
                when others       => null;
            end case;
        end loop;
        REPORT_STATUS <= core.report_status;
        FINISH        <= '1';
        if (FINISH_ABORT) then
            assert FALSE report "Simulation complete." severity FAILURE;
        end if;
        wait;
    end process;        
end MODEL;
