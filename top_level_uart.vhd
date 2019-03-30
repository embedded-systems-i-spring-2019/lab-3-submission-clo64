-- Charles Owen
-- Embedded Systems
-- Lab 3
-- Top Level UART

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity top_level_uart is
    Port(
    
    RTS             : out std_logic;
    RXD             : out std_logic;
    TXD             : in std_logic;
    CTS             : out std_logic;
    btn             : in std_logic_vector(1 downto 0);
    clk             : in std_logic         
    
    );
end top_level_uart;

architecture Behavioral of top_level_uart is

component clock_div is

Port (
        clk     : in std_logic; -- device common clock
        clk_out : out std_logic -- downsampled/divided output       
        
    );
    
end component;

component debounce_two is
        Port(
        btn, clk        : in std_logic;
        dbnc            : out std_logic
        
        );
end component;

component uart is
    port (

    clk, en, send, rx, rst      : in std_logic;
    charSend                    : in std_logic_vector (7 downto 0);
    ready, tx, newChar          : out std_logic;
    charRec                     : out std_logic_vector (7 downto 0)

);
end component;

component sender is
    Port(
    
    rst     : in std_logic;
    clk     : in std_logic;
    en      : in std_logic;
    btn     : in std_logic;
    rdy     : in std_logic;
    send    : out std_logic;
    char    : out std_logic_vector(7 downto 0)
    
    );
end component;

-- intermediate signals
signal debounce_init    : std_logic_vector(1 downto 0);
signal clk_div_init     : std_logic;
signal ready_init       : std_logic;
signal char_send        : std_logic_vector(7 downto 0);
signal send_init        : std_logic;
--signal newChar          : std_logic;


begin

RTS <= '0';
CTS <= '0';
--newChar <= '0';

button1: debounce_two

         port map (
         
         btn => btn(0),
         clk => clk,
         dbnc => debounce_init(0)
         
         );
         
button2: debounce_two

         port map (
         
         btn => btn(1),
         clk => clk,
         dbnc => debounce_init(1)
         
         );

clk_div: clock_div

         port map (
         
         clk => clk,
         clk_out => clk_div_init
         
         );
         
urt:    uart

        port map (
        
        clk => clk,
        en => clk_div_init,
        ready => ready_init,
        rst => debounce_init(0),
        charSend => char_send,
        rx => TXD,
        send => send_init,
        tx => RXD
        --newChar => newChar
        
        );
        
sendr:  sender

        port map (
        
        btn => debounce_init(1),
        clk => clk,
        en => clk_div_init,
        rdy => ready_init,
        rst => debounce_init(0),
        char => char_send,
        send => send_init
        
        );


end Behavioral;
