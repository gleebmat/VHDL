library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity clock_divider is
  port (
    clk     : in std_logic;
    clk_out : out std_logic
  );
end entity clock_divider;

architecture Behavioral of clock_divider is

  signal division_value : unsigned(25 downto 0) := to_unsigned(50_000_000, 26);
  signal counter        : unsigned(25 downto 0) := (others => '0');
  signal clk_out_i      : std_logic             := '0';

begin

  process (clk)
  begin
    if rising_edge(clk) then
      if counter = division_value - 1 then
        counter   <= (others => '0');
        clk_out_i <= not clk_out_i;
      else
        counter <= counter + 1;
      end if;
    end if;
  end process;

  clk_out <= clk_out_i;

end architecture Behavioral;