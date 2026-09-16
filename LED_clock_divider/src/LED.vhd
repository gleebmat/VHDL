--------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/10/2026 03:25:56 PM
-- Design Name: 
-- Module Name: LED - Behavioral
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

entity LED is
  port (
    clk : in std_logic;
    led : out std_logic
  );
end LED;

architecture Behavioral of LED is
  signal slow_signal : std_logic;
begin
  U1 : entity work.clock_divider
    port map
    (
      clk     => clk,
      clk_out => slow_signal
    );

  led <= slow_signal;

end Behavioral;