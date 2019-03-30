-- Charles Owen
-- Embedded Systems
-- Lab 3 
-- uart_tx

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity uart_tx is
       port(
       
       clk, en, send, rst   : in std_logic;
       char                 : in std_logic_vector(7 downto 0);
       ready, tx            : out std_logic := '1'
       
       );
end uart_tx;

architecture Behavioral of uart_tx is

type state_type is (st_ready, st_start, st_data);                    -- states of the state machine
signal d        : std_logic_vector(7 downto 0) := (others => '0');   -- character register
signal NS       : state_type;      
signal PS       : state_type := st_ready;                            -- state holder  
signal count    : std_logic_vector(3 downto 0);                      -- count data sent

begin

synch_p: process(clk, NS)
         begin      
         
         if(rising_edge(clk)) then
            
            PS <= NS; -- state transitions
           
         end if;
         
         end process;
         
comb_p: process (PS, clk, en, send, rst)

        begin
        
        if(rising_edge(clk)) then
        
           -- reset section    
           if(rst = '1') then 
            d <= (others => '0');
            NS <= st_ready;
           end if;       
        
        if(en = '1') then
        
        case (PS) is
        
        when st_ready => ready <= '1'; tx <= '1';
                       
            NS <= st_ready;    
            count <= (others => '0');  
            
            if(send = '1') then -- if send goes high we begin state transitions
            
            NS <= st_start;
            d <= char;
            
            end if;
            
        when st_start => ready <= '0'; tx <= '0'; 
        
            NS <= st_data;
            
        when st_data => ready <= '0'; -- the sata send state
        
            if(unsigned(count) < 8) then -- repeats data send until contents of d complete
                        
            tx <= d(0);
            NS <= st_data;
            count <= std_logic_vector(unsigned(count) + 1);
            d <= std_logic_vector(shift_right(unsigned(d), 1));
            
            else
            
            NS <= st_ready; -- return to ready state
            tx <= '1';
            
            end if;
                
            
        when others => NS <= st_ready;      
            
        end case;     
        
        end if;
        end if;
            
        
        end process;        

end Behavioral;
