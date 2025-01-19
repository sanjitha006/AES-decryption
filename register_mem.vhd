

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

use ieee.numeric_std.all;

entity register_mem is
    Port ( 
        clk_r: in std_logic;
        addr_read1 : in integer;  --to read from cipher text the first address bit of the whole 128 bit block
        addr_read2 : in integer;  --address to read from key (depends on round number) but same for all 128 bit blocks
        addr_write:in integer; -- the first bit address to write in blk_mem_gen_0 of the whole 128 bit block
        reading : in std_logic;                        -- Control signal for reading
        writing : in std_logic;                        -- Control signal for writing
        wt_read : in std_logic;     --where to read from - cipher 0(dist_mem_gen_2) or blk_mem_gen_0 which has temp output 1 from the sub_bytestates          
        en1 : in std_logic;                           
        done1 : out std_logic;           
        
        wt_writea:in std_logic_vector(31 downto 0);             --all these from fsm wt_writeouta,...
        wt_writeb:in std_logic_vector(31 downto 0); 
        wt_writec:in std_logic_vector(31 downto 0); 
        wt_writed:in std_logic_vector(31 downto 0); 
                        
        out_ciphera : out std_logic_vector(31 downto 0);
        out_cipherb : out std_logic_vector(31 downto 0);
        out_cipherc : out std_logic_vector(31 downto 0);
        out_cipherd : out std_logic_vector(31 downto 0);        ---all these to fsm wt_reada,..
        out_keya : out std_logic_vector(31 downto 0);
        out_keyb : out std_logic_vector(31 downto 0);
        out_keyc : out std_logic_vector(31 downto 0);
        out_keyd : out std_logic_vector(31 downto 0)
        
       
    );
end register_mem;

architecture Behavioral of register_mem is

    
    component blk_mem_gen_0  --temp output 
        Port (
            clka : in STD_LOGIC;
            ena : in STD_LOGIC;
            wea : in STD_LOGIC_VECTOR(0 downto 0);
            addra : in STD_LOGIC_VECTOR(3 downto 0);  --here change whenever 'count' changes 
            dina : in STD_LOGIC_VECTOR(7 downto 0);
            douta : out STD_LOGIC_VECTOR(7 downto 0)
        );
    end component;
    
    component dist_mem_gen_1 ---soe
        Port (
            a   : in  std_logic_vector(7 downto 0);
            spo : out std_logic_vector(7 downto 0)
        );
    end component;
    
    component dist_mem_gen_2  --cipher
        Port (
            a   : in  std_logic_vector(3 downto 0);
            spo : out std_logic_vector(7 downto 0)
        );
    end component;
    
    component dist_mem_gen_3 --key
        Port (
            a   : in  std_logic_vector(7 downto 0);
            spo : out std_logic_vector(7 downto 0)
        );
    end component;

    signal addr0:std_logic_vector(3 downto 0);
    signal addr1:std_logic_vector(7 downto 0);
    signal addr2:std_logic_vector(3 downto 0);
    signal addr3:std_logic_vector(7 downto 0);
    
    signal data0:std_logic_vector(7 downto 0);
    signal data1:std_logic_vector(7 downto 0);
    signal data2:std_logic_vector(7 downto 0);
    signal data3:std_logic_vector(7 downto 0);
    
    signal r0 : std_logic := '0';
    signal w0 : std_logic_vector(0 downto 0):="0";
    signal din0: std_logic_vector(7 downto 0):="00000000";
    
begin
    dut1: blk_mem_gen_0
        Port Map (clka => clk_r,ena => r0,wea => w0,addra => addr0,dina =>din0,douta => data0
        );
    dut2: dist_mem_gen_1
        Port Map (a => addr1,spo => data1
        );
    dut3: dist_mem_gen_2
        Port Map (a => addr2,spo => data2
        );
    dut4: dist_mem_gen_3
        Port Map (a => addr3,spo => data3
        );
   

   
   
    process(clk_r)
    variable cycle_count : integer := 0;     
      -- Variable for cycle counting to create delay
    variable addr_counter : integer := addr_read1;
           -- Variable for tracking address offset
    variable addr_counter2 : integer range 0 to 15 := addr_write;
    variable data_counter : integer := 0;        -- Variable for tracking data storage position
    variable phase : integer := 0;               -- Variable to handle different phases
    variable cipher_complete:std_logic:='0';
    variable write_complete:std_logic:='0';
