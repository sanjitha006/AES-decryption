----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 26.10.2024 23:49:59
-- Design Name: 
-- Module Name: addroundkey_tb - Behavioral
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

entity addroundkey_tb is
end addroundkey_tb;

architecture behavioral of addroundkey_tb is

    signal key: std_logic_vector(31 downto 0);
    signal input: std_logic_vector(31 downto 0);
    signal output: std_logic_vector(31 downto 0);

begin

    uut: entity work.addroundkey
        port map (
            key => key,
            input => input,
            output => output
        );

    process
    begin

        key <= X"00112233";
        input <= X"FF00EE11";
        wait for 10 ns;

        key <= X"FFFFFFFF";
        input <= X"00000000";
        wait for 10 ns;

        key <= X"12345678";
        input <= X"FEDCBA09";
        wait for 10 ns;

        key <= X"A5A5A5A5";
        input <= X"5A5A5A5A";
        wait for 10 ns;

        key <= X"00000001";
        input <= X"FFFFFFFF";
        wait for 10 ns;

        wait;
    end process;
end behavioral;