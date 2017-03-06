----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:43:26 12/24/2009 
-- Design Name: 
-- Module Name:    MAC - Behavioral 
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

entity GenericAccumulator is
generic(inBitwidth:integer:=8;sumBitwidth:integer:=25);
port(
	newData: in std_logic;
	reset: in std_logic;
	dataIn: in std_logic_vector(inBitwidth-1 downto 0);
	Sum: out std_logic_vector(sumBitwidth-1 downto 0));
end GenericAccumulator;

architecture Behavioral of GenericAccumulator is

signal temp: std_logic_vector(sumBitwidth-1 downto 0):=(others=>'0');

begin

	process(newData, reset)begin
	
		if(reset = '1')then
			temp <= (others=> '0');
		elsif(newData = '1' and newData'event)then
			temp <= temp + dataIn;	
		end if;
		
		Sum <= temp;
		
	end process;

end Behavioral;

