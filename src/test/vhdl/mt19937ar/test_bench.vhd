-----------------------------------------------------------------------------------
--                                                                               --
--      Title        : Test Bench for Pseudo Random Number Generators Package    --
--      Module Name  : TEST_BENCH                                                --
--      Version      : 0.0.2                                                     --
--      Created      : 2012/3/28                                                 --
--      File Name    : test_bench.vhd                                            --
--      Author       : Ichiro Kawazome <ichiro_k@ca2.so-net.ne.jp>               --
--                                                                               --
-----------------------------------------------------------------------------------
library ieee;
use     ieee.std_logic_1164.all;
use     ieee.numeric_std.all;
use     std.textio.all;
use     work.MT19937AR.SEED_VECTOR;
use     work.MT19937AR.PSEUDO_RANDOM_NUMBER_GENERATOR_TYPE;
use     work.MT19937AR.NEW_PSEUDO_RANDOM_NUMBER_GENERATOR;
use     work.MT19937AR.GENERATE_RANDOM_STD_LOGIC_VECTOR;
use     work.MT19937AR.GENERATE_RANDOM_REAL2;
entity  TEST_BENCH is
end     TEST_BENCH;
architecture MODEL of TEST_BENCH is
begin
    process
        ---------------------------------------------------------------------------
        -- unsigned to decimal string.
        ---------------------------------------------------------------------------
        function TO_DEC_STRING(arg:unsigned;len:integer;space:character) return STRING is
            variable str   : STRING(len downto 1);
            variable value : unsigned(arg'length-1 downto 0);
        begin
            value  := arg;
            for i in str'right to str'left loop
                if (value > 0) then
                    case (to_integer(value mod 10)) is
                        when 0      => str(i) := '0';
                        when 1      => str(i) := '1';
                        when 2      => str(i) := '2';
                        when 3      => str(i) := '3';
                        when 4      => str(i) := '4';
                        when 5      => str(i) := '5';
                        when 6      => str(i) := '6';
                        when 7      => str(i) := '7';
                        when 8      => str(i) := '8';
                        when 9      => str(i) := '9';
                        when others => str(i) := 'X';
                    end case;
                else
                    if (i = str'right) then
                        str(i) := '0';
                    else
                        str(i) := space;
                    end if;
                end if;
                value := value / 10;
            end loop;
            return str;
        end function;
        ---------------------------------------------------------------------------
        -- unsigned to decimal string
        ---------------------------------------------------------------------------
        function TO_DEC_STRING(arg:unsigned;len:integer) return STRING is
        begin
            return  TO_DEC_STRING(arg,len,' ');
        end function;
        ---------------------------------------------------------------------------
        -- real number to decimal string.
        ---------------------------------------------------------------------------
        function TO_DEC_STRING(arg:real;len1,len2:integer) return STRING is
            variable str   : STRING(len2-1 downto 0);
            variable i,n,p : integer;
        begin
            i := integer(arg);
            if    real(i) = arg then
                n := i;
            elsif i > 0 and real(i) > arg then
                n := i-1;  
            elsif i < 0 and real(i) < arg then
                n := i+1;
            else  
                n := i;
            end if;
            p := integer((arg-real(n))*(10.0**len2));
            return  TO_DEC_STRING(to_unsigned(n,len1-len2-1),len1-len2-1,' ') & "." & 
                    TO_DEC_STRING(to_unsigned(p,32),len2,'0');
        end function;
        ---------------------------------------------------------------------------
        -- Seed Numbers for Pseudo Random Number Generator.
        ---------------------------------------------------------------------------
        variable seed      : SEED_VECTOR(0 to 3) := (0 => X"00000123",
                                                     1 => X"00000234",
                                                     2 => X"00000345",
                                                     3 => X"00000456");
        ---------------------------------------------------------------------------
        -- Pseudo Random Number Generator Instance.
        ---------------------------------------------------------------------------
        variable prng      : PSEUDO_RANDOM_NUMBER_GENERATOR_TYPE := NEW_PSEUDO_RANDOM_NUMBER_GENERATOR(seed);
        ---------------------------------------------------------------------------
        -- Random number 
        ---------------------------------------------------------------------------
        variable vec       : std_logic_vector(31 downto 0);
        variable num       : real;
        ---------------------------------------------------------------------------
        -- for display
        ---------------------------------------------------------------------------
        constant TAG       : STRING(1 to 1) := " ";
        constant SPACE     : STRING(1 to 1) := " ";
        variable text_line : LINE;
    begin
        WRITE(text_line, TAG & "1000 outputs of genrand_int32()");
        WRITELINE(OUTPUT, text_line);
        for i in 0 to 999 loop
            GENERATE_RANDOM_STD_LOGIC_VECTOR(prng,vec);
            WRITE(text_line, TO_DEC_STRING(unsigned(vec),10));
            WRITE(text_line, SPACE);
            if (i mod 5 = 4) then
                WRITELINE(OUTPUT, text_line);
            end if;
        end loop;
        WRITELINE(OUTPUT, text_line);

        WRITE(text_line, TAG & "1000 outputs of genrand_real2()");
        WRITELINE(OUTPUT, text_line);
        for i in 0 to 999 loop
            GENERATE_RANDOM_REAL2(prng,num);
            WRITE(text_line, TO_DEC_STRING(num,10,8));
            WRITE(text_line, SPACE);
            if (i mod 5 = 4) then
                WRITELINE(OUTPUT, text_line);
            end if;
        end loop;
        WRITELINE(OUTPUT, text_line);

        assert(false) report TAG & " Run complete..." severity FAILURE;
        wait;
    end process;
end MODEL;
