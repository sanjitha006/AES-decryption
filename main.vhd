----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08.11.2024 22:40:16
-- Design Name: 
-- Module Name: main - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity main is
    Port (
        clk : inout STD_LOGIC;
        
        seg_out:out STD_LOGIC_VECTOR(6 downto 0);
        anode_f: out STD_LOGIC_vector(3 downto 0)
        
        
         );
end main;

architecture Behavioral of main is


    component fsm
        Port ( 
    Done1 : inout STD_LOGIC;
        Done2 : inout STD_LOGIC;
        Done3 : inout STD_LOGIC;
        Done4 : inout STD_LOGIC;
        Done5 : inout STD_LOGIC;
        Done6 :inout STD_LOGIC;
        Done7 : inout STD_LOGIC;
        Done8 : inout STD_LOGIC;
        Done9 : inout STD_LOGIC;
        Done10 : inout STD_LOGIC;
        
        clk_f : in STD_LOGIC;
      
        
        en1 : out std_logic;
        en2 : out std_logic;
        en3 : out std_logic;
        en4 : out std_logic;
        en5 : out std_logic;
        en6 : out std_logic;
        en7 : out std_logic;
        en8 : out std_logic;
        en9 : out std_logic;
        en10 : out std_logic;
       
        wt_write4a:in std_logic_vector(31 downto 0);  ---whatever to write from 4
        wt_write4b:in std_logic_vector(31 downto 0);
        wt_write4c:in std_logic_vector(31 downto 0);
        wt_write4d:in std_logic_vector(31 downto 0);
   
        wt_write8a:in std_logic_vector(31 downto 0); 
        wt_write8b:in std_logic_vector(31 downto 0);
        wt_write8c:in std_logic_vector(31 downto 0);
        wt_write8d:in std_logic_vector(31 downto 0);
        
        wt_write9a:in std_logic_vector(31 downto 0);
        wt_write9b:in std_logic_vector(31 downto 0);
        wt_write9c:in std_logic_vector(31 downto 0);
        wt_write9d:in std_logic_vector(31 downto 0);
        
        wt_writeouta:out std_logic_vector(31 downto 0); --to the register
        wt_writeoutb:out std_logic_vector(31 downto 0);
        wt_writeoutc:out std_logic_vector(31 downto 0);
        wt_writeoutd:out std_logic_vector(31 downto 0);
        
        
        wt_read2a:out std_logic_vector(31 downto 0);-- to the xors
        wt_read2b:out std_logic_vector(31 downto 0);
        wt_read2c:out std_logic_vector(31 downto 0);
        wt_read2d:out std_logic_vector(31 downto 0);        
        wt_read2ak:out std_logic_vector(31 downto 0);
        wt_read2bk:out std_logic_vector(31 downto 0);
        wt_read2ck:out std_logic_vector(31 downto 0);
        wt_read2dk:out std_logic_vector(31 downto 0);
        
        wt_read5a:out std_logic_vector(31 downto 0);
        wt_read5b:out std_logic_vector(31 downto 0);
        wt_read5c:out std_logic_vector(31 downto 0);
        wt_read5d:out std_logic_vector(31 downto 0);
        wt_read5ak:out std_logic_vector(31 downto 0);
        wt_read5bk:out std_logic_vector(31 downto 0);
        wt_read5ck:out std_logic_vector(31 downto 0);
        wt_read5dk:out std_logic_vector(31 downto 0);
        
        
        wt_read9a:out std_logic_vector(31 downto 0);
        wt_read9b:out std_logic_vector(31 downto 0);
        wt_read9c:out std_logic_vector(31 downto 0);
        wt_read9d:out std_logic_vector(31 downto 0);
        wt_read9ak:out std_logic_vector(31 downto 0);
        wt_read9bk:out std_logic_vector(31 downto 0);
        wt_read9ck:out std_logic_vector(31 downto 0);
        wt_read9dk:out std_logic_vector(31 downto 0);
        
        wt_reada:in std_logic_vector(31 downto 0);  --from register to be sent to xors
        wt_readb:in std_logic_vector(31 downto 0);
        wt_readc:in std_logic_vector(31 downto 0);
        wt_readd:in std_logic_vector(31 downto 0);
        wt_readak:in std_logic_vector(31 downto 0);
        wt_readbk:in std_logic_vector(31 downto 0);
        wt_readck:in std_logic_vector(31 downto 0);
        wt_readdk:in std_logic_vector(31 downto 0);
        
        reading:out std_logic;
        writing:out std_logic;
        addr_read1:out integer;
        addr_read2:out integer;
        addr_write:out integer;
        where_read:out std_logic
         --can be increased also , now assuming not more than 5 times 128 bits will be given 
        --display bock after all are done , that is after  global counter reaching 'count' , s10 reached and happpens forever as it always gives don10 =0.
        
   
    
); 
    end component;
    component register_mem
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
    end component;
    
    component xor1  --done
        port( 
        
          key2a: in std_logic_vector(31 downto 0);
          key2b: in std_logic_vector(31 downto 0);
          key2c: in std_logic_vector(31 downto 0);
          key2d: in std_logic_vector(31 downto 0);
          s2ina: in std_logic_vector(31 downto 0);
          s2inb:in std_logic_vector(31 downto 0);
          s2inc:in std_logic_vector(31 downto 0);
          s2ind:in std_logic_vector(31 downto 0);
          s2outa: out std_logic_vector(31 downto 0);
          s2outb: out std_logic_vector(31 downto 0);
          s2outc: out std_logic_vector(31 downto 0);
          s2outd: out std_logic_vector(31 downto 0);
          en2:in std_logic;
          Done2:out std_logic
          );
    end component; 
    
    component invshiftrows  --done
        Port( 
          s3ina: in std_logic_vector(31 downto 0);
          s3inb:in std_logic_vector(31 downto 0);
          s3inc:in std_logic_vector(31 downto 0);
          s3ind:in std_logic_vector(31 downto 0);
          s3outa: out std_logic_vector(31 downto 0);
          s3outb: out std_logic_vector(31 downto 0);
          s3outc: out std_logic_vector(31 downto 0);
          s3outd: out std_logic_vector(31 downto 0);
          en3:in std_logic;
          Done3:out std_logic
          );
        
    end component;
    
    component sub_byte1
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
    end component;
    
    
    
    component xor2  --done
        port( 
        
          key5a: in std_logic_vector(31 downto 0);
          key5b: in std_logic_vector(31 downto 0);
          key5c: in std_logic_vector(31 downto 0);
          key5d: in std_logic_vector(31 downto 0);
          s5ina: in std_logic_vector(31 downto 0);
          s5inb:in std_logic_vector(31 downto 0);
          s5inc:in std_logic_vector(31 downto 0);
          s5ind:in std_logic_vector(31 downto 0);
          s5outa: out std_logic_vector(31 downto 0);
          s5outb: out std_logic_vector(31 downto 0);
          s5outc: out std_logic_vector(31 downto 0);
          s5outd: out std_logic_vector(31 downto 0);
          en5:in std_logic;
          Done5:out std_logic
          );
    end component;
    
    component invmixcolumns  --done
        port(
        data1in : in std_logic_vector(31 downto 0);
        data2in : in std_logic_vector(31 downto 0);
        data3in : in std_logic_vector(31 downto 0);
        data4in : in std_logic_vector(31 downto 0);
        en6 : in std_logic;
       
        data1out : out std_logic_vector(31 downto 0);
        data2out : out std_logic_vector(31 downto 0);
        data3out : out std_logic_vector(31 downto 0);
        data4out : out std_logic_vector(31 downto 0);
        Done6 : out std_logic
    );
    end component;
    
    component invshiftrows2   --done
        Port( 
          s7ina: in std_logic_vector(31 downto 0);
          s7inb:in std_logic_vector(31 downto 0);
          s7inc:in std_logic_vector(31 downto 0);
          s7ind:in std_logic_vector(31 downto 0);
          s7outa: out std_logic_vector(31 downto 0);
          s7outb: out std_logic_vector(31 downto 0);
          s7outc: out std_logic_vector(31 downto 0);
          s7outd: out std_logic_vector(31 downto 0);
          en7:in std_logic;
          Done7:out std_logic
          );
        
    end component;
    
    
    component sub_byte2
        Port (
        clock_s8       : in  std_logic; 

        
        s8ina: in std_logic_vector(31 downto 0);
        s8inb: in std_logic_vector(31 downto 0);
        s8inc: in std_logic_vector(31 downto 0);
        s8ind: in std_logic_vector(31 downto 0);
        s8outa: out std_logic_vector(31 downto 0);
        s8outb: out std_logic_vector(31 downto 0);
        s8outc: out std_logic_vector(31 downto 0);
        s8outd: out std_logic_vector(31 downto 0);
        en8: in std_logic;
        Done8: out std_logic
        );
    end component;
    
    component xor3   --done
        port( 
        
          key9a: in std_logic_vector(31 downto 0);
          key9b: in std_logic_vector(31 downto 0);
          key9c: in std_logic_vector(31 downto 0);
          key9d: in std_logic_vector(31 downto 0);
          s9ina: in std_logic_vector(31 downto 0);
          s9inb:in std_logic_vector(31 downto 0);
          s9inc:in std_logic_vector(31 downto 0);
          s9ind:in std_logic_vector(31 downto 0);
          s9outa: out std_logic_vector(31 downto 0);
          s9outb: out std_logic_vector(31 downto 0);
          s9outc: out std_logic_vector(31 downto 0);
          s9outd: out std_logic_vector(31 downto 0);
          en9:in std_logic;
          Done9:out std_logic
          );
    end component;
    
    component top_level_entity is --done
    Port (
        clk_disp : in STD_LOGIC;
      
        anode : out STD_LOGIC_VECTOR(3 downto 0);
        seg:out STD_LOGIC_VECTOR(6 downto 0);
        en10:in std_logic;
        Done10:out std_logic
       
    );
    end component;
    
    signal internal_addr_read1       : integer;
    signal internal_addr_read2       : integer;
    signal internal_addr_write       : integer;
    signal internal_reading          : std_logic;
    signal internal_writing          : std_logic;
    signal internal_where_read       : std_logic;
    
    signal internal_wt_writeouta     : std_logic_vector(31 downto 0);
    signal internal_wt_writeoutb     : std_logic_vector(31 downto 0);
    signal internal_wt_writeoutc     : std_logic_vector(31 downto 0);
    signal internal_wt_writeoutd     : std_logic_vector(31 downto 0);
    signal internal_out_ciphera      : std_logic_vector(31 downto 0);
    signal internal_out_cipherb      : std_logic_vector(31 downto 0);
    signal internal_out_cipherc      : std_logic_vector(31 downto 0);
    signal internal_out_cipherd      : std_logic_vector(31 downto 0);
    signal internal_out_keya         : std_logic_vector(31 downto 0);
    signal internal_out_keyb         : std_logic_vector(31 downto 0);
    signal internal_out_keyc         : std_logic_vector(31 downto 0);
    signal internal_out_keyd         : std_logic_vector(31 downto 0);
    signal s2outa_int, s2outb_int, s2outc_int, s2outd_int: std_logic_vector(31 downto 0);
    signal s4ina_int, s4inb_int, s4inc_int, s4ind_int: std_logic_vector(31 downto 0);
    signal en1_int, en2_int, en3_int, en4_int, en5_int, en6_int, en7_int, en8_int, en9_int, en10_int : std_logic;
    signal Done1_int, Done2_int, Done3_int, Done4_int, Done5_int, Done6_int, Done7_int, Done8_int, Done9_int, Done10_int : std_logic;
    signal k5a, k5b, k5c, k5d, s5a, s5b, s5c, s5d,k9a,k9b,k9c,k9d : std_logic_vector(31 downto 0);

    signal a, b, c, d,aa,bb,cc,dd : std_logic_vector(31 downto 0);
    signal d1, d2, d3, d4,dd1,dd2,dd3,dd4 : std_logic_vector(31 downto 0);
    signal s8a : std_logic_vector(31 downto 0);
