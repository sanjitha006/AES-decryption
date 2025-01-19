----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10.11.2024 18:00:00
-- Design Name: 
-- Module Name: addroundkey2 - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity xor2 is
 port( 
        
          key5a: in std_logic_vector(31 downto 0);
          key5b: in std_logic_vector(31 downto 0);
          key5c: in std_logic_vector(31 downto 0);
          key5d: in std_logic_vector(31 downto 0);
          s5ina: in std_logic_vector(31 downto 0);
          s5inb:in std_logic_vector(31 downto 0);
          s5inc:in std_logic_vector(31 downto 0);
          s5ind:in std_logic_vector(31 downto 0);
          s5outa: out std_logic_vector(31 downto 0);
          s5outb: out std_logic_vector(31 downto 0);
          s5outc: out std_logic_vector(31 downto 0);
          s5outd: out std_logic_vector(31 downto 0);
          en5:in std_logic;
          Done5:out std_logic
          );
end xor2;

architecture Behavioral of xor2 is

begin
process(en5)
    begin
        if en5 = '1' then
           
            s5outa <= key5a xor s5ina;
            s5outb <= key5b xor s5inb;
            s5outc <= key5c xor s5inc;
            s5outd <= key5d xor s5ind;
            Done5 <= '1';
        end if;
    end process;
end architecture behavioral;