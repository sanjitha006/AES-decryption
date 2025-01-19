

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity sub_byte1 is
    Port (
        clock_s4       : in  std_logic; 

        s4ina: in std_logic_vector(31 downto 0);
        s4inb:in std_logic_vector(31 downto 0);
        s4inc:in std_logic_vector(31 downto 0);
        s4ind:in std_logic_vector(31 downto 0);
        s4outa: out std_logic_vector(31 downto 0);
        s4outb: out std_logic_vector(31 downto 0);
        s4outc: out std_logic_vector(31 downto 0);
        s4outd: out std_logic_vector(31 downto 0);
        en4: in std_logic;
        Done4:out std_logic
        );
end sub_byte1;

architecture Behavioral of sub_byte1 is

    component dist_mem_gen_1
        Port (
            a   : in  std_logic_vector(7 downto 0);
            spo : out std_logic_vector(7 downto 0)
        );
    end component;
    signal addr_sig_out: std_logic_vector(7 downto 0);
    signal data_sig_out: std_logic_vector(7 downto 0);


    function CalculateK(i : integer; j : integer) return std_logic_vector is
        variable k : integer;
    begin
        k := (16 * i) + j; 
        return std_logic_vector(to_unsigned(k, 8));  
    end function;
begin

    dist_mem_inst : dist_mem_gen_1
        port map (a => addr_sig_out,spo => data_sig_out);

   
    process(clock_s4)
    variable phase : integer := 0; 
    variable addr_counter:integer :=0;
    variable cycle_count:integer:=0;
    variable current_byte:std_logic_vector(7 downto 0);
    begin
     if rising_edge(clock_s4) then
     if en4='1' then
                   case phase is
                           
                            when 0 =>
                                if addr_counter < 4 then
                                 current_byte := s4ina((31 - (addr_counter * 8)) downto (24-addr_counter*8));
                                 
                                elsif addr_counter < 8 then
                                  current_byte := s4inb((31-(addr_counter-4)*8) downto (24-(addr_counter-4)*8)) ;
                                elsif addr_counter < 12 then
                                  current_byte := s4inc((31-(addr_counter-8)*8) downto (24-(addr_counter-8)*8));
                                else
                                  current_byte := s4ind((31-(addr_counter-12)*8) downto (24-(addr_counter-12)*8)) ;
                                end if;
                                   addr_sig_out <= CalculateK(to_integer(unsigned(current_byte(7 downto 4))),to_integer(unsigned(current_byte(3 downto 0))));
                                     
                                
                                phase := 1; 

                            when 1 =>
                                if cycle_count < 4 then
                                    cycle_count := cycle_count + 1;
                                else
                                    cycle_count := 0;  
                                    phase := 2;  
                                end if;

                            when 2 =>
                               
                             
                                if addr_counter < 4 then
                                    s4outa((31-addr_counter*8) downto (24-addr_counter*8)) <= data_sig_out;
                                elsif addr_counter < 8 then
                                    s4outb((31-(addr_counter-4)*8) downto (24-(addr_counter-4)*8)) <= data_sig_out;
                                elsif addr_counter < 12 then
                                    s4outc((31-(addr_counter-8)*8) downto (24-(addr_counter-8)*8)) <= data_sig_out;
                                else
                                    s4outd((31-(addr_counter-12)*8) downto (24-(addr_counter-12)*8)) <= data_sig_out;
                                end if;

                                addr_counter := addr_counter + 1;  -- Increment data counter

                                
                                if addr_counter = 16 then
                                    addr_counter:=0;
                                    Done4<='1';  -- Set cipher_complete to 1 after 16 chars
                                else
                                    phase := 0;  -- Return to address phase for the next data
                                end if;

                            when others =>
                                phase := 0;  -- Default back to phase 0
                        end case;
                  
     end if;   
     end if;      
    end process;

end Behavioral;