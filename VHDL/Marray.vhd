----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    09:12:21 01/04/2010 
-- Design Name: 
-- Module Name:    Marray - Behavioral 
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

entity Marray is
port(pixIN,svIN: in std_logic_vector(7 downto 0);
	  dataOUT: out std_logic_vector(15 downto 0));
end Marray;

architecture Behavioral of Marray is

type arr is array(0 to 3) of std_logic_vector(7 downto 0);
type arr2 is array(0 to 3) of std_logic_vector(15 downto 0);

signal I1: arr;
signal I2: arr;
signal O: arr2;

component Multiplier is
generic(Abitwidth:integer; Bbitwidth:integer);
port(operandA: in std_logic_vector(Abitwidth-1 downto 0);
	  operandB: in std_logic_vector(Bbitwidth-1 downto 0);
	  Product: out std_logic_vector(Abitwidth+Bbitwidth-1 downto 0));
end component;

begin

I1(0) <= pixIN;

g1 : FOR i IN 0 TO 3 GENERATE        
	mult1: Multiplier
		generic map(8,8)
		port map(I1(i),I2(i),O(i));
end generate g1;

end Behavioral;

