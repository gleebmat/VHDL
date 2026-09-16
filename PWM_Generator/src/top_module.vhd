----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 09/14/2026 03:05:13 PM
-- Design Name: 
-- Module Name: top_module - Behavioral
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

entity top_module is
  port (
    clk   : in std_logic;
    reset : in std_logic;
    led   : out std_logic
  );
end top_module;

architecture Behavioral of top_module is
  signal pwm_out : std_logic;

begin
  pwm_inst : entity work.pwm_generator
    generic map(
      BIT_LIMIT => 4
    )
    port map
    (
      clk        => clk,
      reset      => reset,
      duty_cycle => "1000", -- 50% duty cycle for 4-bit counter
      pwm_out    => pwm_out
    );
  led <= pwm_out;

end Behavioral;
