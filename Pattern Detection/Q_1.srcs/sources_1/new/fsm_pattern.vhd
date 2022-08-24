----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/04/2022 08:56:17 AM
-- Design Name: 
-- Module Name: fsm_pattern - beh
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
use IEEE.numeric_std.ALL;


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity fsm_pattern is
  Port (clock : in std_logic;
        reset : in std_logic;
        din_valid : in std_logic;
        din : in std_logic;
        count : out std_logic_vector(7 downto 0);
        done : out std_logic
        );
end fsm_pattern;

architecture beh of fsm_pattern is
    type state_type is (S0, S1, S2, S3, S4);
    signal state: state_type;
    signal counter : unsigned(7 downto 0);
begin
    
    U_Moore: process(clock, reset)
    begin
        if rising_edge(clock) then
            if reset = '1' then
                state <= S0;
                done <= '0';
                counter <= (others=>'0');
            else
                if din_valid = '1' then
                    case state is
                        when S0 =>
                            counter <= counter;
                            if din = '1' then
                                state <= S1;
                            else 
                                state <= S0;
                            end if;
                        when S1 =>
                           counter <= counter;
                           if din = '1' then
                               state <= S1;
                           else 
                               state <= S2;
                           end if;
                        when S2 =>
                            counter <= counter;
                            if din = '1' then
                                state <= S1;
                            else 
                                state <= S3;
                            end if;
                        when S3 =>
                            counter <= counter;
                            if din = '1' then
                                state <= S4;
                            else 
                                state <= S0;
                            end if;
                        when S4 =>
                            counter <= counter + 1;
                            if din = '1' then
                                state <= S1;
                            else 
                                state <= S2;
                            end if;
                    end case;
                end if;
            end if;
        end if;
        if falling_edge(din_valid) and reset = '0' then 
                done <= '1';
        end if;
        
  
    end process;
    
    count <= std_logic_vector(counter);
    
end beh;
