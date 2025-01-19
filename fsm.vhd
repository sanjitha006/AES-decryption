


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

use ieee.numeric_std.all;

entity fsm is
  
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
       
end fsm;

architecture machine of fsm IS
   
    type state_type is (s1,s2,s3,s4,s5,s6,s7,s8,s9,s10);

    signal cur_state : state_type := s1;
    signal next_state : state_type := s1;
    signal roundnum : integer range 0 to 15 := 0;
    signal globalcounter:integer range 0 to 15 := 0;
    signal is_over:std_logic;
    signal read_or_transition:std_logic;
    signal nothing:std_logic:='0';
    signal count:integer range 0 to 5:=1;
    signal reset_f:std_logic:='1';
    
begin
--Sequential block



--Combinational block

process (clk_f,reset_f,cur_state,Done1,Done2,Done3,Done4,Done5,Done6,Done7,Done8,Done9,Done10)---check what to give instead of M 
variable initiate:std_logic:='1';
begin
if initiate='1' or rising_edge(reset_f) then 
    if (reset_f = '1') then
    cur_state <= s1;
    
    en1 <= '1';
    en2 <= '0';
    en3 <= '0';
    en4 <= '0';
    en5 <= '0';
    en6 <='0';
    en8 <= '0';
    en9 <= '0';
    en10<= '0';
    roundnum<=0;
    
    addr_read1 <=(globalcounter-1)*16;   ---addr_read is different for key and cipher for key always constant, keep another input addr_read-1
    
    addr_read2<=144;---last key
    
    reading <= '1';                        
    writing <= '0';                         
    where_read <= '1'; 
    reset_f<='0';      
  
       
    
    
    elsif (clk_f'EVENT AND clk_f = '1') then
    cur_state <= next_state;
    end if;
    end if;






   next_state <= cur_state;
   case cur_state is
    when s1 =>
        if Done1 = '1' and roundnum=0 then   --change all here
            Done1 <= '0'; Done2 <= '0'; Done3 <= '0'; Done4 <= '0'; Done5 <= '0'; Done6 <= '0'; Done7 <= '0'; Done8 <= '0'; Done9 <= '0'; Done10 <= '0';

            
            next_state <= s2;
            
            
            wt_read2a<=wt_reada;
            wt_read2b  <= wt_readb;
            wt_read2c  <= wt_readc;
            wt_read2d  <= wt_readd;
            wt_read2ak <= wt_readak;
            wt_read2bk <= wt_readbk;
            wt_read2ck <= wt_readck;
            wt_read2dk <= wt_readdk;
            en1<='0';en2<='1';en3<='0';en4<='0';en5<='0';en6<='0';en7<='0';en8<='0';en9<='0';en10<='0'; --also turn done off for all
     
        elsif Done1 = '1' and roundnum=9 then
            Done1 <= '0'; Done2 <= '0'; Done3 <= '0'; Done4 <= '0'; Done5 <= '0'; Done6 <= '0'; Done7 <= '0'; Done8 <= '0'; Done9 <= '0'; Done10 <= '0';

            if read_or_transition='0' then
            reading<='1';
            writing<='0';
            addr_read2<=roundnum*16;
            addr_read1<=(globalcounter-1)*16;
            where_read<='1';
            next_state <= s1;
            en1<='1';en2<='0';en3<='0';en4<='0';en5<='0';en6<='0';en7<='0';en8<='0';en9<='0';en10<='0';
            read_or_transition<='1';
            else
            if nothing ='1' then
                if globalcounter=count-1 then
                
                next_state<=s10;
                else
                reset_f<='1';
                end if;
                else
                   next_state <= s9;
                wt_read9a<=wt_reada;
                wt_read9b  <= wt_readb;
                wt_read9c  <= wt_readc;
                wt_read9d  <= wt_readd;
                wt_read9ak <= wt_readak;
                wt_read9bk <= wt_readbk;
                wt_read9ck <= wt_readck;
                wt_read9dk <= wt_readdk;
                en1<='1';en2<='0';en3<='0';en4<='0';en5<='0';en6<='0';en7<='0';en8<='0';en9<='1';en10<='0';
            
                end if;
        end if;
          elsif Done1 = '1' then
            
            Done1 <= '0'; Done2 <= '0'; Done3 <= '0'; Done4 <= '0'; Done5 <= '0'; Done6 <= '0'; Done7 <= '0'; Done8 <= '0'; Done9 <= '0'; Done10 <= '0';

            if read_or_transition='0' then
                reading<='1';
                writing<='0';
                addr_read2<=roundnum*16;
                addr_read1<=(globalcounter-1)*16;
                where_read<='1';
                next_state <= s1;
                en1<='1';en2<='0';en3<='0';en4<='0';en5<='0';en6<='0';en7<='0';en8<='0';en9<='0';en10<='0';
                read_or_transition<='1';
            
            else
                   next_state <= s9;
                wt_read5a<=wt_reada;
                wt_read5b  <= wt_readb;
                wt_read5c  <= wt_readc;
                wt_read5d  <= wt_readd;
                wt_read5ak <= wt_readak;
                wt_read5bk <= wt_readbk;
                wt_read5ck <= wt_readck;
                wt_read5dk <= wt_readdk;
                en1<='1';en2<='0';en3<='0';en4<='0';en5<='0';en6<='0';en7<='0';en8<='0';en9<='1';en10<='0';
            end if;
        elsif Done1 ='0' then 
            next_state<=s1;
            en1<='1';en2<='0';en3<='0';en4<='0';en5<='0';en6<='0';en7<='0';en8<='0';en9<='0';en10<='0';
        
        end if;
     
    
    when s2 =>
        if Done2 = '1' then
            Done2<='0';
            next_state <= s3;
            en1<='0';en2<='0';en3<='1';en4<='0';en5<='0';en6<='0';en7<='0';en8<='0';en9<='0';en10<='0';
        
        elsif Done2 ='0' then 
            next_state<=s2;
            en1<='0';en2<='1';en3<='0';en4<='0';en5<='0';en6<='0';en7<='0';en8<='0';en9<='0';en10<='0';
        
        end if;
        
        
    when s3 =>
        if Done3 = '1' then
            next_state <= s4;
            en1<='0';en2<='0';en3<='0';en4<='1';en5<='0';en6<='0';en7<='0';en8<='0';en9<='0';en10<='0';
        
        elsif Done3 ='0' then 
            next_state<=s3;
            en1<='0';en2<='0';en3<='1';en4<='0';en5<='0';en6<='0';en7<='0';en8<='0';en9<='0';en10<='0';
        
        end if;
        

    when s4 =>
        if Done4 = '1'  then
            Done4<='0';
            next_state <= s1;
            read_or_transition<='0';
            en1<='1';en2<='0';en3<='0';en4<='0';en5<='0';en6<='0';en7<='0';en8<='0';en9<='0';en10<='0';
            wt_writeouta <= wt_write4a;
            wt_writeoutb <= wt_write4b;
            wt_writeoutc <= wt_write4c;
            wt_writeoutd <= wt_write4d;


        writing<='1';
        reading<='0';
        addr_write<=(globalcounter-1)*16;
        
        elsif Done4 ='0' then 
            next_state<=s4;
            en1<='0';en2<='0';en3<='0';en4<='1';en5<='0';en6<='0';en7<='0';en8<='0';en9<='0';en10<='0';
        
        
        end if;
        
        
        
    when s5 =>
        if Done5 = '1' then
            Done5<='0';
            next_state <= s6;
            en1<='0';en2<='0';en3<='0';en4<='0';en5<='0';en6<='1';en7<='0';en8<='0';en9<='0';en10<='0';
    
        elsif Done5 ='0' then 
            next_state<=s5;
            en1<='0';en2<='0';en3<='0';en4<='0';en5<='1';en6<='0';en7<='0';en8<='0';en9<='0';en10<='0';
        
        
        end if;
     
    when s6=>
        if Done6 = '1' then
            Done6<='0';
            next_state <= s7;
            en1<='0';en2<='0';en3<='0';en4<='0';en5<='0';en6<='0';en7<='1';en8<='0';en9<='0';en10<='0';
        
        elsif Done6 = '0'  then
            next_state <= s6;
            en1<='0';en2<='0';en3<='0';en4<='0';en5<='0';en6<='1';en7<='0';en8<='0';en9<='0';en10<='0';
        
        end if;
        
    when s7=>
        if Done7 = '1' then
            Done7<='0';
            next_state <= s8;
            en1<='0';en2<='0';en3<='0';en4<='0';en5<='0';en6<='0';en7<='0';en8<='1';en9<='0';en10<='0';
        
        elsif Done7 = '0'  then
            next_state <= s7;
            en1<='0';en2<='0';en3<='0';en4<='0';en5<='0';en6<='0';en7<='1';en8<='0';en9<='0';en10<='0';
        
        end if;
    
    when s8=>
        if Done8 = '1' then
            Done8<='0';
            next_state <= s1;
            read_or_transition<='0';
            en1<='1';en2<='0';en3<='0';en4<='0';en5<='0';en6<='0';en7<='0';en8<='0';en9<='0';en10<='0';
            wt_writeouta <= wt_write8a;
            wt_writeoutb <= wt_write8b;
            wt_writeoutc <= wt_write8c;
            wt_writeoutd <= wt_write8d;
            roundnum<=roundnum+1;
            writing<='1';
            reading<='0';
            addr_write<=(globalcounter-1)*16;
        
       
        
        end if;
     when s9=>
        if Done9 = '1' then
            Done9<='0';
            next_state <= s1;
            read_or_transition<='1';
            nothing<='1';
            en1<='1';en2<='0';en3<='0';en4<='0';en5<='0';en6<='0';en7<='0';en8<='0';en9<='0';en10<='0';
            wt_writeouta <= wt_write9a;
            wt_writeoutb <= wt_write9b;
            wt_writeoutc <= wt_write9c;
            wt_writeoutd <= wt_write9d;
            roundnum<=roundnum+1;
            writing<='1';
            reading<='0';
            addr_write<=(globalcounter-1)*16;
            en1<='0';en2<='0';en3<='0';en4<='1';en5<='0';en6<='0';en7<='0';en8<='1';en9<='0';en10<='1';
        
        elsif Done9 = '0'  then
            
            next_state <= s9;
            en1<='0';en2<='0';en3<='0';en4<='0';en5<='0';en6<='0';en7<='0';en8<='0';en9<='1';en10<='0';
        
        end if;
    when others=>
       next_state<=cur_state;
            
    
end case;
end process;


end machine;
