library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity four_digit_7seg_tb is
end entity four_digit_7seg_tb;

architecture bench of four_digit_7seg_tb is

  constant CLK_PERIOD : time := 10 ns;

  signal clk   : std_logic := '0';
  signal reset : std_logic := '0';

  signal hex0 : std_logic_vector(3 downto 0) := "0000";
  signal hex1 : std_logic_vector(3 downto 0) := "0001"; -- 
  signal hex2 : std_logic_vector(3 downto 0) := "0010"; -- 
  signal hex3 : std_logic_vector(3 downto 0) := "0011"; -- 

  signal an  : std_logic_vector(3 downto 0);
  signal seg : std_logic_vector(6 downto 0);

begin

  UUT : entity work.four_digit_7seg
    generic map(
      MAX_COUNTER => 3
    )
    port map
    (
      clk   => clk,
      reset => reset,
      hex0  => hex0,
      hex1  => hex1,
      hex2  => hex2,
      hex3  => hex3,
      an    => an,
      seg   => seg
    );

  clk_process : process
  begin
    while true loop
      clk <= '0';
      wait for CLK_PERIOD / 2;

      clk <= '1';
      wait for CLK_PERIOD / 2;
    end loop;
  end process;

  stimulus : process
  begin
    reset <= '1';
    wait for 20 ns;

    reset <= '0';
    wait for 300 ns;

    wait;
  end process;

end architecture bench;