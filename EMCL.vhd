library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-------------------------------------------------------------------------

entity EMCL is port (
	Vacation_Mode				:	in std_logic;
	MC_TESTMODE					:	in std_logic;
	Windows_Open				:	in std_logic;
	Door_Open					:	in std_logic;
	Desired_LT_Current		:	in std_logic;
	Desired_EQ_Current		:	in std_logic;
	Desired_GT_Current		:	in std_logic;
	
	FURNACE_ON_display 					:	out std_logic; -- Output signal indicating furnace status
	SYSTEM_AT_TEMP_display				: 	out std_logic; -- Output signal indicating if current temperature matches desired temperature
	AC_ON_display							: 	out std_logic; -- Output signal indicating A/C status
	BLOWER_ON_display 					: 	out std_logic;  -- Output signal indicating Blower status
	Door_Open_display						:	out std_logic;
	Windows_Open_display					:	out std_logic;
	Vacation_Mode_display				:	out std_logic
); 
end EMCL;

architecture syn of EMCL is

--signals
	signal Door_and_Window_Closed			: std_logic;

begin

	Door_and_Window_Closed <= Windows_Open NOR Door_Open; -- Signal determine the status for both door and window: 1 when both door and window are closed;
																			-- 0 when either door or window is opened
	Furnace_ON_display             <= Door_and_Window_Closed AND Desired_GT_Current; -- Signal determine the status for furnace: 1 when door and window are close	
																									 -- and desired temperature is greater than current temperature;
																									 -- 0 when either door or window is opened or current temperature is equal or
																									 -- greater than desired temperature
	AC_ON_display                  <= Door_and_Window_Closed AND Desired_LT_Current; -- Signal determine the status for A/C: 1 when door and window are close	
																									 -- and desired temperature is less than current temperature;
																									 -- 0 when either door or window is opened or current temperature is equal or
																									 -- less than desired temperature
	BLOWER_ON_display              <= (Door_and_Window_Closed AND Desired_GT_Current) OR (Door_and_Window_Closed AND Desired_LT_Current); -- Signal determine the status for blower: 
																																													  -- 1 when either furnace or A/C is on; 0 when both are off


	SYSTEM_AT_TEMP_display         <= Desired_EQ_Current;  -- Signal determine if current temperature matches desired temperature: 1 true; 0 false

	Windows_Open_display				 <= Windows_Open;
	
	Door_Open_display					 <= Door_Open;
	
	Vacation_Mode_display			 <= Vacation_Mode;

end architecture syn; 