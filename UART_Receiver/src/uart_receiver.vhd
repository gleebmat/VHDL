----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/18/2026 04:17:56 PM
-- Design Name: 
-- Module Name: uart_receiver - Behavioral
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

entity uart_receiver is
  generic (
    CLK_FREQ  : natural := 100_000_000;
    BAUD_RATE : natural := 115_200
  );
  port (
    clk           : in std_logic;
    reset         : in std_logic;
    rx            : in std_logic;
    data_valid    : out std_logic;
    data_out      : out std_logic_vector(7 downto 0);
    framing_error : out std_logic
  );
end uart_receiver;

architecture Behavioral of uart_receiver is
  constant bit_time      : natural := CLK_FREQ / BAUD_RATE;
  constant bit_time_half : natural := bit_time / 2;
  signal final_rx        : std_logic;
  signal counter         : natural range 0 to bit_time - 1 := 0;
  signal receive_reg     : std_logic_vector(7 downto 0)    := (others => '0');
  signal bit_count       : natural range 0 to 7            := 0;
  signal data_valid_reg  : std_logic                       := '0';
  signal error_reg       : std_logic                       := '0';
  type state_type is
  (IDLE,
  START_CONFIRM,
  DATA_RECEIVE,
  STOP_CONFIRM);
  signal state : state_type := IDLE;
begin
  rx_synchro_inst : entity work.rx_synchro
    port map
    (
      rx       => rx,
      reset    => reset,
      clk      => clk,
      final_rx => final_rx
    );
  process (clk, reset)

  begin

    if reset = '1' then
      state          <= IDLE;
      counter        <= 0;
      bit_count      <= 0;
      data_valid_reg <= '0';
      error_reg      <= '0';
      receive_reg    <= (others => '0');
    elsif rising_edge(clk) then
      error_reg      <= '0';
      data_valid_reg <= '0';
      case state is
        when IDLE =>
          counter   <= 0;
          bit_count <= 0;
          if final_rx = '0' then
            state <= START_CONFIRM;
          end if;
        when START_CONFIRM =>
          if counter = bit_time_half - 1 then
            if final_rx = '0' then
              state   <= DATA_RECEIVE;
              counter <= 0;
            else
              state   <= IDLE;
              counter <= 0;
            end if;
          else
            counter <= counter + 1;
          end if;
        when DATA_RECEIVE =>
          if counter = bit_time - 1 then
            receive_reg(bit_count) <= final_rx;
            if bit_count = 7 then
              state   <= STOP_CONFIRM;
              counter <= 0;
            else
              bit_count <= bit_count + 1;
              counter   <= 0;
            end if;
          else
            counter <= counter + 1;
          end if;
        when STOP_CONFIRM =>
          if counter = bit_time - 1 then
            if final_rx = '1' then
              state          <= IDLE;
              counter        <= 0;
              bit_count      <= 0;
              data_valid_reg <= '1';
            else
              error_reg <= '1';
              state     <= IDLE;
              counter   <= 0;
              bit_count <= 0;
            end if;
          else
            counter <= counter + 1;
          end if;
      end case;
    end if;
  end process;
  framing_error <= error_reg;
  data_valid    <= data_valid_reg;
  data_out      <= receive_reg;
end Behavioral;
