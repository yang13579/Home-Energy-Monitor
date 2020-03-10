library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-------------------------------------------------------------------------

entity Compx1 is port (
   
   A		   :  in std_logic; 		-- first 1-bit input for comparing
   
   B			:  in std_logic; 		-- second 1-bit input for comparing
	
	A_GT_B	:	out std_logic; 	-- Output signal when the first input is greater than the second input
	
	A_EQ_B	:	out std_logic; 	-- Output signal when the first input is equal to the second input
	
	A_LT_B	:	out std_logic  	-- Output signal when the first input is less than the second input
); 
end Compx1;

architecture syn of Compx1 is
begin
   A_GT_B <= A AND (NOT B); -- When first is 1 and second is 0, output 1
	
	A_EQ_B <= NOT(A XOR B);	 -- when first is 1 and second is 1, or first is 0 and second is 0, output 1
	
	A_LT_B <= (NOT A) AND B; -- when first is 0 and second is 1, output 1
end architecture syn; 