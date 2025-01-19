library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity scrolling_display is
    Port (
        
           char_input_2 : in STD_LOGIC_VECTOR(31 downto 0);
           clk_2 : in STD_LOGIC;
           anode_2 : out STD_LOGIC_VECTOR(3 downto 0);      
           seg_2 : out STD_LOGIC_VECTOR(6 downto 0)

         );
end scrolling_display;

architecture Behavioral of scrolling_display is
     
    signal delay_counter : INTEGER := 0;
    signal refresh_counter : INTEGER := 0;
    signal output_register : STD_LOGIC_VECTOR(31 downto 0);
    signal current_digit : INTEGER range 0 to 3 := 0;
   
    constant REFRESH_LIMIT : INTEGER := 100000;  

 
    function convert_to_seven_segment(char : STD_LOGIC_VECTOR(7 downto 0)) return STD_LOGIC_VECTOR is
        variable seg_output : STD_LOGIC_VECTOR(6 downto 0);
        variable A:STD_logic;
        variable B:STD_logic;
        variable C:STD_logic;
        variable D:STD_logic;
       
    begin
        if(char="11110000") then
            seg_output:="1111111";
        elsif (char(7) = '0' and char(6) = '0' and char(5) = '0' and char(4) = '0') then
            A := char(3);
            B := char(2);
            C := char(1);
            D := char(0);
            seg_output(6) := ((not A and not B and not C and D) or (not A and not C and not D and B) or (not B and A and C and D) or (A and B and not C and D));
            seg_output(5) := ((not A and B and C and not D) or (A and C and D) or (A and B and not D) or (not A and B and D and not C));
            seg_output(4) := ((A and B and not D) or (A and B and C) or (not A and not B and not D and C));
            seg_output(3) := ((not A and not B and not C and D) or (not A and not D and not C and B) or (A and C and not B and not D) or (B and C and D));
            seg_output(2) := ((not A and D) or (not B and not C and D) or (not A and not C and B));
            seg_output(1) := ((not A and not B and C) or (not A and B and D and C) or (not A and not B and D and not C) or (A and B and not C and D));
            seg_output(0) := ((not A and not B and not C) or (B and C and D and not A) or (A and B and not C and not D));
        else    
            seg_output := "1111110";
        end if;
        return seg_output;
    end function;

begin
 
    process(clk_2)
    begin
        if rising_edge(clk_2) then
           
                    output_register <= char_input_2(31 downto 24) & char_input_2(23 downto 16) & char_input_2(15 downto 8) & char_input_2(7 downto 0);

                    if refresh_counter < REFRESH_LIMIT then
                        refresh_counter <= refresh_counter + 1;
                    else
                        refresh_counter <= 0;
                        current_digit <= (current_digit + 1) mod 4;
                       

                        case current_digit is
                            when 0 =>
                                anode_2 <= "0111";
                                seg_2 <= convert_to_seven_segment(output_register(31 downto 24));
                            when 1 =>
                                anode_2 <= "1011";
                                seg_2 <= convert_to_seven_segment(output_register(23 downto 16));
                            when 2 =>
                                anode_2 <= "1101";
                                seg_2 <= convert_to_seven_segment(output_register(15 downto 8));
                            when 3 =>
                                anode_2 <= "1110";
                                seg_2 <= convert_to_seven_segment(output_register(7 downto 0));
                            when others =>
                                anode_2 <= "1111";
                        end case;
                  

            end if;
        end if;
    end process;
end Behavioral;
