----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/07/2022 12:52:49 PM
-- Design Name: 
-- Module Name: server - struct
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity server is
  Port (clock : in std_logic;
        reset, ack : in std_logic;
        ready, error: out std_logic;
        done  : out std_logic;
        d_valid: in std_logic;
        result:out std_logic_vector (7 downto 0);
        dvd, dvs: in std_logic_vector (7 downto 0)
        
        );
end server;

architecture struct of server is
    type state_type is (S0, S1, S2, S3, S4, S5, S6);
    signal state: state_type;
    signal done_holder, ready_holder: std_logic;
    signal start: std_logic;
    signal qnt, rmd:  std_logic_vector (7 downto 0);
begin
divider : entity work.div(arch)
    port map(
        clock => clock,
        start => start,
        reset => reset,
        dvsr => dvs,
        dvnd => dvd,
        ready => ready_holder,
        done_tick => done_holder,
        quo => qnt,
        rmd => rmd
    );
    
    
process(clock) begin

    if rising_edge(clock) then
        if reset = '1' then
            --reset to default values
            ready <= '1';
            done <= '0';
            start <= '0';
            
            state <= S0;
        else
            
            case state is
                --receive dividend state
                when S0=>
                    if d_valid = '1' then
                        
                        state <= S1 ;
                    else state <= S0;
                    end if;
                --receive divisor state, check dividend   
                when S1=>
                    
                    if dvd = "00000000" or dvd = "UU" then
                        error <= '1';
                        state <= S0;
                    else --receive divisor
                        state <= S2;
                    end if;
                --perform division and send quotient
                when S2=>
                    ready <= '0';
                    start <= '1';
                    --division happens
                    --send quotient
                    if done_holder = '1' then
                        state <= S3;
                    end if;
                    
                --confirm receipt
                when S3=>
                    if qnt = "UU" then
                        error <= '1';
                    else    
                        result <= qnt;
                        done <= '1';
                        state <= S4;
                    end if;
                    
                --send remainder
                when s4=>
                    if ack = '1' then
                        done <= '0';
                        state <= S5;
                    else
                        state <= S4; 
                    end if;
                   
                when S5=>
                    if qnt = "UU" then
                        error <= '1';
                    else
                        result <= rmd;
                        done <= '1';
                        state <= S6;  
                    end if;
                when S6=>
                    if ack = '1' then
                        done <= '0';
                        state <= S0;
                        
                    end if;
                   
            end case;    
  
        end if;
    end if;
end process;
end struct;