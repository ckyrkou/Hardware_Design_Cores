----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:21:19 12/24/2009 
-- Design Name: 
-- Module Name:    ROM - Behavioral 
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
use std.textio.all;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ROMem is
generic(addressBitWidth:integer:=3;memDepth:integer:=8;BlockBitWidth:integer:=32);
port(
	clock  : in std_logic;                 
	address : in std_logic_vector(addressBitWidth-1 downto 0);     
	dataOut : out std_logic_vector(BlockBitWidth-1 downto 0));
end ROMem;

architecture Behavioral of ROMem is

	type RomType is array(0 to memDepth-1) of bit_vector(BlockBitWidth-1 downto 0);  
		impure  function  InitRomFromFile  (RomFileName  :  in  string)  return  RomType  is                                                                                                     
      FILE RomFile         : text is in RomFileName;                       
      variable RomFileLine : line; 
		variable ROM         : RomType; 		
	begin                                                        
        for I in RomType'range loop                                  
            readline (RomFile, romFileLine);                             
            read (RomFileLine, ROM(I));                                  
        end loop;                                                    
        return ROM;                                                  
    end function;  


	signal ROM : RomType := InitRomFromFile("rams_20c.data");

      
begin

	process (clock)                                                
    begin                                                        
        if rising_edge(clock) then                          
				dataOut <= to_stdlogicvector(ROM(conv_integer(address)));          
        end if;                                                      
    end process;  

end Behavioral;
