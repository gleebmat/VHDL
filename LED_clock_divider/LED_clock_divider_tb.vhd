library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity LED_clock_divider_tb is
end LED_clock_divider_tb;

architecture bench of LED_clock_divider_tb is
  constant clk_period : time := 10 ns;

  signal clk : std_logic := '0';
  signal led : std_logic;
begin

  -- Instantiate the LED top module
  UUT : entity work.LED
    port map
    (
      clk => clk,
      led => led
    );

  -- Clock generation
  clk_process : process
  begin
    clk <= '0';
    wait for clk_period/2;
    clk <= '1';
    wait for clk_period/2;
  end process;

  -- Simulation end
  stim_process : process
  begin
    wait;

  end process;

end bench;
