----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/12/2026 03:13:26 PM
-- Design Name: 
-- Module Name: four_digit_7seg - Behavioral
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
use IEEE.NUMERIC_STD.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity four_digit_7seg is
  generic (
    MAX_COUNTER : positive := 25_000
  );
  port (
    clk   : in std_logic;
    reset : in std_logic;
    hex0  : in std_logic_vector(3 downto 0) := "0000";
    hex1  : in std_logic_vector(3 downto 0) := "0001";
    hex2  : in std_logic_vector(3 downto 0) := "0010";
    hex3  : in std_logic_vector(3 downto 0) := "0011";
    an    : out std_logic_vector(3 downto 0);
    seg   : out std_logic_vector(6 downto 0)
  );
end four_digit_7seg;

architecture Behavioral of four_digit_7seg is
  signal current_hex  : std_logic_vector(3 downto 0)       := "0000";
  signal counter      : natural range 0 to MAX_COUNTER - 1 := 0;
  signal digit_select : unsigned(1 downto 0)               := "00";
begin
  hex_to_seg : entity work.hex_to_segments
    port map
    (
      hex => current_hex,
      seg => seg
    );
  process (clk, reset)
  begin
    if reset = '1' then
      digit_select <= "00";
      counter      <= 0;
    elsif rising_edge(clk) then
      if counter = MAX_COUNTER - 1 then
        counter      <= 0;
        digit_select <= digit_select + 1;
      else
        counter <= counter + 1;
      end if;
    end if;
  end process;
  process (digit_select, hex0, hex1, hex2, hex3)
  begin
    case digit_select is
      when "00" =>
        current_hex <= hex0;
        an          <= "1110";
      when "01" =>
        current_hex <= hex1;
        an          <= "1101";
      when "10" =>
        current_hex <= hex2;
        an          <= "1011";
      when "11" =>
        current_hex <= hex3;
        an          <= "0111";
      when others =>
        current_hex <= "0000";
        an          <= "1111";
    end case;
  end process;
end Behavioral;
