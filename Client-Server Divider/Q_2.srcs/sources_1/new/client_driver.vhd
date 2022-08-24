----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/08/2022 08:02:04 PM
-- Design Name: 
-- Module Name: client_driver - Structural
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

entity client_driver is
--  Port ( );
end client_driver;

architecture Structural of client_driver is
    signal clock, reset, d_valid : std_logic ;
    signal data: std_logic_vector(7 downto 0);
    --ports signals - client
    --signal cack, cdata, cdvalid, cdone, cready, cerror : std_logic ;
    --signal cresult, cqnt, crmd : std_logic_vector(7 downto 0);
    --ports signals - server
    signal result, qnt, rmd, dvd, dvs : std_logic_vector(7 downto 0);
    signal done, error, ready, ack: std_logic;
    type state_type is (S0, S1, S2, S3, S4, S5);
    signal cstate : state_type;
    
begin
    
        
    uut : entity work.server(struct)
        port map(
                clock => clock,
                reset => reset,
                ack => ack,
                d_valid => d_valid,
                done => done,
                ready => ready,
                error => error,
                result => result,
                dvd =>dvd,
                dvs => dvs
                
                
        );
        

    --clock generator
   process 
   begin
      clock <= '0';
      wait for 2 ns;
      clock <= '1';
      wait for 2 ns;
   end process;
   
-- reset generator
   process
   begin
      reset <= '1';
      wait for 4 ns;
      reset <= '0';
      --wait for 2 ns;
      --reset <= '0';
      wait;
   end process;
   

        
process(clock) begin

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
                    data <= "00011000";
                    d_valid <= '1';
                    cstate <= S1;
                --sending dividend  
                when S1=>
                    if ready = '1'  and d_valid = '1' then
                        dvd <= data;
                        
                        
                    else cstate <= S0;
                    end if;
                    if error = '1' then
                        cstate <= S0;
                    else
                        d_valid <= '0';
                        cstate <= S2;
                    end if;
                --sending divisor
                when S2=>
                    if ready = '1'  then    
                        data <= "00000100";
                        d_valid <= '1';
                        cstate <= S3;
                    end if;
                    
                --receive qnt remainder
                when S3=>
                    if ready = '1' and d_valid = '1' then
                        dvs <= data;
                    end if;
                    if ready = '0' then
                        --data has been received
                        d_valid <= '0';
                        if done = '1' then
                            qnt <= result;
                            ack <= '1';
                            cstate <= S4;
                        else
                            cstate <= S3;
                        end if;
                    end if;
                    
                --receive remainder
                when s4=>
                    if done = '1' and qnt /= "UU" then
                        rmd <= result;
                        ack <= '1';
                        
                    else
                        cstate <= S4;
                    end if;
                when S5 =>
                    --if done = '1' then
                    ack <= '0';
                    --end if;
            end case;    
  
        end if;
    end if;
end process;



end Structural;
