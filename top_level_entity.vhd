
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity top_level_entity is
    Port (
        clk_disp : in STD_LOGIC;
        anode : out STD_LOGIC_VECTOR(3 downto 0);
        seg:out STD_LOGIC_VECTOR(6 downto 0);
        en10:in std_logic;
        Done10:out std_logic
    );
end top_level_entity;

architecture Behavioral of top_level_entity is

    component scrolling_display
        Port (
            char_input_2 : in STD_LOGIC_VECTOR(31 downto 0);
            clk_2 : in STD_LOGIC;
            anode_2 : out STD_LOGIC_VECTOR(3 downto 0);      
            seg_2 : out STD_LOGIC_VECTOR(6 downto 0)
        );
    end component;

    component blk_mem_gen_0
        Port (
            clka : in STD_LOGIC;
            ena : in STD_LOGIC;
            wea : in STD_LOGIC_VECTOR(0 downto 0);
            addra : in STD_LOGIC_VECTOR(3 downto 0);
            dina : in STD_LOGIC_VECTOR(7 downto 0);
            douta : out STD_LOGIC_VECTOR(7 downto 0)
        );
    end component;

    signal char_input : STD_LOGIC_VECTOR(31 downto 0) := (others => '0');
    signal ena : STD_LOGIC := '1';
    signal wea : STD_LOGIC_VECTOR(0 downto 0) := "0";
    signal rdaddress : STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
    signal data : STD_LOGIC_VECTOR(7 downto 0);   
    signal read_complete : STD_LOGIC := '0';
  
  
    
    

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
            when "01100001" => ascii_value := "00001010"; -- a
            when "01100010" => ascii_value := "00001011"; -- b
            when "01100011" => ascii_value := "00001100"; -- c
            when "01100100" => ascii_value := "00001101"; -- d
            when "01100101" => ascii_value := "00001110"; -- e
            when "01100110" => ascii_value := "00001111"; -- f
            when others => ascii_value := "11111111";
        end case;
        return ascii_value;
    end function;

begin

    DUT1: scrolling_display
        Port Map (char_input_2 => char_input, clk_2 => clk_disp, anode_2 => anode, seg_2 => seg);

    mem_inst: blk_mem_gen_0
        Port Map (clka => clk_disp, ena => ena, wea => wea, addra => rdaddress(3 downto 0), dina => (others => '0'), douta => data);
    
    
    
 
    

    
    
    
process(clk_disp)
    variable temp_input : STD_LOGIC_VECTOR(31 DOWNTO 0) := (others => '0');
    variable address_index : integer range 0 to 3 := 0;    
    variable delay_count : integer := 0;
    variable read_phase : boolean := true;
    
    variable index : integer := 0; 
    variable cycle_count : integer := 0;    
    variable phase : integer := 0;
    --variable temp_input2 : STD_LOGIC_VECTOR(31 DOWNTO 0) := (others => '0');
   
begin
    if rising_edge(clk_disp) then
     if en10='1' then
        Done10<='0';
        if read_complete = '0' then
            if read_phase = true then
                ena <= '1';
                rdaddress <= std_logic_vector(to_unsigned(address_index, 8));
                delay_count := 0;
                read_phase := false;
            else
                -- Increase delay cycles to ensure data stability
                if delay_count < 4 then
                    delay_count := delay_count + 1;
                else
                    -- Read data into temp_input once stabilized
                    temp_input(31 - address_index * 8 downto 24 - address_index * 8) := hex_to_ascii(data);
                    ena <= '0';

                    if address_index < 3 then
                        address_index := address_index + 1;
                        read_phase := true;
                    else
                        read_complete <= '1';
                        char_input <= temp_input;
                        
                    end if;
                end if;
            end if;
        
        
        elsif read_complete='1' then
        
        case phase is
              
                when 0 =>  
                    if cycle_count < 1000000000 then ---for basys keep 1000000000 fro simulation keep 2000000(2 ms fro simulation and 1 sec for basys)
                        cycle_count := cycle_count + 1;
                    else
                        cycle_count := 0;
                        phase := 1;
                    end if;
                   
                when 1 =>  
                    for i in 0 to 2 loop
                        char_input(31 - i*8 downto (24- i*8)) <= char_input(23 - i*8 downto (16 - i*8));
                    end loop;
                    ena <= '1';
                    rdaddress <= std_logic_vector(to_unsigned((index + 4) mod 16, 8));
                    cycle_count := 0;
                    phase := 2;
                   
                when 2 =>  
                    if cycle_count < 4 then
                        cycle_count := cycle_count + 1;
                    else
                        ena <= '0';
                        char_input(7 downto 0) <= hex_to_ascii(data);
                       
                        cycle_count := 0;
                        phase := 3;
                    end if;

                when 3 =>  
                    if cycle_count < 1000000000 then ---for basys keep 1000000000 fro simulation keep 2000000(2 ms fro simulation and 1 sec for basys)
                        cycle_count := cycle_count + 1;
                    else
                        cycle_count := 0;
                        index := (index + 1) mod 16;
                        phase := 1;
                    end if;

                when others =>
                    phase := 3;
            end case;
        
        end if;
     end if;   
    end if;
end process;




end behavioral;