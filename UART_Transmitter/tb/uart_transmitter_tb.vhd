
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity UART_tb is
end;

architecture bench of UART_tb is
  -- Clock period
  constant clk_period : time := 5 ns;
  -- Generics
  constant CLOCK_FREQUENCY : positive := 10;
  constant BAUD_RATE       : positive := 5;
  -- Ports
  signal clk     : std_logic                    := '0';
  signal reset   : std_logic                    := '0';
  signal start   : std_logic                    := '0';
  signal data_in : std_logic_vector(7 downto 0) := (others => '0');
  signal tx      : std_logic;
  signal busy    : std_logic;
  signal tx_done : std_logic;
begin

  UART_inst : entity work.UART
    generic map(
      CLOCK_FREQUENCY => CLOCK_FREQUENCY,
      BAUD_RATE       => BAUD_RATE
    )
    port map
    (
      clk     => clk,
      reset   => reset,
      start   => start,
      data_in => data_in,
      tx      => tx,
      busy    => busy,
      tx_done => tx_done
    );
  clk_process : process
  begin
    clk <= '0';
    wait for clk_period/2;
    clk <= '1';
    wait for clk_period/2;
  end process;
  stimulus : process
  begin
    wait for 10 ns;
    reset <= '1';
    wait for 10 ns;
    reset <= '0';
    start <= '0';
    wait for 10 ns;

    data_in <= "01010101";
    start   <= '1';
    wait for clk_period;
    start <= '0';
    wait for 4 * clk_period;
    data_in <= x"A5";
    wait;
  end process;
end;