----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    13:20:08 12/24/2009 
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

entity MAC is
generic(Abitwidth: integer:= 8; Bbitwidth: integer:= 7;ACCbitwidth: integer:= 26);
port(
	reset: in std_logic;
	newData: in std_logic;
	operandA: in std_logic_vector(Abitwidth-1 downto 0); 
	operandB: in std_logic_vector(Bbitwidth-1 downto 0); 
	AccResult: out std_logic_vector(ACCbitwidth-1 downto 0));
end MAC;

architecture Behavioral of MAC is

signal Product: std_logic_vector(Abitwidth+Bbitwidth-1 downto 0);
	
component GenericAccumulator is
generic(inBitwidth:integer:=8;sumBitwidth:integer:=25);
port(
	newData: in std_logic;
	reset: in std_logic;
	dataIn: in std_logic_vector(inBitwidth-1 downto 0);
	Sum: out std_logic_vector(sumBitwidth-1 downto 0));
end component;

component Multiplier is
generic(Abitwidth:integer:=32; Bbitwidth:integer:=32);
port(operandA: in std_logic_vector(Abitwidth-1 downto 0);
	  operandB: in std_logic_vector(Bbitwidth-1 downto 0);
	  Product: out std_logic_vector(Abitwidth+Bbitwidth-1 downto 0));
end component;

begin

	acc1: GenericAccumulator 
		generic map(Abitwidth+Bbitwidth,ACCbitwidth)
		port map(newData,reset,Product,AccResult);
		
	mult1: Multiplier 
		generic map(Abitwidth,Bbitwidth)
		port map(operandA,operandB,Product);
	
end Behavioral;

