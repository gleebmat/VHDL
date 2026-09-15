----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Gleb Matyushev
-- 
-- Create Date: 09/15/2026 01:07:33 PM
-- Design Name: 
-- Module Name: Traffic_controller - Behavioral
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

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Traffic_controller is
  generic (
    GREEN_TIME             : positive := 12;
    YELLOW_TIME            : positive := 3;
    PEDESTRIAN_TIME        : positive := 7;
    WAIT_BEFORE_TRANSITION : positive := 2;
    BLINK_TIME             : positive := 5;
    BLINK_HALF_PERIOD      : positive := 2
  );
  port (
    clk   : in std_logic;
    reset : in std_logic;

    ns_green  : out std_logic;
    ns_yellow : out std_logic;
    ns_red    : out std_logic;

    ew_green  : out std_logic;
    ew_yellow : out std_logic;
    ew_red    : out std_logic;

    pedestrian_green   : out std_logic;
    pedestrian_red     : out std_logic;
    pedestrian_request : in std_logic := '0'
  );
end Traffic_controller;

architecture Behavioral of Traffic_controller is
  signal timer         : natural   := 0;
  signal blink_counter : natural   := 0;
  signal blink_state   : std_logic := '0';
  type state_type is (
    NS_RED_YELLOW_STATE,
    NS_GREEN_STATE,
    NS_GREEN_BLINK_STATE,
    NS_YELLOW_STATE,
    NS_RED_STATE,
    EW_RED_YELLOW_STATE,
    EW_GREEN_STATE,
    EW_GREEN_BLINK_STATE,
    EW_YELLOW_STATE,
    EW_RED_STATE,
    PED_TO_EW_STATE,
    PED_BLINK_TO_EW_STATE,
    PED_TO_NS_STATE,
    PED_BLINK_TO_NS_STATE
  );

  signal state              : state_type := NS_RED_YELLOW_STATE;
  signal pedestrian_pending : std_logic  := '0';
