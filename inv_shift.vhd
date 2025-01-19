
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity invshiftrows is
    Port( 
          s3ina: in std_logic_vector(31 downto 0);
          s3inb:in std_logic_vector(31 downto 0);
          s3inc:in std_logic_vector(31 downto 0);
          s3ind:in std_logic_vector(31 downto 0);
          s3outa: out std_logic_vector(31 downto 0);
          s3outb: out std_logic_vector(31 downto 0);
          s3outc: out std_logic_vector(31 downto 0);
          s3outd: out std_logic_vector(31 downto 0);
          en3:in std_logic;
          Done3:out std_logic
          );
end invshiftrows;

architecture behavioral of invshiftrows is
begin
    process (en3)
    begin
        if en3 = '1' then  
          
           
            s3outa <= s3ina;
            s3outb <= s3inb(7 downto 0) & s3inb(31 downto 8);
            s3outc <= s3inc(15 downto 0) & s3inc(31 downto 16);
            s3outd <= s3ind(23 downto 0) & s3ind(31 downto 24);
           
            Done3 <= '1';
        end if;
    end process;
end behavioral;