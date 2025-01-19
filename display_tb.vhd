
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

ENTITY tb_scrolling_display IS
END tb_scrolling_display;

ARCHITECTURE behavior OF tb_scrolling_display IS

    COMPONENT scrolling_display
    PORT(
        clk : IN  STD_LOGIC;
        reset : IN  STD_LOGIC;
        char_input : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        anode : OUT STD_LOGIC_VECTOR(3 downto 0);
        seg : OUT STD_LOGIC_VECTOR(6 downto 0);
        r : in STD_LOGIC
       
    );
    END COMPONENT;

    COMPONENT blk_mem_gen_0
    PORT(
        clka  : in  std_logic;                
        ena   : in  std_logic;                
        wea   : in  std_logic_vector(0 downto 0);  
        addra : in  std_logic_vector(3 downto 0);  
        dina  : in  std_logic_vector(7 downto 0);  
        douta : out std_logic_vector(7 downto 0)  
    );
    END COMPONENT;

   
    signal clock : STD_LOGIC := '0';
    signal reset : STD_LOGIC := '1';
    signal char_input : STD_LOGIC_VECTOR(31 DOWNTO 0) := (others => '0');
    signal anode : STD_LOGIC_VECTOR(3 downto 0);  
    signal seg : STD_LOGIC_VECTOR(6 DOWNTO 0);
   
   
    signal ena : std_logic := '0';
    signal wea : std_logic_vector(0 downto 0) := (others => '0');
    signal rdaddress : std_logic_vector(3 downto 0) := (others => '0');
    signal data : std_logic_vector(7 downto 0);
   
    signal dina : std_logic_vector(7 downto 0) := (others => '0');
    signal r : STD_LOGIC := '0';
    constant clock_period : time := 10 ns;
   

    function hex_to_ascii(hex_value : STD_LOGIC_VECTOR(7 DOWNTO 0)) return STD_LOGIC_VECTOR is
        variable ascii_value : STD_LOGIC_VECTOR(7 DOWNTO 0);
    begin
        case hex_value is
           
            when "00100000" => ascii_value := "11110000"; -- space
            when "00110000" => ascii_value := "00000000"; -- 0
            when "00110001" => ascii_value := "00000001"; -- 1
            when "00110010" => ascii_value := "00000010"; -- 2
            when "00110011" => ascii_value := "00000011"; -- 3
            when "00110100" => ascii_value := "00000100"; -- 4
            when "00110101" => ascii_value := "00000101"; -- 5
            when "00110110" => ascii_value := "00000110"; -- 6
            when "00110111" => ascii_value := "00000111"; -- 7
            when "00111000" => ascii_value := "00001000"; -- 8
            when "00111001" => ascii_value := "00001001"; -- 9
           
            when "01000001" => ascii_value := "00001010"; -- A
            when "01000010" => ascii_value := "00001011"; -- B
            when "01000011" => ascii_value := "00001100"; -- C
            when "01000100" => ascii_value := "00001101"; -- D
            when "01000101" => ascii_value := "00001110"; -- E
            when "01000110" => ascii_value := "00001111"; -- F
           
            when "01100001" => ascii_value := "00001010"; -- A
            when "01100010" => ascii_value := "00001011"; -- B
            when "01100011" => ascii_value := "00001100"; -- C
            when "01100100" => ascii_value := "00001101"; -- D
            when "01100101" => ascii_value := "00001110"; -- E
            when "01100110" => ascii_value := "00001111"; -- F
            when others => ascii_value := "11111111";
        end case;
        return ascii_value;
    end function;

BEGIN
    uut: scrolling_display PORT MAP (
        clk => clock,
        reset => reset,
        char_input => char_input,
        anode => anode,
        seg => seg,
        r=>r
    );

    bram_inst : blk_mem_gen_0 PORT MAP (
        clka => clock,
        ena => ena,
        wea => wea,
        addra => rdaddress,
        dina => dina,    
        douta => data
    );

    clock_process :process
    begin
        clock <= '0';
        wait for clock_period/2;
        clock <= '1';
        wait for clock_period/2;
    end process;



    stimulus_process: process
        variable index : integer := 0;
        variable temp_input : STD_LOGIC_VECTOR(31 DOWNTO 0) := (others => '0');
    begin
        reset <= '1';
        wait for 50 ns;
        reset <= '0';
       
        ena <= '1';
       
       
        for i in 0 to 3 loop
            rdaddress <= std_logic_vector(to_unsigned((index + i) mod 16, 4));
            wait for 20 ns;
           
            temp_input(31 - i*8 downto 24 - i*8) := hex_to_ascii(data);
        end loop;
        ena<='0';
       
        char_input <= temp_input;
        r <= '1';
        wait for 10000000 ns;
        r <= '0';
       
       

        while True loop
           
            for i in 0 to 2 loop
                temp_input(31 - i*8 downto 24 - i*8) := temp_input(23 - i*8 downto 16 - i*8);
            end loop;            
            ena<='1';
            rdaddress <= std_logic_vector(to_unsigned((index + 4) mod 16, 4));
            wait for 20 ns;
            ena<='0';
            temp_input(7 downto 0) := hex_to_ascii(data);
         
            char_input <= temp_input;
            r<='1';
            wait for 10000000 ns;
            r <= '0';
   
            index := (index + 1) mod 16;
        end loop;
    end process;
END behavior;