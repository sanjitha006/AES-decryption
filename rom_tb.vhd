----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 26.10.2024 15:06:11
-- Design Name: 
-- Module Name: rom_tb - Behavioral
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

entity rom_tb is   
end rom_tb;

architecture Behavioral of rom_tb is
    component dist_mem_gen_1
            Port (
                a   : in  std_logic_vector(7 downto 0);
                spo : out std_logic_vector(7 downto 0)
            );
        end component;
    signal address    : std_logic_vector(7 downto 0);
    signal data :std_logic_vector(7 downto 0);
    

begin
    uut: dist_mem_gen_1
        port map (
            a=>address,
            spo=>data
        );
 
    stimulus : process
    begin
  
        address <= "00000000"; -- Read from address 0
        wait for 20 ns;
        
        address <= "00010000"; -- Read from address 1
        wait for 20 ns;
        
        address <= "00100000"; -- Read from address 2
        wait for 20 ns;
        
        address <= "00110000"; -- Read from address 3
        wait for 20 ns;
        
        address <= "01000000"; -- Read from address 4
        wait for 20 ns;
        
        address <= "01011100"; -- Read from address 4
        wait for 20 ns;
        
        address <= "01101111"; -- Read from address 4
        wait for 20 ns;
        
        address <= "01110010"; -- Read from address 4
        wait for 20 ns;
        
        address <= "10001110"; -- Read from address 4
        wait for 20 ns;
        
        address <= "10011111"; -- Read from address 4
        wait for 20 ns;
  end process;
end Behavioral;
