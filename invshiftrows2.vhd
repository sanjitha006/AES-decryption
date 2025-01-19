library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity invshiftrows2 is
    Port( 
          s7ina: in std_logic_vector(31 downto 0);
          s7inb: in std_logic_vector(31 downto 0);
          s7inc: in std_logic_vector(31 downto 0);
          s7ind: in std_logic_vector(31 downto 0);
          s7outa: out std_logic_vector(31 downto 0);
          s7outb: out std_logic_vector(31 downto 0);
          s7outc: out std_logic_vector(31 downto 0);
          s7outd: out std_logic_vector(31 downto 0);
          en7: in std_logic;
          Done7: out std_logic
          );
end invshiftrows2;

architecture behavioral of invshiftrows2 is
begin
    process (en7)
    begin
        if en7 = '1' then  
          
            s7outa <= s7ina;
            s7outb <= s7inb(7 downto 0) & s7inb(31 downto 8);
            s7outc <= s7inc(15 downto 0) & s7inc(31 downto 16);
            s7outd <= s7ind(23 downto 0) & s7ind(31 downto 24);
           
            Done7 <= '1';
        end if;
    end process;
end behavioral;
