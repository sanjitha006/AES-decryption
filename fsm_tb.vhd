library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity fsm_tb is
end fsm_tb;

architecture behavior of fsm_tb is

    -- Component Declaration for the Unit Under Test (UUT)
    component fsm
        Port ( 
            Done1, Done2, Done3, Done4, Done5, Done6, Done7, Done8, Done9, Done10 : inout STD_LOGIC;
            clk_f : in STD_LOGIC;
            en1, en2, en3, en4, en5, en6, en7, en8, en9, en10 : out std_logic;
            wt_write4a, wt_write4b, wt_write4c, wt_write4d : in std_logic_vector(31 downto 0);
            wt_write8a, wt_write8b, wt_write8c, wt_write8d : in std_logic_vector(31 downto 0);
            wt_write9a, wt_write9b, wt_write9c, wt_write9d : in std_logic_vector(31 downto 0);
            wt_writeouta, wt_writeoutb, wt_writeoutc, wt_writeoutd : out std_logic_vector(31 downto 0);
            wt_read2a, wt_read2b, wt_read2c, wt_read2d : out std_logic_vector(31 downto 0);
            wt_read2ak, wt_read2bk, wt_read2ck, wt_read2dk : out std_logic_vector(31 downto 0);
            wt_read5a, wt_read5b, wt_read5c, wt_read5d : out std_logic_vector(31 downto 0);
            wt_read5ak, wt_read5bk, wt_read5ck, wt_read5dk : out std_logic_vector(31 downto 0);
            wt_read9a, wt_read9b, wt_read9c, wt_read9d : out std_logic_vector(31 downto 0);
            wt_read9ak, wt_read9bk, wt_read9ck, wt_read9dk : out std_logic_vector(31 downto 0);
            wt_reada, wt_readb, wt_readc, wt_readd : in std_logic_vector(31 downto 0);
            wt_readak, wt_readbk, wt_readck, wt_readdk : in std_logic_vector(31 downto 0);
            reading, writing : out std_logic;
            addr_read1, addr_read2, addr_write : out integer;
            where_read : out std_logic
        );
    end component;
    
    -- Signals to connect to the UUT
    signal clk_f : std_logic := '0';
    signal reset_f : std_logic := '1';
    signal Done1, Done2, Done3, Done4, Done5, Done6, Done7, Done8, Done9, Done10 : std_logic := '0';

    signal en1, en2, en3, en4, en5, en6, en7, en8, en9, en10 : std_logic;
    signal wt_write4a, wt_write4b, wt_write4c, wt_write4d : std_logic_vector(31 downto 0) := (others => '0');
    signal wt_write8a, wt_write8b, wt_write8c, wt_write8d : std_logic_vector(31 downto 0) := (others => '0');
    signal wt_write9a, wt_write9b, wt_write9c, wt_write9d : std_logic_vector(31 downto 0) := (others => '0');
    signal wt_writeouta, wt_writeoutb, wt_writeoutc, wt_writeoutd : std_logic_vector(31 downto 0);
    signal wt_read2a, wt_read2b, wt_read2c, wt_read2d : std_logic_vector(31 downto 0);
    signal wt_read2ak, wt_read2bk, wt_read2ck, wt_read2dk : std_logic_vector(31 downto 0);
    signal wt_read5a, wt_read5b, wt_read5c, wt_read5d : std_logic_vector(31 downto 0);
    signal wt_read5ak, wt_read5bk, wt_read5ck, wt_read5dk : std_logic_vector(31 downto 0);
    signal wt_read9a, wt_read9b, wt_read9c, wt_read9d : std_logic_vector(31 downto 0);
    signal wt_read9ak, wt_read9bk, wt_read9ck, wt_read9dk : std_logic_vector(31 downto 0);
    signal wt_reada, wt_readb, wt_readc, wt_readd : std_logic_vector(31 downto 0) := (others => '1');
    signal wt_readak, wt_readbk, wt_readck, wt_readdk : std_logic_vector(31 downto 0) := (others => '1');
    signal reading, writing : std_logic;
    signal addr_read1, addr_read2, addr_write : integer := 0;
    signal where_read : std_logic;

begin
    -- Instantiate the Unit Under Test (UUT)
    uut: fsm Port map (
        Done1 => Done1, Done2 => Done2, Done3 => Done3, Done4 => Done4, Done5 => Done5, Done6 => Done6,
        Done7 => Done7, Done8 => Done8, Done9 => Done9, Done10 => Done10,
        clk_f => clk_f,
        en1 => en1, en2 => en2, en3 => en3, en4 => en4, en5 => en5, en6 => en6, en7 => en7, en8 => en8, en9 => en9, en10 => en10,
        wt_write4a => wt_write4a, wt_write4b => wt_write4b, wt_write4c => wt_write4c, wt_write4d => wt_write4d,
        wt_write8a => wt_write8a, wt_write8b => wt_write8b, wt_write8c => wt_write8c, wt_write8d => wt_write8d,
        wt_write9a => wt_write9a, wt_write9b => wt_write9b, wt_write9c => wt_write9c, wt_write9d => wt_write9d,
        wt_writeouta => wt_writeouta, wt_writeoutb => wt_writeoutb, wt_writeoutc => wt_writeoutc, wt_writeoutd => wt_writeoutd,
        wt_read2a => wt_read2a, wt_read2b => wt_read2b, wt_read2c => wt_read2c, wt_read2d => wt_read2d,
        wt_read2ak => wt_read2ak, wt_read2bk => wt_read2bk, wt_read2ck => wt_read2ck, wt_read2dk => wt_read2dk,
        wt_read5a => wt_read5a, wt_read5b => wt_read5b, wt_read5c => wt_read5c, wt_read5d => wt_read5d,
        wt_read5ak => wt_read5ak, wt_read5bk => wt_read5bk, wt_read5ck => wt_read5ck, wt_read5dk => wt_read5dk,
        wt_read9a => wt_read9a, wt_read9b => wt_read9b, wt_read9c => wt_read9c, wt_read9d => wt_read9d,
        wt_read9ak => wt_read9ak, wt_read9bk => wt_read9bk, wt_read9ck => wt_read9ck, wt_read9dk => wt_read9dk,
        wt_reada => wt_reada, wt_readb => wt_readb, wt_readc => wt_readc, wt_readd => wt_readd,
        wt_readak => wt_readak, wt_readbk => wt_readbk, wt_readck => wt_readck, wt_readdk => wt_readdk,
        reading => reading, writing => writing,
        addr_read1 => addr_read1, addr_read2 => addr_read2, addr_write => addr_write,
        where_read => where_read
    );

    -- Clock process definitions
    clk_process :process
    begin
        clk_f <= '0';
        wait for 10 ns;
        clk_f <= '1';
        wait for 10 ns;
    end process;

    -- Stimulus process
    stim_proc: process
    begin
        -- Initialize Inputs
        reset_f <= '1';
        Done1 <= '0'; Done2 <= '0'; Done3 <= '0'; Done4 <= '0'; Done5 <= '0'; Done6 <= '0'; Done7 <= '0'; Done8 <= '0'; Done9 <= '0'; Done10 <= '0';
        
        wait for 20 ns;
        reset_f <= '0';  -- Release reset after 20 ns
        wait for 80 ns;
        -- Apply stimulus and observe outputs
        Done2 <= '1';
        wait for 80 ns;
        
        Done3 <= '1'; 
        wait for 80 ns;
        
        Done4 <= '1'; Done5 <= '1'; 
        wait for 80 ns;

        -- Continue with other stimulus patterns as needed for FSM testing

        wait;
    end process;

end behavior;
