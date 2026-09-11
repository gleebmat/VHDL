----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/11/2026 05:07:58 PM
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
    clk              : in std_logic;
    debounced_button : in std_logic;
    led              : out std_logic;
    reset            : in std_logic := '0'
  );
end LED;

architecture Behavioral of LED is
  signal led_state         : std_logic := '0';
  signal prev_button_state : std_logic := '0';
begin
  process (clk, reset)
  begin
    if reset = '1' then
      led_state         <= '0';
      prev_button_state <= '0';
    elsif rising_edge(clk) then
      if debounced_button = '1' and prev_button_state = '0' then
        led_state <= not led_state;
      end if;
      prev_button_state <= debounced_button;
    end if;
  end process;
  led <= led_state;
end Behavioral;
