----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 26.10.2024 23:49:30
-- Design Name: 
-- Module Name: addroundkey - Behavioral
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

entity xor1 is
    port( key2a: in std_logic_vector(31 downto 0);
          key2b: in std_logic_vector(31 downto 0);
          key2c: in std_logic_vector(31 downto 0);
          key2d: in std_logic_vector(31 downto 0);
          s2ina: in std_logic_vector(31 downto 0);
          s2inb:in std_logic_vector(31 downto 0);
          s2inc:in std_logic_vector(31 downto 0);
          s2ind:in std_logic_vector(31 downto 0);
          s2outa: out std_logic_vector(31 downto 0);
          s2outb: out std_logic_vector(31 downto 0);
          s2outc: out std_logic_vector(31 downto 0);
          s2outd: out std_logic_vector(31 downto 0);
          en2:in std_logic;
          Done2:out std_logic
          );
end xor1;

architecture behavioral of xor1 is
begin
process(en2)
    begin
        if en2 = '1' then
           
            s2outa <= key2a xor s2ina;
            s2outb <= key2b xor s2inb;
            s2outc <= key2c xor s2inc;
            s2outd <= key2d xor s2ind;
            Done2 <= '1';
        end if;
    end process;
end architecture behavioral;
