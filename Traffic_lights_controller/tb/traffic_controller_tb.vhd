
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Traffic_controller_tb is
end;

architecture bench of Traffic_controller_tb is
  -- Clock period
  constant clk_period : time := 10 ns;
  -- Generics
  constant GREEN_TIME             : positive := 12;
  constant YELLOW_TIME            : positive := 3;
  constant PEDESTRIAN_TIME        : positive := 7;
  constant WAIT_BEFORE_TRANSITION : positive := 2;
  constant BLINK_TIME             : positive := 5;
  constant BLINK_HALF_PERIOD      : positive := 1;
  -- Ports
  signal clk                : std_logic;
  signal reset              : std_logic;
  signal ns_green           : std_logic;
  signal ns_yellow          : std_logic;
  signal ns_red             : std_logic;
  signal ew_green           : std_logic;
  signal ew_yellow          : std_logic;
  signal ew_red             : std_logic;
  signal pedestrian_green   : std_logic;
  signal pedestrian_red     : std_logic;
  signal pedestrian_request : std_logic;
begin

  Traffic_controller_inst : entity work.Traffic_controller
    generic map(
      GREEN_TIME             => GREEN_TIME,
      YELLOW_TIME            => YELLOW_TIME,
      PEDESTRIAN_TIME        => PEDESTRIAN_TIME,
      WAIT_BEFORE_TRANSITION => WAIT_BEFORE_TRANSITION,
      BLINK_TIME             => BLINK_TIME,
      BLINK_HALF_PERIOD      => BLINK_HALF_PERIOD
    )
    port map
    (
      clk                => clk,
      reset              => reset,
      ns_green           => ns_green,
      ns_yellow          => ns_yellow,
      ns_red             => ns_red,
      ew_green           => ew_green,
      ew_yellow          => ew_yellow,
      ew_red             => ew_red,
      pedestrian_green   => pedestrian_green,
      pedestrian_red     => pedestrian_red,
      pedestrian_request => pedestrian_request
    );
  clk_process : process
  begin
    clk <= '0';
    wait for clk_period/2;
    clk <= '1';
    wait for clk_period/2;
  end process;
  stimulus_process : process
  begin
    reset <= '1';
    wait for 20 ns;
    reset <= '0';

    wait for 80 ns;
    pedestrian_request <= '1';
    wait for clk_period;
    pedestrian_request <= '0';
    wait for 300 ns;
    pedestrian_request <= '1';
    wait for clk_period;
    pedestrian_request <= '0';
    wait for 450 ns;
    pedestrian_request <= '1';
    wait for clk_period;
    pedestrian_request <= '0';

    wait for 500 ns;
    wait;
  end process;
  -- clk <= not clk after clk_period/2;

end;