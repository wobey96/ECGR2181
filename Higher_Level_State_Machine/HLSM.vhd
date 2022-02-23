library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
entity sevenSegMux is
 port (
 clk : in STD_LOGIC;
 in0 : in STD_LOGIC_VECTOR (3 downto 0);
 in1 : in STD_LOGIC_VECTOR (3 downto 0);
 in2 : in STD_LOGIC_VECTOR (3 downto 0);
 in3 : in STD_LOGIC_VECTOR (3 downto 0);
 seg : out STD_LOGIC_VECTOR (0 to 6);
 an : out STD_LOGIC_VECTOR (3 downto 0);
 blank : in STD_LOGIC;
 negative : in STD_LOGIC;
end sevenSegMux;
architecture Behavioral of sevenSegMux is

 component sevensegDecoder
 port( sw: in std_logic_vector (3 downto 0);
 seg: out std_logic_vector (6 downto 0);
 negative: in std_logic);
 end component;

 type State is (State_0, State_1, State_2, State_3);
 signal current_state, next_state : State;
 signal shouldShowNegative : std_logic;
 signal data : STD_LOGIC_VECTOR(3 downto 0);
 constant counter_max : unsigned(15 downto 0) := x"8000"; --fpga
 signal counter_sel : unsigned(1 downto 0) := "00";
 signal counter : unsigned(15 downto 0) := x"0000";

begin
 sevenSegDecoder_insta0: sevensegDecoder port map
 (
 sw => data,
 segment => segment
   
   negative => shouldShowNegative;

 );

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



 state_machine : process (in0, in1, in2, in3, current_state, neg,
blank)
 begin
 case current_state is
 when State_0 =>

 an <= "0111";
 data <= in0;
 shouldShowNegative <= '0';
 next_state <= State_1;
 when State_1 =>

 an <= "1011";
 data <= in1;
 shouldShowNegative <= '0';
 next_state <= State_2;

 when State_2 =>

 if (blank = '1') then
 an <= "1111";
 next_state <= State_3;
 else
 if (neg = '0') then
 an <= "1101";
 data <= in2;
 shouldShowNegative <= '0';
 next_state <= State_3;
 else
 an <= "1101";
 next_state <= State_3;
 shouldShowNegative <= '1';
 end if;
 end if;
   
   when State_3 =>
 an <= "1110";
 data <= in3;
 shouldShowNegative <= '0';
 next_state <= State_0;
 end case;
 end process state_machine;
end Behavioral;
