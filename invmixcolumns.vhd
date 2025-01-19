

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity invmixcolumns is
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
end invmixcolumns;

architecture behavioral of invmixcolumns is
    function mulby2(datain : std_logic_vector(7 downto 0)) return std_logic_vector is
        variable input : std_logic_vector(7 downto 0);
        variable div   : std_logic_vector(7 downto 0);
    begin
        input := (datain(6 downto 0) & '0');
        div   := ("000" & datain(7) & datain(7) & '0' & datain(7) & datain(7));
        return input xor div;
    end function mulby2;
   
    function mulby4(datain : std_logic_vector(7 downto 0)) return std_logic_vector is
        variable four : std_logic_vector(7 downto 0);
    begin
        four := mulby2(datain);
        four := mulby2(four);
        return four;
    end function mulby4;
   
    function mulby8(datain : std_logic_vector(7 downto 0)) return std_logic_vector is
        variable eight : std_logic_vector(7 downto 0);
    begin
        eight := mulby4(datain);
        eight := mulby2(eight);
        return eight;
    end function mulby8;
   
    function mulbyob(datain : std_logic_vector(7 downto 0)) return std_logic_vector is
        variable ob : std_logic_vector(7 downto 0);
    begin
        ob := mulby8(datain) xor mulby2(datain) xor datain;
        return ob;
    end function mulbyob;
   
    function mulbyod(datain : std_logic_vector(7 downto 0)) return std_logic_vector is
        variable od : std_logic_vector(7 downto 0);
    begin
        od := mulby8(datain) xor mulby4(datain) xor datain;
        return od;
    end function mulbyod;
   
    function mulbyo9(datain : std_logic_vector(7 downto 0)) return std_logic_vector is
        variable o9 : std_logic_vector(7 downto 0);
    begin
        o9 := mulby8(datain) xor datain;
        return o9;
    end function mulbyo9;
   
    function mulbyoe(datain : std_logic_vector(7 downto 0)) return std_logic_vector is
        variable oe : std_logic_vector(7 downto 0);
    begin
        oe := mulby8(datain) xor mulby4(datain) xor mulby2(datain);
        return oe;
    end function mulbyoe;

begin
    process(en6)
    begin
        if en6 = '1' then
           

         
            data4out(7 downto 0) <= mulbyob(data1in(7 downto 0)) xor mulbyod(data2in(7 downto 0)) xor mulbyo9(data3in(7 downto 0)) xor mulbyoe(data4in(7 downto 0));
            data4out(15 downto 8) <= mulbyob(data1in(15 downto 8)) xor mulbyod(data2in(15 downto 8)) xor mulbyo9(data3in(15 downto 8)) xor mulbyoe(data4in(15 downto 8));
            data4out(23 downto 16) <= mulbyob(data1in(23 downto 16)) xor mulbyod(data2in(23 downto 16)) xor mulbyo9(data3in(23 downto 16)) xor mulbyoe(data4in(23 downto 16));
            data4out(31 downto 24) <= mulbyob(data1in(31 downto 24)) xor mulbyod(data2in(31 downto 24)) xor mulbyo9(data3in(31 downto 24)) xor mulbyoe(data4in(31 downto 24));

         
            data3out(7 downto 0) <= mulbyod(data1in(7 downto 0)) xor mulbyo9(data2in(7 downto 0)) xor mulbyoe(data3in(7 downto 0)) xor mulbyob(data4in(7 downto 0));
            data3out(15 downto 8) <= mulbyod(data1in(15 downto 8)) xor mulbyo9(data2in(15 downto 8)) xor mulbyoe(data3in(15 downto 8)) xor mulbyob(data4in(15 downto 8));
            data3out(23 downto 16) <= mulbyod(data1in(23 downto 16)) xor mulbyo9(data2in(23 downto 16)) xor mulbyoe(data3in(23 downto 16)) xor mulbyob(data4in(23 downto 16));
            data3out(31 downto 24) <= mulbyod(data1in(31 downto 24)) xor mulbyo9(data2in(31 downto 24)) xor mulbyoe(data3in(31 downto 24)) xor mulbyob(data4in(31 downto 24));

         
            data2out(7 downto 0) <= mulbyo9(data1in(7 downto 0)) xor mulbyoe(data2in(7 downto 0)) xor mulbyob(data3in(7 downto 0)) xor mulbyod(data4in(7 downto 0));
            data2out(15 downto 8) <= mulbyo9(data1in(15 downto 8)) xor mulbyoe(data2in(15 downto 8)) xor mulbyob(data3in(15 downto 8)) xor mulbyod(data4in(15 downto 8));
            data2out(23 downto 16) <= mulbyo9(data1in(23 downto 16)) xor mulbyoe(data2in(23 downto 16)) xor mulbyob(data3in(23 downto 16)) xor mulbyod(data4in(23 downto 16));
            data2out(31 downto 24) <= mulbyo9(data1in(31 downto 24)) xor mulbyoe(data2in(31 downto 24)) xor mulbyob(data3in(31 downto 24)) xor mulbyod(data4in(31 downto 24));

         
            data1out(7 downto 0) <= mulbyoe(data1in(7 downto 0)) xor mulbyob(data2in(7 downto 0)) xor mulbyod(data3in(7 downto 0)) xor mulbyo9(data4in(7 downto 0));
            data1out(15 downto 8) <= mulbyoe(data1in(15 downto 8)) xor mulbyob(data2in(15 downto 8)) xor mulbyod(data3in(15 downto 8)) xor mulbyo9(data4in(15 downto 8));
            data1out(23 downto 16) <= mulbyoe(data1in(23 downto 16)) xor mulbyob(data2in(23 downto 16)) xor mulbyod(data3in(23 downto 16)) xor mulbyo9(data4in(23 downto 16));
            data1out(31 downto 24) <= mulbyoe(data1in(31 downto 24)) xor mulbyob(data2in(31 downto 24)) xor mulbyod(data3in(31 downto 24)) xor mulbyo9(data4in(31 downto 24));

            Done6<= '1';
        end if;
    end process;
end behavioral;