begin
  traffic_fsm : process (clk, reset)
  begin

    if reset = '1' then
      state              <= NS_RED_YELLOW_STATE;
      timer              <= 0;
      blink_counter      <= 0;
      blink_state        <= '1';
      pedestrian_pending <= '0';
    elsif rising_edge(clk) then
      if state = NS_GREEN_BLINK_STATE or
        state = EW_GREEN_BLINK_STATE or
        state = PED_BLINK_TO_NS_STATE or
        state = PED_BLINK_TO_EW_STATE then

        if blink_counter < BLINK_HALF_PERIOD - 1 then
          blink_counter <= blink_counter + 1;
        else
          blink_counter <= 0;
          blink_state   <= not blink_state;
        end if;

      else
        blink_counter <= 0;
        blink_state   <= '0';
      end if;

      if pedestrian_request = '1' then
        pedestrian_pending <= '1';
      end if;
      case state is
        when NS_RED_YELLOW_STATE =>
          if timer < BLINK_TIME - 1 then
            timer <= timer + 1;
          else
            state <= NS_GREEN_STATE;
            timer <= 0;
          end if;

        when NS_GREEN_STATE =>
          if timer < GREEN_TIME - 1 then
            timer <= timer + 1;
          else
            state <= NS_GREEN_BLINK_STATE;
            timer <= 0;
          end if;

        when NS_GREEN_BLINK_STATE =>
          if timer < BLINK_TIME - 1 then
            timer <= timer + 1;

          else
            state <= NS_YELLOW_STATE;
            timer <= 0;
          end if;

        when NS_YELLOW_STATE =>
          if timer < YELLOW_TIME - 1 then
            timer <= timer + 1;
          else
            state <= NS_RED_STATE;
            timer <= 0;
          end if;
        when NS_RED_STATE =>
          if timer < WAIT_BEFORE_TRANSITION - 1 then
            timer <= timer + 1;
          else
            if pedestrian_pending = '1' then
              state              <= PED_TO_EW_STATE;
              pedestrian_pending <= '0';
            else
              state <= EW_RED_YELLOW_STATE;
            end if;
            timer <= 0;
          end if;

        when EW_RED_YELLOW_STATE =>
          if timer < BLINK_TIME - 1 then
            timer <= timer + 1;
          else
            state <= EW_GREEN_STATE;
            timer <= 0;
          end if;

        when EW_GREEN_STATE =>
          if timer < GREEN_TIME - 1 then
            timer <= timer + 1;
          else
            state <= EW_GREEN_BLINK_STATE;
            timer <= 0;
          end if;

        when EW_GREEN_BLINK_STATE =>
          if timer < BLINK_TIME - 1 then
            timer <= timer + 1;

          else
            state <= EW_YELLOW_STATE;
            timer <= 0;
          end if;

        when EW_YELLOW_STATE =>
          if timer < YELLOW_TIME - 1 then
            timer <= timer + 1;
          else
            state <= EW_RED_STATE;
            timer <= 0;
          end if;

        when EW_RED_STATE =>
          if timer < WAIT_BEFORE_TRANSITION - 1 then
            timer <= timer + 1;
          else
            if pedestrian_pending = '1' then
              state              <= PED_TO_NS_STATE;
              pedestrian_pending <= '0';
            else
              state <= NS_RED_YELLOW_STATE;
            end if;
            timer <= 0;
          end if;

        when PED_TO_NS_STATE =>
          if timer < PEDESTRIAN_TIME - 1 then
            timer <= timer + 1;
          else
            state <= PED_BLINK_TO_NS_STATE;
            timer <= 0;
          end if;

        when PED_TO_EW_STATE =>
          if timer < PEDESTRIAN_TIME - 1 then
            timer <= timer + 1;
          else
            state <= PED_BLINK_TO_EW_STATE;
            timer <= 0;
          end if;

        when PED_BLINK_TO_NS_STATE =>
          if timer < BLINK_TIME - 1 then
            timer <= timer + 1;
          else
            state <= NS_RED_YELLOW_STATE;
            timer <= 0;
          end if;

        when PED_BLINK_TO_EW_STATE =>
          if timer < BLINK_TIME - 1 then
            timer <= timer + 1;
          else
            state <= EW_RED_YELLOW_STATE;
            timer <= 0;
          end if;

        when others =>
          state <= NS_RED_YELLOW_STATE;
          timer <= 0;
      end case;
    end if;
  end process;

  output_decoder : process (state, blink_state)
  begin
    -- default safe values
    ns_green  <= '0';
    ns_yellow <= '0';
    ns_red    <= '1';

    ew_green  <= '0';
    ew_yellow <= '0';
    ew_red    <= '1';

    pedestrian_green <= '0';
    pedestrian_red   <= '1';

    case state is
      when NS_RED_YELLOW_STATE =>
        ns_yellow <= '1';
        ns_red    <= '1';
        ns_green  <= '0';

        ew_red    <= '1';
        ew_yellow <= '0';
        ew_green  <= '0';

        pedestrian_red   <= '1';
        pedestrian_green <= '0';

      when NS_GREEN_STATE =>
        ns_green  <= '1';
        ns_red    <= '0';
        ns_yellow <= '0';

        ew_red    <= '1';
        ew_yellow <= '0';
        ew_green  <= '0';

        pedestrian_red   <= '1';
        pedestrian_green <= '0';
      when NS_GREEN_BLINK_STATE =>
        ns_green  <= blink_state;
        ns_red    <= '0';
        ns_yellow <= '0';

        ew_red    <= '1';
        ew_yellow <= '0';
        ew_green  <= '0';

        pedestrian_red   <= '1';
        pedestrian_green <= '0';

      when NS_YELLOW_STATE =>
        ns_yellow <= '1';
        ns_red    <= '0';
        ns_green  <= '0';

        ew_red    <= '1';
        ew_yellow <= '0';
        ew_green  <= '0';

        pedestrian_red   <= '1';
        pedestrian_green <= '0';
      when NS_RED_STATE =>
        ns_red    <= '1';
        ew_red    <= '1';
        ns_yellow <= '0';
        ns_green  <= '0';

        ew_yellow <= '0';
        ew_green  <= '0';

        pedestrian_red   <= '1';
        pedestrian_green <= '0';

      when EW_RED_YELLOW_STATE =>
        ew_red    <= '1';
        ew_yellow <= '1';
        ew_green  <= '0';

        ns_red    <= '1';
        ns_yellow <= '0';
        ns_green  <= '0';

        pedestrian_red   <= '1';
        pedestrian_green <= '0';

      when EW_GREEN_STATE =>
        ew_green  <= '1';
        ns_red    <= '1';
        ew_yellow <= '0';
        ew_red    <= '0';

        ns_yellow <= '0';
        ns_green  <= '0';

        pedestrian_red   <= '1';
        pedestrian_green <= '0';

      when EW_GREEN_BLINK_STATE =>
        ew_green  <= blink_state;
        ew_red    <= '0';
        ew_yellow <= '0';

        ns_red    <= '1';
        ns_yellow <= '0';
        ns_green  <= '0';

        pedestrian_red   <= '1';
        pedestrian_green <= '0';

      when EW_YELLOW_STATE =>
        ns_red    <= '1';
        ns_yellow <= '0';
        ns_green  <= '0';

        ew_yellow <= '1';
        ew_red    <= '0';
        ew_green  <= '0';

        pedestrian_red   <= '1';
        pedestrian_green <= '0';
      when EW_RED_STATE =>
        ns_red    <= '1';
        ns_yellow <= '0';
        ns_green  <= '0';

        ew_red    <= '1';
        ew_yellow <= '0';
        ew_green  <= '0';

        pedestrian_red   <= '1';
        pedestrian_green <= '0';
      when PED_TO_NS_STATE =>
        ns_red           <= '1';
        ew_red           <= '1';
        ns_yellow        <= '0';
        ns_green         <= '0';
        ew_yellow        <= '0';
        ew_green         <= '0';
        pedestrian_green <= '1';
        pedestrian_red   <= '0';

      when PED_TO_EW_STATE =>
        ns_red           <= '1';
        ns_yellow        <= '0';
        ns_green         <= '0';
        ew_yellow        <= '0';
        ew_green         <= '0';
        ew_red           <= '1';
        pedestrian_green <= '1';
        pedestrian_red   <= '0';

      when PED_BLINK_TO_NS_STATE =>
        pedestrian_red   <= '0';
        ns_red           <= '1';
        ns_yellow        <= '0';
        ns_green         <= '0';
        ew_yellow        <= '0';
        ew_green         <= '0';
        ew_red           <= '1';
        pedestrian_green <= blink_state;

      when PED_BLINK_TO_EW_STATE =>
        ns_red           <= '1';
        ns_yellow        <= '0';
        ns_green         <= '0';
        ew_yellow        <= '0';
        ew_green         <= '0';
        ew_red           <= '1';
        pedestrian_red   <= '0';
        pedestrian_green <= blink_state;

      when others =>
        ns_red    <= '1';
        ns_yellow <= '0';
        ns_green  <= '0';
        ew_yellow <= '0';
        ew_green  <= '0';
        ew_red    <= '1';

        pedestrian_red   <= '1';
        pedestrian_green <= '0';
    end case;
  end process;

end Behavioral;
