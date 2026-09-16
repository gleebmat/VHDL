----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/11/2026 04:05:41 PM
-- Design Name: 
-- Module Name: button_debouncer - Behavioral
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
use IEEE.NUMERIC_STD.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity button_debouncer is
  generic (
    DEBOUNCE_TIME : unsigned(31 downto 0) := to_unsigned(500000, 32)
  );
  port (

    clk              : in std_logic;
    sync_button      : in std_logic  := '0';
    debounced_button : out std_logic := '0';
    reset            : in std_logic  := '0'

  );
end button_debouncer;

architecture Behavioral of button_debouncer is
  signal counter      : unsigned(31 downto 0) := (others => '0');
  signal stable_state : std_logic             := '0';
begin
  process (clk, reset)
  begin
    if reset = '1' then
      counter      <= (others => '0');
      stable_state <= '0';
    elsif rising_edge (clk) then
      if sync_button = stable_state then
        counter <= (others => '0');
      else
        if counter < DEBOUNCE_TIME - 1 then
          counter <= counter + 1;
        else
          stable_state <= sync_button;
          counter      <= (others => '0');
        end if;
      end if;

    end if;
  end process;
  debounced_button <= stable_state;
end Behavioral;
