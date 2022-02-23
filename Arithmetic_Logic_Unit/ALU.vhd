----------------------------------------------------------------------------------
-- Company:
-- Engineer:
--
-- Create Date: 11/06/2016 11:03:18 PM
-- Design Name:
-- Module Name: myALU - Behavioral
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
use IEEE.STD_LOGIC_1164.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;
-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;
entity myALU is
 Port ( A : in STD_LOGIC_VECTOR (3 downto 0);
 B : in STD_LOGIC_VECTOR (3 downto 0);
 operand : in STD_LOGIC_VECTOR (2 downto 0);
 aBuffer : out STD_LOGIC_VECTOR (3 downto 0);
 bBuffer : out STD_LOGIC_VECTOR (3 downto 0);
 zero : out STD_LOGIC;
 overflow : out STD_LOGIC;
 negative : out STD_LOGIC;
 carryOut : out STD_LOGIC;
 dataOut : out STD_LOGIC_VECTOR (3 downto 0));
end myALU;
  
  architecture Behavioral of myALU is
begin
process (A, B, operand ) is
variable outputBuffer : std_logic_vector(4 downto 0);
variable multiplyBuffer : std_logic_vector(7 downto 0);
begin
 zero <= '0';
 overflow <= '0';
 negative <= '0';
 carryOut <= '0';
 dataOut <= "0000";
 case operand is
 when "000" =>
 outputBuffer := std_logic_vector(unsigned("0" & A) + unsigned(B));


 dataOut(3 downto 0) <= std_logic_vector(outputBuffer(3 downto 0));


 carryOut <= outputBuffer(4);

 overflow <= ((not A(3) and not B(3)) and (outputBuffer(3)));


 negative <= outputBuffer(3);

 if (outputBuffer(3 downto 0) = "0000") then
 zero <= '1';
 else
 zero <= '0';
 end if;

when "001" =>
 outputBuffer:=std_logic_vector(unsigned("0"&A) + unsigned(not B) + "1");
dataOut(3 downto 0) <= std_logic_vector(outputBuffer(3 downto 0));

 carryOut <= outputBuffer(4);
 overflow <= (( A(3) and not B(3)) and not outputBuffer(3));

 negative <= outputBuffer(3);
 if (outputBuffer(3 downto 0) = "0000") then
 zero <= '1';
 else
 zero <= '0';
 end if;
when "010" =>
outputBuffer:= std_logic_vector(unsigned ("0" & A) +"1");
dataOut(3 downto 0) <= std_logic_vector(outputBuffer(3 downto 0 ));

carryOut <= outputBuffer(4);
negative <= outputBuffer(3);
if (outputBuffer(3 downto 0) = "0000") then
 zero <= '1';
 else
 zero <= '0';
 end if;
when "011" =>
multiplyBuffer := std_logic_vector(unsigned(A) * unsigned(B));
dataOut(3 downto 0) <= std_logic_vector(multiplyBuffer(3 downto 0));
zero <= multiplyBuffer(7);
overflow <= multiplyBuffer(6);
negative <= multiplyBuffer(5);
carryOut <= multiplyBuffer(4);
when "100" =>
outputBuffer (3 downto 0) := A and B;
dataOut (3 downto 0) <= outputBuffer (3 downto 0);
if (outputBuffer(3 downto 0) = "0000") then
 zero <= '1';
 else
 zero <= '0';
 end if;
when "101" =>
outputBuffer (3 downto 0) := A or B;
dataOut (3 downto 0) <= outputBuffer (3 downto 0);
if (outputBuffer(3 downto 0) = "0000") then
 zero <= '1';
 else
 zero <= '0';
 end if;
when "110" =>
outputBuffer (3 downto 0) := A xor B;
dataOut (3 downto 0) <= outputBuffer (3 downto 0);
if (outputBuffer(3 downto 0) = "0000") then
 zero <= '1';
 else
 zero <= '0';
 end if;
when others =>
outputBuffer (3 downto 0) := not A;
dataOut (3 downto 0) <= outputBuffer (3 downto 0);
if (outputBuffer(3 downto 0) = "0000") then
 zero <= '1';
 else
 zero <= '0';
 end if;
end case;
  
  outputBuffer := "00000";
multiplyBuffer := "00000000";
end process;
end Behavioral;
