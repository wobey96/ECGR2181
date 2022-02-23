library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;
-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;
entity sevenSegDecoder is
 Port ( sw : in STD_LOGIC_VECTOR (3 downto 0);
 seg : out STD_LOGIC_VECTOR (0 to 6);
 negative : in STD_LOGIC);
end sevenSegDecoder;
 architecture Behavioral of sevenSegDecoder is
begin
 seg <= "1111110" when(negative = '1') else ---
 "0000001" when(sw="0000") else --0
 "1001111" when(sw="0001") else --1
 "0010010" when(sw="0010") else --2
 "0000110" when(sw="0011") else --3
 "1001100" when(sw="0100") else --4
 "0100100" when(sw="0101") else --5
 "0100000" when(sw="0110") else --6
 "0001111" when(sw="0111") else --7
 "0000000" when(sw="1000") else --8
 "0000100" when(sw="1001") else --9
 "0001000" when(sw="1010") else --A
 "1100000" when(sw="1011") else --B
 "0110001" when(sw="1100") else --C
 "1000010" when(sw="1101") else --D
 "0110000" when(sw="1110") else --E
 "0111000" when(sw="1111") else --F
 (others => '1');

end Behavioral;
