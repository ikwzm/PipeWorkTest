-----------------------------------------------------------------------------------
--!     @file    test_bench_template.vhd
--!     @brief   TEST MODEL for REDUCER :
--!     @version 1.0.0
--!     @date    2012/4/3
--!     @author  Ichiro Kawazome <ichiro_k@ca2.so-net.ne.jp>
-----------------------------------------------------------------------------------
library ieee;
use     ieee.std_logic_1164.all;
use     WORK.COMPONENTS.REDUCER;
use     WORK.COMPONENTS.REDUCER_TEST_MODEL;
entity  REDUCER_TEST_BENCH_DWC_W%W_I%I_O%O_Q%Q_J%J is
    generic(AUTO_FINISH:integer:=1);port(FINISH:out std_logic);
end     REDUCER_TEST_BENCH_DWC_W%W_I%I_O%O_Q%Q_J%J;
architecture MODEL of REDUCER_TEST_BENCH_DWC_W%W_I%I_O%O_Q%Q_J%J is
    constant   WORD_BITS      : integer := %W;
    constant   I_WIDTH        : integer := %I;
    constant   O_WIDTH        : integer := %O;
    constant   QUEUE_SIZE     : integer := %Q;
    constant   FLUSH_ENABLE   : integer :=  1;
    constant   I_JUSTIFIED    : integer := %J;
    constant   NAME           : string(1 to 19) := "DWC_W%W_I%I_O%O_Q%Q_J%J";
    constant   PERIOD         : time    := 10 ns;
    constant   DELAY          : time    :=  1 ns;
    signal     CLK            : std_logic;
    signal     RST            : std_logic;
    signal     CLR            : std_logic;
    signal     START          : std_logic;
    signal     OFFSET         : std_logic_vector(O_WIDTH-1 downto 0);
    signal     DONE           : std_logic;
    signal     FLUSH          : std_logic;
    signal     BUSY           : std_logic;
    signal     I_DATA         : std_logic_vector(I_WIDTH*(WORD_BITS  )-1 downto 0);
    signal     I_ENBL         : std_logic_vector(I_WIDTH*(WORD_BITS/8)-1 downto 0);
    signal     I_DONE         : std_logic;
    signal     I_FLUSH        : std_logic;
    signal     I_VAL          : std_logic;
    signal     I_RDY          : std_logic;
    signal     O_DATA         : std_logic_vector(O_WIDTH*(WORD_BITS  )-1 downto 0);
    signal     O_ENBL         : std_logic_vector(O_WIDTH*(WORD_BITS/8)-1 downto 0);
    signal     O_DONE         : std_logic;
    signal     O_FLUSH        : std_logic;
    signal     O_VAL          : std_logic;
    signal     O_RDY          : std_logic;
    constant   gnd            : std_logic_vector(O_WIDTH-1 downto 0) := (others => '0');
begin
    U:REDUCER
        generic map (
            WORD_BITS     => WORD_BITS,
            ENBL_BITS     => WORD_BITS/8,
            I_WIDTH       => I_WIDTH,
            O_WIDTH       => O_WIDTH,
            QUEUE_SIZE    => QUEUE_SIZE,
            VALID_MIN     => 0,
            VALID_MAX     => 0,
            I_JUSTIFIED   => I_JUSTIFIED,
            FLUSH_ENABLE  => FLUSH_ENABLE
        )
        port map (
            CLK           => CLK,
            RST           => RST,
            CLR           => CLR,
            START         => START,
            OFFSET        => OFFSET,
            DONE          => DONE,
            FLUSH         => FLUSH,
            I_DATA        => I_DATA,
            I_ENBL        => I_ENBL,
            I_FLUSH       => I_FLUSH,
            I_DONE        => I_DONE,
            I_VAL         => I_VAL,
            I_RDY         => I_RDY,
            O_DATA        => O_DATA,
            O_ENBL        => O_ENBL,
            O_FLUSH       => O_FLUSH,
            O_DONE        => O_DONE,
            O_VAL         => O_VAL,
            O_RDY         => O_RDY,
            BUSY          => BUSY ,
            VALID         => open
        );
    O:REDUCER_TEST_MODEL
        generic map (
            AUTO_FINISH   => AUTO_FINISH,
            NAME          => NAME,
            DELAY         => DELAY,
            WORD_BITS     => WORD_BITS,
            I_WIDTH       => I_WIDTH,
            O_WIDTH       => O_WIDTH,
            I_JUSTIFIED   => I_JUSTIFIED,
            FLUSH_ENABLE  => FLUSH_ENABLE
        )
        port map (
            CLK           => CLK       ,
            RST           => RST       ,
            CLR           => CLR       ,
            FINISH        => FINISH    ,
            START         => START     ,
            OFFSET        => OFFSET    ,
            DONE          => DONE      ,
            FLUSH         => FLUSH     ,
            BUSY          => BUSY      ,
            I_DATA        => I_DATA    ,
            I_ENBL        => I_ENBL    ,
            I_DONE        => I_DONE    ,
            I_FLUSH       => I_FLUSH   ,
            I_VAL         => I_VAL     ,
            I_RDY         => I_RDY     ,
            O_DATA        => O_DATA    ,
            O_ENBL        => O_ENBL    ,
            O_DONE        => O_DONE    ,
            O_FLUSH       => O_FLUSH   ,
            O_VAL         => O_VAL     ,
            O_RDY         => O_RDY     
        );
    process begin
        CLK <= '1'; wait for PERIOD/2;
        CLK <= '0'; wait for PERIOD/2;
    end process;
end MODEL;