signal s8b,s7a : std_logic_vector(31 downto 0);
signal s8c,s7b : std_logic_vector(31 downto 0);
signal s8d,s7c : std_logic_vector(31 downto 0);
signal s9a,s7d : std_logic_vector(31 downto 0);
signal s9b : std_logic_vector(31 downto 0);
signal s9c : std_logic_vector(31 downto 0);
signal s9d : std_logic_vector(31 downto 0);
signal internal_read2a, internal_read2b, internal_read2c, internal_read2d, internal_read2ak, internal_read2bk, internal_read2ck, internal_read2dk : std_logic_vector(31 downto 0);

begin 
    DUT0: fsm port map (clk_f=>clk,addr_read1 => internal_addr_read1, addr_read2 => internal_addr_read2, addr_write => internal_addr_write,
     reading => internal_reading, writing => internal_writing, where_read => internal_where_read,
       wt_writeouta => internal_wt_writeouta, 
      wt_writeoutb => internal_wt_writeoutb, wt_writeoutc => internal_wt_writeoutc, wt_writeoutd => internal_wt_writeoutd,
       wt_reada => internal_out_ciphera, wt_readb => internal_out_cipherb, wt_readc => internal_out_cipherc, wt_readd => internal_out_cipherd,
        wt_readak => internal_out_keya, wt_readbk => internal_out_keyb, wt_readck => internal_out_keyc, wt_readdk => internal_out_keyd,
        en1 => en1_int, en2 => en2_int, en3 => en3_int, en4 => en4_int, en5 => en5_int, en6 => en6_int, en7 => en7_int, en8 => en8_int, en9 => en9_int, en10 => en10_int, 
Done1 => Done1_int, Done2 => Done2_int, Done3 => Done3_int, Done4 => Done4_int, Done5 => Done5_int, Done6 => Done6_int, Done7 => Done7_int, Done8 => Done8_int, Done9 => Done9_int, Done10 => Done10_int,

        wt_read2a => internal_read2a,wt_read2b => internal_read2b,wt_read2c => internal_read2c,wt_read2d => internal_read2d,
        wt_read2ak => internal_read2ak,wt_read2bk => internal_read2bk,wt_read2ck => internal_read2ck,wt_read2dk => internal_read2dk,
        wt_write4a => a, wt_write4b => b, wt_write4c => c, wt_write4d => d,
        wt_write8a => aa, wt_write8b => bb, wt_write8c => cc, wt_write8d => dd,
        wt_write9a => dd1, wt_write9b => dd2, wt_write9c => dd3, wt_write9d => dd4,
        wt_read5a => k5a, wt_read5b => k5b, wt_read5c => k5c, wt_read5d => k5d,
        wt_read5ak => s5a, wt_read5bk => s5b, wt_read5ck => s5c, wt_read5dk => s5d
        

        );

    DUT1: register_mem port map (clk_r=>clk,addr_read1 => internal_addr_read1, addr_read2 => internal_addr_read2, addr_write => internal_addr_write,
     reading => internal_reading, writing => internal_writing, wt_read => internal_where_read, en1 => en1_int, done1 =>done1_int,
      wt_writea => internal_wt_writeouta, wt_writeb => internal_wt_writeoutb, wt_writec => internal_wt_writeoutc, wt_writed => internal_wt_writeoutd,
       out_ciphera => internal_out_ciphera, out_cipherb => internal_out_cipherb, out_cipherc => internal_out_cipherc, out_cipherd => internal_out_cipherd,
        out_keya => internal_out_keya, out_keyb => internal_out_keyb, out_keyc => internal_out_keyc, out_keyd => internal_out_keyd);
    
    DUT5: xor1 port map (s2outa => s2outa_int,s2outb => s2outb_int,s2outc => s2outc_int,s2outd => s2outd_int,Done2 => Done2_int,en2 => en2_int,
    s2ina => internal_read2a, s2inb => internal_read2b, s2inc => internal_read2c, s2ind => internal_read2d, key2a => internal_read2ak, key2b => internal_read2bk, key2c => internal_read2ck, key2d => internal_read2dk);
    
    DUT2: invshiftrows port map (s3ina => s2outa_int,s3inb => s2outb_int,s3inc => s2outc_int,s3ind => s2outd_int,
        s3outa => s4ina_int,s3outb => s4inb_int,s3outc => s4inc_int,s3outd => s4ind_int,
        en3 => en3_int,Done3 => Done3_int);
    
    DUT3: sub_byte1 port map (clock_s4 =>clk,s4ina=> s4ina_int,s4inb=>s4inb_int,s4inc => s4inc_int,s4ind => s4ind_int,en4=>en4_int,Done4=>Done4_int,s4outa => a, s4outb => b, s4outc => c, s4outd => d);
    
    DUT4: xor2 port map (key5a => k5a, key5b => k5b, key5c => k5c, key5d => k5d,
        s5ina => s5a, s5inb => s5b, s5inc => s5c, s5ind => s5d,en5=>en5_int,Done5=>Done5_int,
        s5outa => d1, s5outb => d2, s5outc => d3, s5outd => d4);
    
    DUT6: invmixcolumns port map (data1in => d1, data2in => d2, data3in => d3, data4in => d4,en6 => en6_int,Done6 => Done6_int,
          data1out => s7a, data2out => s7b, data3out => s7c, data4out => s7d);
    
    DUT7: invshiftrows2 port map (s7outa=>s8a,s7outb=>s8b,s7outc=>s8c,s7outd=>s8d,s7ina => s7a, s7inb => s7b, s7inc => s7c, s7ind => s7d,
            en7=>en7_int,Done7=>Done7_int);
    
    DUT8:sub_byte2 port map(clock_s8=>clk,s8ina => s8a, s8inb => s8b, s8inc => s8c, s8ind => s8d,
                s8outa => aa, s8outb => bb, s8outc => cc, s8outd => dd,en8=>en8_int,Done8=>Done8_int);
    
    
    DUT9: xor3 port map (key9a => k9a, key9b => k9b, key9c => k9c, key9d => k9d,
        s9ina => s9a, s9inb => s9b, s9inc => s9c, s9ind => s9d,en9=>en9_int,Done9=>Done9_int,
        s9outa => dd1, s9outb => dd2, s9outc => dd3, s9outd => dd4);
    DUT10:top_level_entity port map(en10=>en10_int,Done10=>Done10_int,seg=>seg_out,anode=>anode_f,clk_disp=>clk);


process

begin

clk<='1';
wait for 5 ns;
clk<='0';
wait for 5 ns;
end process;

end Behavioral;
