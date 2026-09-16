----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/11/2026 03:54:28 PM
-- Design Name: 
-- Module Name: button_sync - Behavioral
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

entity button_sync is
  port (
    clk         : in std_logic;
    raw_button  : in std_logic;
    sync_button : out std_logic
  );
end button_sync;

architecture Behavioral of button_sync is
  signal sync_0, sync_1 : std_logic := '0';
begin
  process (clk)
  begin
    if rising_edge(clk) then
      sync_0 <= raw_button;
      sync_1 <= sync_0;
    end if;
  end process;

  sync_button <= sync_1;
end Behavioral;
