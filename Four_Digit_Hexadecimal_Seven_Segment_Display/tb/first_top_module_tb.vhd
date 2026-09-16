----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/12/2026 02:49:55 PM
-- Design Name: 
-- Module Name: top_module_tb - Behavioral
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
use IEEE.STD_LOGIC_1164.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top_module_tb is
  --  Port ( );
end top_module_tb;

architecture Behavioral of top_module_tb is
  signal hex : std_logic_vector(3 downto 0) := "0000";
  signal seg : std_logic_vector(6 downto 0);
  signal an  : std_logic_vector(3 downto 0);

begin
  Top_module_inst : entity work.segment_top
    port map
    (
      hex => hex,
      seg => seg,
      an  => an
    );
  stimulus : process
  begin

    hex <= "0000";
    wait for 10 ns; -- 0
    hex <= "0001";
    wait for 10 ns; -- 1
    hex <= "0010";
    wait for 10 ns; -- 2
    hex <= "0011";
    wait for 10 ns; -- 3
    hex <= "0100";
    wait for 10 ns; -- 4
    hex <= "0101";
    wait for 10 ns; -- 5
    hex <= "0110";
    wait for 10 ns; -- 6
    hex <= "0111";
    wait for 10 ns; -- 7
    hex <= "1000";
    wait for 10 ns; -- 8
    hex <= "1001";
    wait for 10 ns; -- 9
    hex <= "1010";
    wait for 10 ns; -- A
    hex <= "1011";
    wait for 10 ns; -- b
    hex <= "1100";
    wait for 10 ns; -- C
    hex <= "1101";
    wait for 10 ns; -- d
    hex <= "1110";
    wait for 10 ns; -- E
    hex <= "1111";
    wait for 10 ns; -- F

    wait;
  end process;
end Behavioral;
