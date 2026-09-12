library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity hex_to_7seg_tb is
end entity hex_to_7seg_tb;

architecture bench of hex_to_7seg_tb is

  signal hex : std_logic_vector(3 downto 0) := "0000";
  signal seg : std_logic_vector(6 downto 0);

begin

  UUT : entity work.hex_to_segments
    port map
    (
      hex => hex,
      seg => seg
    );

  stimulus : process
  begin

    hex <= "0000";
    wait for 10 ns; -- 0
    hex <= "0001";
    wait for 10 ns; -- 1
    hex <= "0010";
    wait for 10 ns; -- 2
    hex <= "0011";
    wait for 10 ns; -- 3
    hex <= "0100";
    wait for 10 ns; -- 4
    hex <= "0101";
    wait for 10 ns; -- 5
    hex <= "0110";
    wait for 10 ns; -- 6
    hex <= "0111";
    wait for 10 ns; -- 7
    hex <= "1000";
    wait for 10 ns; -- 8
    hex <= "1001";
    wait for 10 ns; -- 9
    hex <= "1010";
    wait for 10 ns; -- A
    hex <= "1011";
    wait for 10 ns; -- b
    hex <= "1100";
    wait for 10 ns; -- C
    hex <= "1101";
    wait for 10 ns; -- d
    hex <= "1110";
    wait for 10 ns; -- E
    hex <= "1111";
    wait for 10 ns; -- F

    wait;
  end process;

end architecture bench;