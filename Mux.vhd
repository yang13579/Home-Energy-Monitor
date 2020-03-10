library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;


-- ****************************************************************************
-- *  Entity                                                                  *
-- ****************************************************************************

entity mux is
   port (
          pb         : in  std_logic;                    -- Control line by a power button
			 DIN1 		: in  std_logic_vector(3 downto 0);	-- 4-bit input signal for first input
			 DIN2 		: in  std_logic_vector(3 downto 0); -- 4-bit input signal for second input
			 DOUT			: out	std_logic_vector(3 downto 0)  -- 4-bit output signal that chose from first or second input
        );
end entity mux;

-- *****************************************************************************
-- *  Architecture                                                             *
-- *****************************************************************************

architecture syn of mux is
   
begin

	with pb select
		DOUT <= DIN1 when '0', -- When pb is not pressed, output first input
				  DIN2 when '1'; -- when pb is pressed, output second input
end syn;