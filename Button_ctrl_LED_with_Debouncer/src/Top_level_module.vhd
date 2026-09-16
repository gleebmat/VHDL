----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/11/2026 05:20:48 PM
-- Design Name: 
-- Module Name: Top_level_module - Behavioral
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

entity Top_level_module is
  port (
    clk        : in std_logic;
    raw_button : in std_logic;
    led        : out std_logic;
    reset      : in std_logic);
end Top_level_module;

architecture Behavioral of Top_level_module is
  signal sync_button      : std_logic;
  signal debounced_button : std_logic;
begin
  U_Sync : entity work.button_sync
    port map
    (
      clk         => clk,
      raw_button  => raw_button,
      sync_button => sync_button
    );
  U_Debouncer : entity work.button_debouncer
    port map
    (
      clk              => clk,
      sync_button      => sync_button,
      debounced_button => debounced_button,
      reset            => reset
    );
  U_LED : entity work.LED
    port map
    (
      clk              => clk,
      debounced_button => debounced_button,
      led              => led,
      reset            => reset
    );
end Behavioral;
