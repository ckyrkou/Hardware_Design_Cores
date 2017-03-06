----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:17:08 12/24/2009 
-- Design Name: 
-- Module Name:    Multiplier - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
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
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity MultiplierEn is
generic(Abitwidth:integer:=32; Bbitwidth:integer:=32);
port(enable: in std_logic;
	  operandA: in std_logic_vector(Abitwidth-1 downto 0);
	  operandB: in std_logic_vector(Bbitwidth-1 downto 0);
	  Product: out std_logic_vector(Abitwidth+Bbitwidth-1 downto 0));
end MultiplierEn;

architecture Behavioral of MultiplierEn is

begin

	process(enable,operandA,operandB)begin
		if(enable = '1')then
			Product <= operandA * operandB;
		else
			Product <= (others=>'0');
		end if;

	end process;

end Behavioral;