begin
    if rising_edge(clk_r) then
        if (en1 = '1') then
            
            if (reading = '1') then
                if cipher_complete = '0' then
                    if wt_read = '0' then
                        
                        case phase is
                           
                            when 0 =>
                                r0<='1';
                                addr0<= std_logic_vector(to_unsigned(addr_counter, 4));
                                
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
                                    out_ciphera((31-addr_counter*8) downto (24-addr_counter*8)) <= data0;
                                elsif addr_counter < 8 then
                                    out_cipherb((31-(addr_counter-4)*8) downto (24-(addr_counter-4)*8)) <= data0;
                                elsif addr_counter < 12 then
                                    out_cipherc((31-(addr_counter-8)*8) downto (24-(addr_counter-8)*8)) <= data0;
                                else
                                    out_cipherd((31-(addr_counter-12)*8) downto (24-(addr_counter-12)*8)) <= data0;
                                end if;

                                addr_counter := addr_counter + 1;  -- Increment data counter

                                -- Check if all 16 characters are processed
                                if addr_counter = 16 then
                                    cipher_complete := '1'; 
                                    addr_counter:=0;
                                    r0<='0'; -- Set cipher_complete to 1 after 16 chars
                                else
                                    phase := 0;  -- Return to address phase for the next data
                                end if;

                            when others =>
                                phase := 0;  -- Default back to phase 0
                        end case;
                
                 
                
                    

                    elsif wt_read = '1' then
                       case phase is
                           
                            when 0 =>
                                r0<='1';
                                addr2<= std_logic_vector(to_unsigned(addr_counter, 4));
                                
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
                                    out_ciphera((31-addr_counter*8) downto (24-addr_counter*8)) <= data2;
                                elsif addr_counter < 8 then
                                    out_cipherb((31-(addr_counter-4)*8) downto (24-(addr_counter-4)*8)) <= data2;
                                elsif addr_counter < 12 then
                                    out_cipherc((31-(addr_counter-8)*8) downto (24-(addr_counter-8)*8)) <= data2;
                                else
                                    out_cipherd((31-(addr_counter-12)*8) downto (24-(addr_counter-12)*8)) <= data2;
                                end if;

                                addr_counter := addr_counter + 1;  -- Increment data counter

                                -- Check if all 16 characters are processed
                                if addr_counter = 16 then
                                addr_counter:=0;
                                    cipher_complete := '1';
                                    r0<='0';  -- Set cipher_complete to 1 after 16 chars
                                else
                                    phase := 0;  -- Return to address phase for the next data
                                end if;

                            when others =>
                                phase := 0;  -- Default back to phase 0
                        end case;
                    end if;
                
                elsif cipher_complete='1' then
                    case phase is
                           
                            when 0 =>
                                r0<='1';
                                addr3<= std_logic_vector(to_unsigned(addr_counter, 8));
                                
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
                                    out_keya((31-addr_counter*8) downto (24-addr_counter*8)) <= data3;
                                elsif addr_counter < 8 then
                                    out_keyb((31-(addr_counter-4)*8) downto (24-(addr_counter-4)*8)) <= data3;
                                elsif addr_counter < 12 then
                                    out_keyc((31-(addr_counter-8)*8) downto (24-(addr_counter-8)*8)) <= data3;
                                else
                                    out_keyd((31-(addr_counter-12)*8) downto (24-(addr_counter-12)*8)) <= data3;
                                end if;

                                addr_counter := addr_counter + 1;  -- Increment data counter

                                -- Check if all 16 characters are processed
                                if addr_counter = 16 then
                                addr_counter:=0;
                                    cipher_complete := '1'; 
                                    r0<='0'; -- Set cipher_complete to 1 after 16 chars
                                    Done1<='1';
                                else
                                    phase := 0;  -- Return to address phase for the next data
                                end if;

                            when others =>
                                phase := 0;  -- Default back to phase 0
                        end case;
                        
                 end if;   
            elsif (writing = '1') then
               
             if write_complete='0' then
                case phase is
                           
                            when 0 =>
                                w0<="1";
                                addr0<= std_logic_vector(to_unsigned(addr_counter2, 4));
                                if addr_counter < 4 then
                                    
                                    din0<=wt_writea((31-addr_counter2*8) downto (24-addr_counter2*8));
                                elsif addr_counter < 8 then
                                    din0<=wt_writeb((31-(addr_counter2-4)*8) downto (24-(addr_counter2-4)*8)) ;
                                elsif addr_counter < 12 then
                                    din0<=wt_writec((31-(addr_counter2-8)*8) downto (24-(addr_counter2-8)*8)) ;
                                else
                                    din0<=wt_writed((31-(addr_counter2-12)*8) downto (24-(addr_counter2-12)*8)) ;
                                end if;
                                addr_counter := addr_counter + 1;
                                phase := 1; 

                            when 1 =>
                                if cycle_count < 8 then
                                    cycle_count := cycle_count + 1;
                                else
                                    cycle_count := 0;
                                    if addr_counter = 16 then
                                    w0<="0";
                                    addr_counter:=0;
                                    write_complete := '1';   
                                    Done1<='1';
                                    else
                                    phase := 0;  
                                    end if;
                                end if;
                            when others=>
                            null;
                            end case;
                                end if;
                        
                           
          
        end if;
        end if;
        end if;
    end process;

end Behavioral;
