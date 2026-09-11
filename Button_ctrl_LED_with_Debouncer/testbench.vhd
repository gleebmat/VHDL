library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity Top_level_module_tb is
end Top_level_module_tb;

architecture Behavioral of Top_level_module_tb is

  -- DUT ports
  signal clk        : std_logic := '0';
  signal raw_button : std_logic := '0';
  signal led        : std_logic;
  signal reset      : std_logic := '0';

  -- Clock period
  constant CLK_PERIOD : time := 10 ns; -- 100 MHz

begin

  DUT : entity work.Top_level_module
    port map
    (
      clk        => clk,
      raw_button => raw_button,
      led        => led,
      reset      => reset
    );

  clk_process : process
  begin
    clk <= '0';
    wait for CLK_PERIOD/2;
    clk <= '1';
    wait for CLK_PERIOD/2;
  end process;

  stim_proc : process
  begin

    reset <= '1';
    wait for 100 ns;
    reset <= '0';
    wait for 100 ns;

    raw_button <= '1';
    wait for 2 ms;
    raw_button <= '0';
    wait for 1 ms;
    raw_button <= '1';
    wait for 1 ms;
    raw_button <= '0';
    wait for 1 ms;
    raw_button <= '1';
    wait for 1 ms;
    raw_button <= '1';
    wait for 1 ms;
    raw_button <= '0';
    wait for 1 ms;
    raw_button <= '1';
    wait for 1 ms;
    raw_button <= '1';
    wait for 10 ms; -- stable press

    raw_button <= '0';
    wait for 2 ms;
    raw_button <= '1';
    wait for 1 ms;
    raw_button <= '0';
    wait for 1 ms;
    raw_button <= '1';
    wait for 1 ms;
    raw_button <= '0';
    wait for 10 ms; -- stable release

    raw_button <= '1';
    wait for 10 ms;
    raw_button <= '0';
    wait for 10 ms;

    wait;
  end process;

end Behavioral;
