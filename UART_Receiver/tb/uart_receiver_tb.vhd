library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity uart_receiver_tb is
end uart_receiver_tb;

architecture bench of uart_receiver_tb is

  constant clk_period : time := 5 ns;

  constant CLK_FREQ  : natural := 100;
  constant BAUD_RATE : natural := 10;

  constant CLKS_PER_BIT : natural := CLK_FREQ / BAUD_RATE;
  constant BIT_PERIOD   : time    := CLKS_PER_BIT * clk_period;

  signal clk   : std_logic := '0';
  signal reset : std_logic := '0';
  signal rx    : std_logic := '1';

  signal data_valid    : std_logic;
  signal data_out      : std_logic_vector(7 downto 0);
  signal framing_error : std_logic;

begin

  uart_receiver_inst : entity work.uart_receiver
    generic map(
      CLK_FREQ  => CLK_FREQ,
      BAUD_RATE => BAUD_RATE
    )
    port map
    (
      clk           => clk,
      reset         => reset,
      rx            => rx,
      data_valid    => data_valid,
      data_out      => data_out,
      framing_error => framing_error
    );

  clk_process : process
  begin
    while true loop
      clk <= '0';
      wait for clk_period / 2;

      clk <= '1';
      wait for clk_period / 2;
    end loop;
  end process;

  stimulus_process : process
    variable tx_byte : std_logic_vector(7 downto 0);
  begin
    -- UART line is idle-high.
    rx    <= '1';
    reset <= '1';

    wait for 2 * clk_period;
    reset <= '0';

    wait for 2 * BIT_PERIOD;

    ----------------------------------------------------------------
    -- Test 1: valid 8N1 UART frame, x"56" = 0101_0110
    ----------------------------------------------------------------
    tx_byte := x"56";

    -- Start bit
    rx <= '0';
    wait for BIT_PERIOD;

    -- Eight data bits, UART transmits LSB first.
    for i in 0 to 7 loop
      rx <= tx_byte(i);
      wait for BIT_PERIOD;
    end loop;

    -- Valid stop bit
    rx <= '1';
    wait for BIT_PERIOD;

    -- Allow the receiver to complete STOP_CONFIRM.
    wait for 2 * clk_period;

    assert data_out = x"56"
    report "ERROR: Receiver data_out is not x56 after valid frame"
      severity error;

    assert data_valid = '1'
    report "ERROR: data_valid did not assert after valid frame"
      severity error;

    assert framing_error = '0'
    report "ERROR: framing_error asserted for a valid UART frame"
      severity error;

    wait for clk_period;

    ----------------------------------------------------------------
    -- Test 2: invalid stop bit; should produce a framing error
    ----------------------------------------------------------------
    tx_byte := x"A5";

    -- Start bit
    rx <= '0';
    wait for BIT_PERIOD;

    -- Eight data bits, LSB first.
    for i in 0 to 7 loop
      rx <= tx_byte(i);
      wait for BIT_PERIOD;
    end loop;

    -- Invalid stop bit: must be high for a valid frame.
    rx <= '0';
    wait for BIT_PERIOD;

    -- Return the line to idle-high after the broken frame.
    rx <= '1';
    wait for 2 * clk_period;

    assert framing_error = '1'
    report "ERROR: framing_error did not assert for invalid stop bit"
      severity error;

    assert data_valid = '0'
    report "ERROR: data_valid asserted for an invalid UART frame"
      severity error;

    wait for clk_period;

    assert false
    report "UART receiver testbench completed successfully"
      severity note;

    wait;
  end process;

end architecture bench;