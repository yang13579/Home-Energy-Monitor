library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-------------------------------------------------------------------------

entity Compx4 is port (
	A4			:	in std_logic_vector(3 downto 0); -- first 4-bit binary number input for comparing
	B4			:	in std_logic_vector(3 downto 0); -- second 4-bit binary number input for comparing
	AGTB		:	out std_logic;							-- Output signal when first input is greater than second input			
	AEQB		:	out std_logic;							-- Output signal when first input is equal to second input
	ALTB		:	out std_logic							-- Output signal when first input is less than second input
); 
end Compx4;

architecture syn of Compx4 is

-- Implement 1-bit comparator
-- Component declaration
	component Compx1 port(
	   A		 	   :  in std_logic;
   
		B				:  in std_logic;
	
		A_GT_B		:	out std_logic;
	
		A_EQ_B		:	out std_logic;
	
		A_LT_B		:	out std_logic
	);
	end component;
	
-- Signal declaration
	signal A0GTB0 : std_logic; -- Determine if the least significant bit of first input is greater than the least significant bit of second input
	signal A1GTB1 : std_logic; -- Determine if the 2nd least significant bit of first input is greater than the 2nd least significant bit of second input
	signal A2GTB2 : std_logic; -- Determine if the 3rd least significant bit of first input is greater than the 3rd least significant bit of second input
	signal A3GTB3 : std_logic; -- Determine if the most significant bit of first input is greater than the most significant bit of second input
	signal A0EQB0 : std_logic; -- Determine if the least significant bit of first input is equal to the least significant bit of second input
	signal A1EQB1 : std_logic; -- Determine if the 2nd least significant bit of first input is equal to the 2nd least significant bit of second input
	signal A2EQB2 : std_logic; -- Determine if the 3rd least significant bit of first input is equal to the 3rd least significant bit of second input
	signal A3EQB3 : std_logic; -- Determine if the most significant bit of first input is equal to the most significant bit of second input
	signal A0LTB0 : std_logic; -- Determine if the least significant bit of first input is less than the least significant bit of second input
	signal A1LTB1 : std_logic; -- Determine if the 2nd least significant bit of first input is less than the 2nd least significant bit of second input
	signal A2LTB2 : std_logic; -- Determine if the 3rd least significant bit of first input is less than the 3rd least significant bit of second input
	signal A3LTB3 : std_logic; -- Determine if the most significant bit of first input is less than the most significant bit of second input



begin
	
	Compx_0:Compx1 port map(A4(0),B4(0),A0GTB0,A0EQB0,A0LTB0); -- Comparing between the least significant bits of the two inputs
	Compx_1:Compx1 port map(A4(1),B4(1),A1GTB1,A1EQB1,A1LTB1); -- Comparing between the second least significant bits of the two inputs
	Compx_2:Compx1 port map(A4(2),B4(2),A2GTB2,A2EQB2,A2LTB2); -- Comparing between the thrid least significant bits of the two inputs
	Compx_3:Compx1 port map(A4(3),B4(3),A3GTB3,A3EQB3,A3LTB3); -- Comparing between the most significant bits of the two inputs
	
	
	AEQB <= A0EQB0 AND A1EQB1 AND A2EQB2 AND A3EQB3; -- Final equal output if every pair of bits is equal between the two inputs
	
	AGTB <= A3GTB3 OR (A3EQB3 AND A2GTB2) OR (A3EQB3 AND A2EQB2 AND A1GTB1) OR (A3EQB3 AND A2EQB2 AND A1EQB1 AND A0GTB0); -- Final greater output if second
																																								 -- input is greater than the first input
	
	ALTB <= A3LTB3 OR (A3EQB3 AND A2LTB2) OR (A3EQB3 AND A2EQB2 AND A1LTB1) OR (A3EQB3 AND A2EQB2 AND A1EQB1 AND A0LTB0); -- Final less output if second
																																								 -- input is less than the first input
	
	
end architecture syn; 



