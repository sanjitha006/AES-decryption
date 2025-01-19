----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 26.10.2024 23:53:04
-- Design Name: 
-- Module Name: invmixcolumns_tb - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

entity invmixcolumns_tb is
end invmixcolumns_tb;

architecture Behavioral of invmixcolumns_tb is

    component invmixcolumns
        port(
            datain: in std_logic_vector(31 downto 0);
            dataout: out std_logic_vector(31 downto 0)
        );
    end component;


    signal datain: std_logic_vector(31 downto 0) := (others => '0');
    signal dataout: std_logic_vector(31 downto 0);

begin
 
    uut: invmixcolumns port map(
        datain => datain,
        dataout => dataout
    );

 
    process
    begin
        -- Test case 1
        datain <= x"01234567";
        wait for 10 ns;
       
        -- Test case 2
        datain <= x"89ABCDEF";
        wait for 10 ns;

        -- Test case 3
        datain <= x"FEDCBA98";
        wait for 10 ns;

        -- Test case 4
        datain <= x"A1B2C3D4";
        wait for 10 ns;

        -- Test case 5
        datain <= x"8B426DD5";
        wait for 10 ns;

        -- End simulation
        wait;
    end process;

end Behavioral;

