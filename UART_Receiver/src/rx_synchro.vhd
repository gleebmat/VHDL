----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/18/2026 04:28:38 PM
-- Design Name: 
-- Module Name: rx_synchro - Behavioral
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

entity rx_synchro is
  port (
    rx       : in std_logic;
    reset    : in std_logic;
    clk      : in std_logic;
    final_rx : out std_logic
  );
end rx_synchro;

architecture Behavioral of rx_synchro is
  signal rx_sync_1 : std_logic := '1';
  signal rx_sync_2 : std_logic := '1';

begin

  process (clk, reset)
  begin
    if reset = '1' then
      rx_sync_1 <= '1';
      rx_sync_2 <= '1';
    elsif rising_edge(clk) then
      rx_sync_1 <= rx;
      rx_sync_2 <= rx_sync_1;
    end if;
  end process;
  final_rx <= rx_sync_2;
end Behavioral;
