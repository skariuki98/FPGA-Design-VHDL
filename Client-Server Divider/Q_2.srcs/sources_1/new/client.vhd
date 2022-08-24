----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/07/2022 12:53:43 PM
-- Design Name: 
-- Module Name: client - beh
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
use ieee.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity client is
  Port (clock, reset, done, ready, error : in std_logic;
        d_valid: inout std_logic;
        ack : out std_logic;
        data: in std_logic_vector(7 downto 0);
        dvd, dvs: out std_logic_vector(7 downto 0);
        qnt: out std_logic_vector(7 downto 0);
        rmd: out std_logic_vector(7 downto 0);
        result: in std_logic_vector(7 downto 0)
        
        );
end client;

architecture beh of client is
    type state_type is (S0, S1, S2, S3, S4);
    signal cstate : state_type;
    
begin
process(clock, reset) begin

    if rising_edge(clock) then
        if reset = '1' then
            --set default values
            d_valid <= '0';
            ack <= '0'; 
            cstate <= S0;
        else 
            case cstate is
                --data validation state
                when S0=>
                    if ready = '1' and d_valid = '1'then
                        dvd <= data;
                        --d_valid <= '1';
                        cstate <= S1 ;
                    else cstate <= S0;
                    end if;
                --sending dividend  
                when S1=>
                    
                    d_valid <= '0';
                    cstate <= S2;
                --sending divisor
                when S2=>
                if ready = '1' and d_valid = '1'then    
                    dvs <= data;
                    --d_valid <= '1';
                    end if;
                if ready = '0' then
                    --data has been received
                    d_valid <= '0';
                    cstate <= S3;
                    end if;
                --receive qnt remainder
                when S3=>
                    if done = '1' then
                        qnt <= result;
                        ack <= '1';
                        cstate <= S4;
                    else
                        cstate <= S3;
                    end if;
                --receive remainder
                when s4=>
                    if done = '1' then
                        rmd <= result;
                        ack <= '0';
                        
                    else
                        cstate <= S4;
                    end if;
                   
            end case;    
  
        end if;
    end if;
end process;

end beh;
