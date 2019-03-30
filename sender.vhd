-- Charles Owen
-- Embedded Systems
-- Lab 3
-- Sender

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity sender is
    Port(
    
    rst     : in std_logic;
    clk     : in std_logic;
    en      : in std_logic;
    btn     : in std_logic;
    rdy     : in std_logic;
    send    : out std_logic;
    char    : out std_logic_vector(7 downto 0)
    
    );
end sender;

architecture Behavioral of sender is

type id_array is array(0 to 4) of
    std_logic_vector(7 downto 0);
    
-- Initialize to clo64 in ASCII    
signal NETID    : id_array := ("01100011", "01101100", "01101111", "00110110",
                                "00110100");
                                
 -- Counter signal                               
signal i        : std_logic_vector(4 downto 0) := (others => '0');

-- Enumerated types for FSM
-- Present State init to idle
type state_type is (idle, busyA, busyB, busyC);
signal PS      : state_type := idle;
signal NS      : state_type;

begin

single_process: process(clk)
                begin
                
                if(rising_edge(clk)) then
                
                if(rst = '1') then
                
                PS <= idle;
                i <= (others => '0');
                char <= (others => '0');
                
                
                end if;
                
                if(en = '1') then
                
                case PS is
                
                when idle => send <= '0';  
                
                     PS <= idle;                 
                
                     if(rdy = '1') then
                     if(btn = '1') then
                     if(unsigned(i) < 5) then
                     
                      send <= '1';
                      char <= NETID(to_integer(unsigned(i)));              
                      i <= std_logic_vector(unsigned(i) + 1);
                      PS <= busyA;
                      
                     else i <= (others => '0');
                     
                     end if;                    
                     end if;
                     end if;
                     
                when busyA => 
                
                PS <= busyB;
                
                when busyB => send <= '0';
                
                PS <= busyC;
                
                when busyC => 
                
                PS <= busyC;
                
                if(rdy = '1') then
                if(btn = '0') then
                
                PS <= idle;
                
                end if;
                end if;
                
                when others => PS <= idle;
                
                end case;   
                
                end if;
                end if;
                end process;


end Behavioral;
