LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY tb_top_level_entity IS
END tb_top_level_entity;

ARCHITECTURE behavior OF tb_top_level_entity IS

    COMPONENT top_level_entity
        Port (
            clk : in STD_LOGIC;
            reset : in STD_LOGIC;
            anode : out STD_LOGIC_VECTOR(3 downto 0);
            seg:out STD_LOGIC_VECTOR(6 downto 0)
        );
    END COMPONENT;

    signal clock : STD_LOGIC := '0';
    signal reset : STD_LOGIC := '1';
    constant clock_period : time := 10 ns;

begin

    uut: top_level_entity PORT MAP (
        clk => clock,
        reset => reset
    );

    clock_process : process
    begin
        clock <= '0';
        wait for clock_period/2;
        clock <= '1';
        wait for clock_period/2;
    end process;

    stimulus_process : process
    begin
        reset <= '1';
        wait for 10000000 ns;
        reset <= '0';
        
        wait for 1 ms;
        reset <= '1';
        wait for 10000000 ns;
        reset <= '0';

        wait;
    end process;

end behavior;
