library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity pwm_generator_tb is
end entity pwm_generator_tb;

architecture bench of pwm_generator_tb is

  constant CLK_PERIOD : time := 10 ns;

  signal clk        : std_logic            := '0';
  signal reset      : std_logic            := '0';
  signal duty_cycle : unsigned(3 downto 0) := "0000";
  signal pwm_out    : std_logic;

begin

  UUT : entity work.pwm_generator
    generic map(
      BIT_LIMIT => 4
    )
    port map
    (
      clk        => clk,
      reset      => reset,
      duty_cycle => duty_cycle,
      pwm_out    => pwm_out
    );

  -- Clock generation
  clk_process : process
  begin
    clk <= '0';
    wait for CLK_PERIOD / 2;
    clk <= '1';
    wait for CLK_PERIOD / 2;
  end process;
  stimulus_process : process
  begin
    -- Reset the design
    reset <= '1';
    wait for 20 ns;
    reset <= '0';
    wait for 10 ns;
    -- Test different duty cycles
    duty_cycle <= to_unsigned(0, 4);
    wait for 200 ns;
    duty_cycle <= to_unsigned(4, 4);
    wait for 200 ns;
    duty_cycle <= to_unsigned(8, 4);
    wait for 200 ns;
    duty_cycle <= to_unsigned(12, 4);
    wait for 200 ns;
    duty_cycle <= to_unsigned(15, 4);
    wait for 200 ns;
    wait;
  end process;

end bench;