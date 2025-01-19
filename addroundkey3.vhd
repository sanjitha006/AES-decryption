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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

use ieee.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity xor3 is
  port( 
        
          key9a: in std_logic_vector(31 downto 0);
          key9b: in std_logic_vector(31 downto 0);
          key9c: in std_logic_vector(31 downto 0);
          key9d: in std_logic_vector(31 downto 0);
          s9ina: in std_logic_vector(31 downto 0);
          s9inb:in std_logic_vector(31 downto 0);
          s9inc:in std_logic_vector(31 downto 0);
          s9ind:in std_logic_vector(31 downto 0);
          s9outa: out std_logic_vector(31 downto 0);
          s9outb: out std_logic_vector(31 downto 0);
          s9outc: out std_logic_vector(31 downto 0);
          s9outd: out std_logic_vector(31 downto 0);
          en9:in std_logic;
          Done9:out std_logic
          );
end xor3;

architecture Behavioral of xor3 is

begin
process(en9)
    begin
        if en9 = '1' then
           
            s9outa <= key9a xor s9ina;
            s9outb <= key9b xor s9inb;
            s9outc <= key9c xor s9inc;
            s9outd <= key9d xor s9ind;
            Done9 <= '1';
        end if;
    end process;
end architecture behavioral;