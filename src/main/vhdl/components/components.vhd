-----------------------------------------------------------------------------------
--                                                                               --
--       Title        : PIPEWORK COMPONENT LIBRARY DESCRIPTION                   --
--       Version      : 1.0.0                                                    --
--       Created      : Tue Jul 31 20:59:41 2012                                 --
--       File Name    : components.vhd                                           --
--       Package Name : COMPONENTS                                               --
--       Author       : Ichiro Kawazome <ichiro_k@ca2.so-net.ne.jp>              --
--       Program      : MakeComponentPackage 0.0.1                               --
--                                                                               --
--                                                                               --
--       Copyright (C) 2012 Ichiro Kawazome <ichiro_k@ca2.so-net.ne.jp>          --
--       All rights reserved.                                                    --
--                                                                               --
--       Redistribution and use in source and binary forms, with or without      --
--       modification, are permitted provided that the following conditions      --
--       are met:                                                                --
--                                                                               --
--         1. Redistributions of source code must retain the above copyright     --
--            notice, this list of conditions and the following disclaimer.      --
--                                                                               --
--         2. Redistributions in binary form must reproduce the above copyright  --
--            notice, this list of conditions and the following disclaimer in    --
--            the documentation and/or other materials provided with the         --
--            distribution.                                                      --
--                                                                               --
--       THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS     --
--       "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT       --
--       LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR   --
--       A PARTICULAR PURPOSE ARE DISCLAIMED.  IN NO EVENT SHALL THE COPYRIGHT   --
--       OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,   --
--       SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT        --
--       LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,   --
--       DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY   --
--       THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT     --
--       (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE   --
--       OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.    --
-----------------------------------------------------------------------------------
library ieee;
use     ieee.std_logic_1164.all;
package COMPONENTS is
-----------------------------------------------------------------------------------
-- REDUCER                                                                       --
-----------------------------------------------------------------------------------
component REDUCER
    generic (
        WORD_BITS   : --! @brief WORD BITS :
                      --! １ワードのデータのビット数を指定する.
                      integer := 8;
        ENBL_BITS   : --! @brief ENABLE BITS :
                      --! ワードデータのうち有効なデータであることを示す信号の
                      --! ビット数を指定する.
                      integer := 1;
        I_WIDTH     : --! @brief INPUT WORD WIDTH :
                      --! 入力側のデータのワード数を指定する.
                      integer := 4;
        O_WIDTH     : --! @brief OUTPUT WORD WIDTH :
                      --! 出力側のデータのワード数を指定する.
                      integer := 4;
        QUEUE_SIZE  : --! @brief QUEUE SIZE :
                      --! キューの大きさをワード数で指定する.
                      --! * 少なくともキューの大きさは、I_WIDTH+O_WIDTH-1以上で
                      --!   なければならない.
                      --! * ただしQUEUE_SIZE=0を指定した場合は、キューの深さは
                      --!   自動的にI_WIDTH+O_WIDTH に設定される.
                      integer := 0;
        VALID_MIN   : --! @brief BUFFER VALID MINIMUM NUMBER :
                      --! VALID信号の配列の最小値を指定する.
                      integer := 0;
        VALID_MAX   : --! @brief BUFFER VALID MAXIMUM NUMBER :
                      --! VALID信号の配列の最大値を指定する.
                      integer := 0;
        I_JUSTIFIED : --! @brief INPUT WORD JUSTIFIED :
                      --! 入力側の有効なデータが常にLOW側に詰められていることを
                      --! 示すフラグ.
                      --! * 常にLOW側に詰められている場合は、シフタが必要なくなる
                      --!   ため回路が簡単になる.
                      integer := 0;
        FLUSH_ENABLE: --! @brief FLUSH ENABLE :
                      --! FLUSH/I_FLUSHによるフラッシュ処理を有効にするかどうかを
                      --! 指定する.
                      --! * FLUSHとDONEとの違いは、DONEは最後のデータの出力時に
                      --!   キューの状態をすべてクリアするのに対して、
                      --!   FLUSHは最後のデータの出力時にENBLだけをクリアしてVALは
                      --!   クリアしない.
                      --!   そのため次の入力データは、最後のデータの次のワード位置
                      --!   から格納される.
                      --! * フラッシュ処理を行わない場合は、0を指定すると回路が若干
                      --!   簡単になる.
                      integer := 1
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
    -- 各種制御信号
    -------------------------------------------------------------------------------
        START       : --! @brief START :
                      --! 開始信号.
                      --! * この信号はOFFSETを内部に設定してキューを初期化する.
                      --! * 最初にデータ入力と同時にアサートしても構わない.
                      in  std_logic;
        OFFSET      : --! @brief OFFSET :
                      --! 最初のワードの出力位置を指定する.
                      --! * START信号がアサートされた時のみ有効.
                      --! * O_WIDTH>I_WIDTHの場合、最初のワードデータを出力する際の
                      --!   オフセットを設定できる.
                      --! * 例えばWORD_BITS=8、I_WIDTH=1(1バイト入力)、O_WIDTH=4(4バイト出力)の場合、
                      --!   OFFSET="0000"に設定すると、最初に入力したバイトデータは
                      --!   1バイト目から出力される.    
                      --!   OFFSET="0001"に設定すると、最初に入力したバイトデータは
                      --!   2バイト目から出力される.    
                      --!   OFFSET="0011"に設定すると、最初に入力したバイトデータは
                      --!   3バイト目から出力される.    
                      --!   OFFSET="0111"に設定すると、最初に入力したバイトデータは
                      --!   4バイト目から出力される.    
                      in  std_logic_vector(O_WIDTH-1 downto 0);
        DONE        : --! @brief DONE :
                      --! 終了信号.
                      --! * この信号をアサートすることで、キューに残っているデータ
                      --!   を掃き出す.
                      --!   その際、最後のワードと同時にO_DONE信号がアサートされる.
                      --! * FLUSH信号との違いは、FLUSH_ENABLEの項を参照.
                      in  std_logic;
        FLUSH       : --! @brief FLUSH :
                      --! フラッシュ信号.
                      --! * この信号をアサートすることで、キューに残っているデータ
                      --!   を掃き出す.
                      --!   その際、最後のワードと同時にO_FLUSH信号がアサートされる.
                      --! * DONE信号との違いは、FLUSH_ENABLEの項を参照.
                      in  std_logic;
        BUSY        : --! @brief BUSY :
                      --! ビジー信号.
                      --! * 最初にデータが入力されたときにアサートされる.
                      --! * 最後のデータが出力し終えたらネゲートされる.
                      out std_logic;
        VALID       : --! @brief QUEUE VALID FLAG :
                      --! キュー有効信号.
                      --! * 対応するインデックスのキューに有効なワードが入って
                      --!   いるかどうかを示すフラグ.
                      out std_logic_vector(VALID_MAX downto VALID_MIN);
    -------------------------------------------------------------------------------
    -- 入力側 I/F
    -------------------------------------------------------------------------------
        I_DATA      : --! @brief INPUT WORD DATA :
                      --! ワードデータ入力.
                      in  std_logic_vector(I_WIDTH*WORD_BITS-1 downto 0);
        I_ENBL      : --! @brief INPUT WORD ENABLE :
                      --! ワードイネーブル信号入力.
                      in  std_logic_vector(I_WIDTH*ENBL_BITS-1 downto 0);
        I_DONE      : --! @brief INPUT WORD DONE :
                      --! 最終ワード信号入力.
                      --! * 最後の力ワードデータ入であることを示すフラグ.
                      --! * 基本的にはDONE信号と同じ働きをするが、I_DONE信号は
                      --!   最後のワードデータを入力する際に同時にアサートする.
                      --! * I_FLUSH信号との違いはFLUSH_ENABLEの項を参照.
                      in  std_logic;
        I_FLUSH     : --! @brief INPUT WORD FLUSH :
                      --! 最終ワード信号入力.
                      --! * 最後のワードデータ入力であることを示すフラグ.
                      --! * 基本的にはFLUSH信号と同じ働きをするが、I_FLUSH信号は
                      --!   最後のワードデータを入力する際に同時にアサートする.
                      --! * I_DONE信号との違いはFLUSH_ENABLEの項を参照.
                      in  std_logic;
        I_VAL       : --! @brief INPUT WORD VALID :
                      --! 入力ワード有効信号.
                      --! * I_DATA/I_ENBL/I_DONE/I_FLUSHが有効であることを示す.
                      --! * I_VAL='1'and I_RDY='1'でワードデータがキューに取り込まれる.
                      in  std_logic;
        I_RDY       : --! @brief INPUT WORD READY :
                      --! 入力レディ信号.
                      --! * キューが次のワードデータを入力出来ることを示す.
                      --! * I_VAL='1'and I_RDY='1'でワードデータがキューに取り込まれる.
                      out std_logic;
    -------------------------------------------------------------------------------
    -- 出力側 I/F
    -------------------------------------------------------------------------------
        O_DATA      : --! @brief OUTPUT WORD DATA :
                      --! ワードデータ出力.
                      out std_logic_vector(O_WIDTH*WORD_BITS-1 downto 0);
        O_ENBL      : --! @brief OUTPUT WORD ENABLE :
                      --! ワードイネーブル信号出力.
                      out std_logic_vector(O_WIDTH*ENBL_BITS-1 downto 0);
        O_DONE      : --! @brief OUTPUT WORD DONE :
                      --! 最終ワード信号出力.
                      --! * 最後のワードデータ出力であることを示すフラグ.
                      --! * O_FLUSH信号との違いはFLUSH_ENABLEの項を参照.
                      out std_logic;
        O_FLUSH     : --! @brief OUTPUT WORD FLUSH :
                      --! 最終ワード信号出力.
                      --! * 最後のワードデータ出力であることを示すフラグ.
                      --! * O_DONE信号との違いはFLUSH_ENABLEの項を参照.
                      out std_logic;
        O_VAL       : --! @brief OUTPUT WORD VALID :
                      --! 出力ワード有効信号.
                      --! * O_DATA/O_ENBL/O_DONE/O_FLUSHが有効であることを示す.
                      --! * O_VAL='1'and O_RDY='1'でワードデータがキューから取り除かれる.
                      out std_logic;
        O_RDY       : --! @brief OUTPUT WORD READY :
                      --! 出力レディ信号.
                      --! * キューから次のワードを取り除く準備が出来ていることを示す.
                      --! * O_VAL='1'and O_RDY='1'でワードデータがキューから取り除かれる.
                      in  std_logic
    );
end component;
-----------------------------------------------------------------------------------
-- QUEUE_ARBITER                                                                 --
-----------------------------------------------------------------------------------
component QUEUE_ARBITER
    generic (
        MIN_NUM     : --! @brief REQUEST MINIMUM NUMBER :
                      --! リクエストの最小番号を指定する.
                      integer := 0;
        MAX_NUM     : --! @brief REQUEST MAXIMUM NUMBER :
                      --! リクエストの最大番号を指定する.
                      integer := 7
    );
    port (
        CLK         : --! @brief CLOCK :
                      --! クロック信号
                      in  std_logic; 
        RST         : --! @brief ASYNCRONOUSE RESET :
                      --! 非同期リセット信号.アクティブハイ.
                      in  std_logic;
        CLR         : --! @brief SYNCRONOUSE RESET :
                      --! 同期リセット信号.アクティブハイ.
                      in  std_logic;
        ENABLE      : --! @brief ARBITORATION ENABLE :
                      --! この調停回路を有効にするかどうかを指定する.
                      --! * 幾つかの調停回路を組み合わせて使う場合、設定によっては
                      --!  この調停回路の出力を無効にしたいことがある.
                      --!  その時はこの信号を'0'にすることで簡単に出来る.
                      --! * ENABLE='1'でこの回路は調停を行う.
                      --! * ENABLE='0'でこの回路は調停を行わない.
                      --!   この場合REQUEST信号に関係なREQUEST_OおよびGRANTは'0'になる.
                      --!   リクエストキューの中身は破棄される.
                      in  std_logic := '1';
        REQUEST     : --! @brief REQUEST INPUT :
                      --! リクエスト入力.
                      in  std_logic_vector(MIN_NUM to MAX_NUM);
        GRANT       : --! @brief GRANT OUTPUT :
                      --! 調停結果出力.
                      out std_logic_vector(MIN_NUM to MAX_NUM);
        GRANT_NUM   : --! @brief GRANT NUMBER :
                      --! 許可番号.
                      --! * ただしリクエストキューに次の要求が無い場合でも、
                      --!   なんらかの番号を出力してしまう.
                      out integer   range  MIN_NUM to MAX_NUM;
        REQUEST_O   : --! @brief REQUEST OUTOUT :
                      --! リクエストキューに次の要求があることを示す信号.
                      --! * VALIDと異なり、リクエストキューに次の要求があっても、
                      --!   対応するREQUEST信号が'0'の場合はアサートされない.
                      out std_logic;
        VALID       : --! @brief REQUEST QUEUE VALID :
                      --! リクエストキューに次の要求があることを示す信号.
                      --! * REQUEST_Oと異なり、リスエストキューに次の要求があると
                      --!   対応するREQUEST信号の状態に関わらずアサートされる.
                      out std_logic;
        SHIFT       : --! @brief REQUEST QUEUE SHIFT :
                      --! リクエストキューの先頭からリクエストを取り除く信号.
                      in  std_logic
    );
end component;
end COMPONENTS;
