
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY tb_sub_byte IS
END tb_sub_byte;

ARCHITECTURE behavior OF tb_sub_byte IS

    COMPONENT sub_byte
    PORT(
        clock      : IN  STD_LOGIC;
        input_arr  : IN STD_LOGIC_VECTOR(127 DOWNTO 0);
        out_arr    : OUT STD_LOGIC_VECTOR(127 DOWNTO 0);
        ready :IN STD_LOGIC;
        addr_sig_out : inout std_logic_vector(7 downto 0);  -- Expose addr_sig for debugging
        data_sig_out : inout std_logic_vector(7 downto 0) 
        
    );
    END COMPONENT;
   
  
    COMPONENT blk_mem_gen_0
    PORT(
        clka   : IN  STD_LOGIC;
        ena    : IN  STD_LOGIC;
        wea    : IN  STD_LOGIC_VECTOR(0 DOWNTO 0);
        addra  : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
        dina   : IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
        douta  : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
    );
    END COMPONENT;

    signal clock       : STD_LOGIC := '0';
    signal input_arr   : STD_LOGIC_VECTOR(127 DOWNTO 0);
    signal out_arr     : STD_LOGIC_VECTOR(127 DOWNTO 0);
    signal ready :STD_LOGIC:='0';
    signal addr_sig_out : std_logic_vector(7 downto 0);
    signal data_sig_out : std_logic_vector(7 downto 0);
    
    signal ena         : STD_LOGIC := '0';
    signal wea         : STD_LOGIC_VECTOR(0 DOWNTO 0) := "0";
    signal rdaddress   : STD_LOGIC_VECTOR(3 DOWNTO 0) := (others => '0');
    signal data        : STD_LOGIC_VECTOR(7 DOWNTO 0);
    signal temp_input  : STD_LOGIC_VECTOR(127 DOWNTO 0) := (others => '0');
    signal dina        : STD_LOGIC_VECTOR(7 DOWNTO 0) := (others => '0');
    constant clock_period : time := 10 ns;

 
BEGIN
    
    uut: sub_byte PORT MAP (
        clock     => clock,
        input_arr => input_arr,
        out_arr   => out_arr,
        ready => ready,
        addr_sig_out => addr_sig_out, 
        data_sig_out => data_sig_out
    );

   
    bram_inst : blk_mem_gen_0 PORT MAP (
        clka  => clock,
        ena   => ena,
        wea   => wea,
        addra => rdaddress,
        dina  => dina,    
        douta => data
    );
   

    clock_process : process
    begin
        clock <= '0';
        wait for clock_period / 2;
        clock <= '1';
        wait for clock_period / 2;
    end process;

    stimulus_process: process
    begin
        wait for 100 ns;  
        ena <= '1';

        for i in 0 to 15 loop
            rdaddress <= std_logic_vector(to_unsigned(i, 4));
            wait for 20 ns;
            temp_input((127 - (i * 8)) downto (120 - (i * 8))) <= data;
        end loop;

     
        input_arr <= temp_input;
        
        ena <= '0';
        wait for 40 ns; 
        ready<='1';

        wait; 
    end process;
END;
