----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/12/2026 02:38:34 PM
-- Design Name: 
-- Module Name: segment_top - Behavioral
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

entity segment_top is
  port (
    hex : in std_logic_vector(3 downto 0);
    seg : out std_logic_vector(6 downto 0);
    an  : out std_logic_vector(3 downto 0)
  );
end segment_top;

architecture Behavioral of segment_top is
begin
  Hex_to_segments_inst : entity work.hex_to_segments
    port map
    (
      hex => hex,
      seg => seg
    );
  an <= "1110";
end Behavioral;
