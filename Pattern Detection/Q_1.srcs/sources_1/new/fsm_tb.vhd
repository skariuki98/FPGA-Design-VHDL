----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/04/2022 10:12:48 AM
-- Design Name: 
-- Module Name: fsm_tb - arch
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
use ieee.std_logic_unsigned.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity fsm_tb is
--  Port ( );
end fsm_tb;

architecture arch of fsm_tb is
    signal clock, reset, din, din_valid, done : std_logic;
    signal count: std_logic_vector (7 downto 0);
    signal stream1: std_logic_vector (31 downto 0):= "11001010110100100110101010011101"; --expected result 4
    signal stream2: std_logic_vector (31 downto 0):= "11010010101100001111000110011101"; --expected result 2
    signal stream3: std_logic_vector (31 downto 0):= "10010010010010010010010010010010"; --expected result 10
    
begin
    uut: entity work.fsm_pattern
        port map(clock=>clock, reset => reset, din=> din, din_valid =>din_valid, done=> done, count => count);
    
    --clock generator
   process 
   begin
      clock <= '0';
      wait for 1 ns;
      clock <= '1';
      wait for 1 ns;
   end process;

   ---test 1
   process
   begin
   reset <= '1';
   wait for 2 ns;
   reset <= '0';
   din_valid <= '1';
   --test 1
    for i in 31 downto 0 loop
        din <= stream1(i);
        wait for 2 ns;
    end loop;
    
    din_valid <= '0';
    wait for 5ns;
    
    --test 2
    reset <= '1';
    wait for 2 ns;
    reset <= '0';
    din_valid <= '1';
    
    for i in 31 downto 0 loop
        din <= stream2(i);
        wait for 2 ns;
    end loop;
    
   din_valid <= '0'; 
   wait for 5 ns;
   
   --test 3 
   reset <= '1';
    wait for 2 ns;
    reset <= '0';
    din_valid <= '1';
    
    for i in 31 downto 0 loop
        din <= stream3(i);
        wait for 2 ns;
    end loop; 
    
   end process;
end arch;
