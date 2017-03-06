----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:24:54 12/24/2009 
-- Design Name: 
-- Module Name:    AddressGen - Behavioral 
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

entity AddressGen is
generic (bitwidth: integer  := 5; MaxAddress: integer := 20); 
port(
	clock: in std_logic;
	reset: in std_logic;
	address: out std_logic_vector(bitwidth-1 downto 0)
);
end AddressGen;

architecture Behavioral of AddressGen is

signal counter: std_logic_vector(bitwidth-1 downto 0);

begin

	process (clock, reset)begin
		if(reset = '1')then
			counter <= (others => '0');
			address <= (others => '0');
		elsif rising_edge(clock)then
			address <= counter;
			if(counter = MaxAddress)then
				counter <= (others => '0');
			else
				counter <= counter + 1;
			end if;
		else
			counter <= counter;
		end if;
	end process;
	
end Behavioral;
