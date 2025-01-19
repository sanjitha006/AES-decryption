library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

use ieee.numeric_std.all;

entity register_mem is
    Port ( 
        clk_r: inout std_logic;
        addr_read1 : inout integer;  --to read from cipher text the first address bit of the whole 128 bit block
        addr_read2 : inout integer;  --address to read from key (depends on round number) but same for all 128 bit blocks
        addr_write:inout integer; -- the first bit address to write in blk_mem_gen_0 of the whole 128 bit block
        reading : inout std_logic;                        -- Control signal for reading
        writing : inout std_logic;                        -- Control signal for writing
        wt_read : inout std_logic;     --where to read from - cipher 0(dist_mem_gen_2) or blk_mem_gen_0 which has temp output 1 from the sub_bytestates          
        en1 : inout std_logic;                           
        done1 : out std_logic;           
        
        wt_writea:inout std_logic_vector(31 downto 0);             --all these from fsm wt_writeouta,...
        wt_writeb:inout std_logic_vector(31 downto 0); 
        wt_writec:inout std_logic_vector(31 downto 0); 
        wt_writed:inout std_logic_vector(31 downto 0); 
                        
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
    
    
    signal debug_phase: integer := 0;
signal debug_cycle_count : integer := 0;
signal debug_addr_counter : integer := 0;
signal debug_cipher_complete : std_logic := '0';
  -- Use signals instead of variables to track address and phase states
    signal addr_counter : integer := 0;
    signal phase : integer := 0;
    signal cipher_complete : std_logic := '0';
      -- Using signal for phase and counters
   
    
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
   


   -- Clock generation process
clock_proc: process
begin
    clk_r <= '0';
    wait for 5 ns;
    clk_r <= '1';
    wait for 5 ns;
end process;

-- Process to simulate the read and write operations
stim_proc: process
begin
    -- Initialize signals
    en1 <= '1';
   
    reading <= '0';
    writing <= '0';
    wt_read <= '0';
    addr_read1 <= 0;
    addr_read2 <= 0;
    addr_write <= 0;

    -- Wait for global reset to finish
    wait for 10 ns;

    -- Simulate a read operation from dist_mem_gen_2 (cipher memory)
    reading <= '1';
    wt_read <= '0';  -- Read from dist_mem_gen_2
    addr_read1 <= 0; -- Start reading at address 0
    wait for 200 ns; -- Wait for operation to complete
    
    -- Disable read after completion
    reading <= '0';
    wait for 10 ns;

    -- Simulate a read operation from blk_mem_gen_0 (temporary memory)
    reading <= '1';
    wt_read <= '1';  -- Read from blk_mem_gen_0
    addr_read2 <= 1; -- Example address for reading key data
    wait for 200 ns; -- Wait for operation to complete
    
    -- Disable read after completion
    reading <= '0';
    wait for 10 ns;

    -- Simulate a write operation to blk_mem_gen_0
    writing <= '1';
    addr_write <= 0;  -- Starting address for write operation
    wt_writea <= x"AAAAAAAA";
    wt_writeb <= x"BBBBBBBB";
    wt_writec <= x"CCCCCCCC";
    wt_writed <= x"DDDDDDDD";
    
    wait for 10000 ns;  -- Wait for write operation to complete

    -- Disable write after completion
    writing <= '0';
    wait for 50 ns;

    -- End of simulation
    wait;
end process;

    


process(clk_r)

begin
    if rising_edge(clk_r) then
        if (en1 = '1') then
            if (reading = '1') then
                if cipher_complete = '0' then
                    if wt_read = '0' then
                        -- Start Reading Phase for dist_mem_gen_2
                        case phase is
                            when 0 =>
                                r0 <= '1';  -- Enable read
                                addr0 <= std_logic_vector(to_unsigned(addr_counter, 4));
                                phase <= 1;  -- Move to next phase for data processing

                            when 1 =>
                                -- Assign the data based on address
                                if addr_counter < 4 then
                                    out_ciphera((31-addr_counter*8) downto (24-addr_counter*8)) <= data0;
                                elsif addr_counter < 8 then
                                    out_cipherb((31-(addr_counter-4)*8) downto (24-(addr_counter-4)*8)) <= data0;
                                elsif addr_counter < 12 then
                                    out_cipherc((31-(addr_counter-8)*8) downto (24-(addr_counter-8)*8)) <= data0;
                                else
                                    out_cipherd((31-(addr_counter-12)*8) downto (24-(addr_counter-12)*8)) <= data0;
                                end if;

                                addr_counter <= addr_counter + 1;  -- Increment address counter

                                -- Check if all 16 characters are processed
                                if addr_counter = 16 then
                                    cipher_complete <= '1';  -- Mark completion
                                    addr_counter <= 0;  -- Reset address counter
                                    r0 <= '0';  -- Disable read
                                else
                                    phase <= 0;  -- Continue fetching next address
                                end if;

                            when others =>
                                phase <= 0;  -- Default back to initial phase if necessary
                        end case;
                    elsif wt_read = '1' then
                        -- Similar logic for reading from blk_mem_gen_0 if necessary
                    end if;
                end if;  -- End of cipher complete check
            end if;  -- End of reading condition
        end if;  -- End of enabling signal
    end if;  -- End of rising edge condition
end process;

-- Debug output for monitoring phase and counter values





end behavioral;
