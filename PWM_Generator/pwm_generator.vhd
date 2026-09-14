----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/14/2026 02:26:06 PM
-- Design Name: 
-- Module Name: pwm_generator - Behavioral
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
use ieee.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity pwm_generator is
  generic (
    BIT_LIMIT : positive := 8
  );
  port (
    clk        : in std_logic;
    reset      : in std_logic;
    duty_cycle : in unsigned(BIT_LIMIT - 1 downto 0);
    pwm_out    : out std_logic
  );
end pwm_generator;

architecture Behavioral of pwm_generator is
  signal counter : unsigned(BIT_LIMIT - 1 downto 0) := (others => '0');

begin
  process (clk, reset)
  begin
    if reset = '1' then
      counter <= (others => '0');
    elsif rising_edge(clk) then
      counter <= counter + 1;
    end if;

  end process;
  pwm_out <= '1' when duty_cycle = (duty_cycle'range => '1') else
    '1' when counter < duty_cycle else
    '0';
end Behavioral;
