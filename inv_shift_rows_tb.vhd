----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 25.10.2024 18:22:17
-- Design Name: 
-- Module Name: inv_shift_rows_tb - Behavioral
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

entity invshift_tb is
end invshift_tb;

architecture Behavioral of invshift_tb is

    -- Component declaration for the Unit Under Test (UUT)
    component invshiftrows
        Port( datain: in std_logic_vector(127 downto 0);
              dataout: out std_logic_vector(127 downto 0));
    end component;

    -- Testbench signals
    signal datain: std_logic_vector(127 downto 0);
    signal dataout: std_logic_vector(127 downto 0);

begin
    -- Instantiate the Unit Under Test (UUT)
    uut: invshiftrows
        Port map (
            datain => datain,
            dataout => dataout
        );

    -- Test process
    process
     
    begin
        -- Test Case 1
        datain <= X"00112233445566778899AABBCCDDEEFF";
     
        wait for 10 ns;
       

        -- Test Case 2
        datain <= X"FFFFFFFFEEEEEEEEEEEEEEEEEEEEEEEE";
       
        wait for 10 ns;
       

        -- Test Case 3
        datain <= X"0123456789ABCDEF0123456789ABCDEF";
       
        wait for 10 ns;
       

        -- Test Case 4
        datain <= X"A1B2C3D4E5F607089ABCDEF123456789";
       
        wait for 10 ns;
       

        -- Test Case 5
        datain <= X"00000000000000000000000000000000";
     
   
        wait;  -- End simulation
    end process;

end Behavioral;

