----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 11/29/2016 05:25:23 PM
-- Design Name:
-- Module Name: sevenSegMux - Behavioral
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
use IEEE.NUMERIC_STD.all;
-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;
entity sevenSegMux is
port (
clk : in STD_LOGIC;
in0 : in STD_LOGIC_VECTOR (3 downto 0);
in1 : in STD_LOGIC_VECTOR (3 downto 0);
in2 : in STD_LOGIC_VECTOR (3 downto 0);
in3 : in STD_LOGIC_VECTOR (3 downto 0);
blank : in STD_LOGIC;
blank2 : in STD_LOGIC;
neg : in STD_LOGIC;
seg : out STD_LOGIC_VECTOR (0 to 6);
an : out STD_LOGIC_VECTOR (3 downto 0)
);
end sevenSegMux;
architecture Behavioral of sevenSegMux is
-- ADD YOUR sevenSegDecoder COMPONENT HERE
component sevenSegDecoder
port (
sw : in STD_LOGIC_VECTOR (3 downto 0);
seg : out STD_LOGIC_VECTOR (0 to 6);
negative : in STD_LOGIC
);
end component;
--Make a simple FSM which will act as a mux, a 2:4 decoder and decodes when the
negative should be display
type State is (State_0, State_1, State_2, State_3); --make our own custom datatype
signal current_state, next_state : State;
signal shouldShowNegative : std_logic;
signal data : STD_LOGIC_VECTOR(3 downto 0); -- buffer to hold the 7-segment input
data
constant counter_max : unsigned(15 downto 0) := x"8000"; --fpga
signal counter_sel : unsigned(1 downto 0) := "00";
signal counter : unsigned(15 downto 0) := x"0000";
begin
-- begin architecture
-- ADD YOUR sevenSegDecoder PORT MAP HERE
Decoder : sevenSegDecoder
port map(
sw => data,
seg => seg,
negative => shouldShowNegative
);
--simple clock_divider and changes the state
clock_divider : process (clk)
begin
if (clk'EVENT and clk = '1') then
if (counter >= counter_max) then
counter <= x"0000";
counter_sel <= counter_sel + 1;
current_state <= next_state;
else
counter <= counter + 1;
end if;
end if;
end process clock_divider;
--state machine process. Each state sets up the "an" outputs, what input connects to the
"data" output, sets the value of the "next_state", and decides whether the 3rd digit from the left
should show a negative or be blank. Each state here corresponds to 1 digit on the 7-segment
display
state_machine : process (current_state, in0, in1, in2, in3, neg, blank)
begin
case current_state is
when State_0 =>
shouldShowNegative <= '0'; --Don't show a negative sign on this
digit
an <= "0111";
data <= in0;
next_state <= State_1;
when State_1 =>
shouldShowNegative <= '0'; --Don't show a negative sign on this
digit
an <= "1011";
data <= in1;
next_state <= State_2;
when State_2 =>
if (blank = '1') then
an <= "1111";
next_state <= State_3;
else
if (neg = '0') then
shouldShowNegative <= '0'; --Don't show a
negative sign on this digit
an <= "1101";
data <= in2;
next_state <= State_3;
else
shouldShowNegative <= '1';
an <= "1101";
next_state <= State_3;
end if;
end if;
when State_3 =>
if (blank2 = '1') then
an <= "1111";
next_state <= State_0;
else
shouldShowNegative <= '0'; --Don't show a negative sign
on this digit
an <= "1110";
data <= in3;
next_state <= State_0;
end if;
end case;
end process state_machine;
end Behavioral;
