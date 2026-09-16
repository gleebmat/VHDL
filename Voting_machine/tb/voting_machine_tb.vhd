
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity project_6_divider_tb is
end;

architecture bench of project_6_divider_tb is
  -- Clock period
  constant clk_period : time := 5 ns;
  -- Generics
  -- Ports
  signal clk          : std_logic := '0';
  signal reset        : std_logic;
  signal party1       : std_logic;
  signal party2       : std_logic;
  signal party3       : std_logic;
  signal select_party : std_logic;
  signal count1_op    : std_logic_vector(5 downto 0);
  signal count2_op    : std_logic_vector(5 downto 0);
  signal count3_op    : std_logic_vector(5 downto 0);
begin
  clk <= not clk after clk_period / 2;
  project_6_divider_inst : entity work.project_6_divider
    port map
    (
      clk          => clk,
      reset        => reset,
      party1       => party1,
      party2       => party2,
      party3       => party3,
      select_party => select_party,
      count1_op    => count1_op,
      count2_op    => count2_op,
      count3_op    => count3_op
    );
  stimulus : process

  begin
    reset <= '1';
    wait for 10 ns;
    reset <= '0';

    party1       <= '0';
    party2       <= '0';
    party3       <= '0';
    select_party <= '0';
    party1       <= '1';
    wait for 10 ns;
    party1 <= '0';
    wait for 10 ns;
    select_party <= '1';
    wait for 10 ns;
    select_party <= '0';
    wait for 10 ns;
    party2 <= '1';
    wait for 10 ns;
    party2 <= '0';
    wait for 10 ns;
    select_party <= '1';
    wait for 10 ns;
    select_party <= '0';
    wait for 10 ns;
    party3 <= '1';
    wait for 10 ns;
    party3 <= '0';
    wait for 10 ns;
    select_party <= '1';
    wait for 10 ns;
    select_party <= '0';
    wait for 10 ns;

    -- clk <= not clk after clk_period/2;

  end process stimulus;
end architecture bench;