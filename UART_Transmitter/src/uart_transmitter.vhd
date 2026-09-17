----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/17/2026 03:01:59 PM
-- Design Name: 
-- Module Name: UART - Behavioral
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity UART is

  generic (
    CLOCK_FREQUENCY : positive := 100_000_000;
    BAUD_RATE       : positive := 115_200
  );
  port (
    clk   : in std_logic;
    reset : in std_logic;

    start   : in std_logic;
    data_in : in std_logic_vector(7 downto 0);

    tx      : out std_logic;
    busy    : out std_logic;
    tx_done : out std_logic

  );
end UART;

architecture Behavioral of UART is
  constant CLKS_PER_BIT : positive  := CLOCK_FREQUENCY / BAUD_RATE;
  signal tx_done_reg    : std_logic := '0';
  type state_type is
  (
  IDLE,
  START_BIT,
  DATA_BITS,
  STOP_BIT
  );

  signal state       : state_type                          := IDLE;
  signal counter     : natural range 0 to CLKS_PER_BIT - 1 := 0;
  signal counter_bit : natural range 0 to 7                := 0;
  signal data_reg    : std_logic_vector(7 downto 0)        := (others => '0');
begin
  process (clk, reset)
  begin
    if reset = '1' then
      state       <= IDLE;
      counter     <= 0;
      counter_bit <= 0;
      data_reg    <= (others => '0');
      tx_done_reg <= '0';
    elsif rising_edge(clk) then
      tx_done_reg <= '0';
      case state is
        when IDLE =>
          counter     <= 0;
          counter_bit <= 0;
          if start = '1' then
            state    <= START_BIT;
            data_reg <= data_in;
          end if;
        when START_BIT =>
          if counter = CLKS_PER_BIT - 1 then
            state   <= DATA_BITS;
            counter <= 0;
          else
            counter <= counter + 1;
          end if;
        when DATA_BITS =>
          if counter = CLKS_PER_BIT - 1 then
            counter <= 0;
            if counter_bit = 7 then
              state       <= STOP_BIT;
              counter_bit <= 0;
            else
              counter_bit <= counter_bit + 1;
            end if;
          else
            counter <= counter + 1;
          end if;
        when STOP_BIT =>
          if counter = CLKS_PER_BIT - 1 then
            counter     <= 0;
            state       <= IDLE;
            tx_done_reg <= '1';
          else
            counter <= counter + 1;
          end if;
      end case;
    end if;
  end process;

  process (state, data_reg, counter_bit)
  begin
    case state is
      when IDLE =>

        tx   <= '1';
        busy <= '0';
      when START_BIT =>

        busy <= '1';
        tx   <= '0';
      when DATA_BITS =>
        busy <= '1';
        tx   <= data_reg(counter_bit);
      when STOP_BIT =>
        busy <= '1';
        tx   <= '1';
    end case;
  end process;
  tx_done <= tx_done_reg;
end Behavioral;
