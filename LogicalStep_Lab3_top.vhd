library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity LogicalStep_Lab3_top is port (
   clkin_50		: in	std_logic;
	pb				: in	std_logic_vector(3 downto 0);
 	sw   			: in  std_logic_vector(7 downto 0); -- The switch inputs
   leds			: out std_logic_vector(7 downto 0);	-- for displaying the switch content
   seg7_data 	: out std_logic_vector(6 downto 0); -- 7-bit outputs to a 7-segment
	seg7_char1  : out	std_logic;							-- seg7 digi selectors
	seg7_char2  : out	std_logic							-- seg7 digi selectors
	
); 
end LogicalStep_Lab3_top;

architecture Energy_Monitor of LogicalStep_Lab3_top is
--
-- Components Used
-------------------------------------------------------------------

-- 4-bit comparator: two determine whether two 4-bit binary inputs is equal, less, or greater than each other 
   component Compx4 port (
		A4			:	in std_logic_vector(3 downto 0); -- The first 4-bit binary input for comparing
		B4			:	in std_logic_vector(3 downto 0); -- The second 4-bit binary input for comparing
		AGTB		:	out std_logic; -- Output when the first input is greater than the second input
		AEQB		:	out std_logic; -- Output when the two inputs are equal
		ALTB		:	out std_logic  -- Output when the first input is less than the second input
   ); 
   end component;
	
-- Two-input multiplexer: to select input from desired temperature and vacation mode temperature
	component mux port(
		 pb         : in  std_logic; -- Using power button as an input selector
		 DIN1 		: in  std_logic_vector(3 downto 0);	-- First 4-bit binary input
		 DIN2 		: in  std_logic_vector(3 downto 0); -- Second 4-bit binary input
		 DOUT			: out	std_logic_vector(3 downto 0)  -- 4-bit output
	);
	end component;
	
-- Seven segment Multiplexer, reused from lab2
	component segment7_mux port(
		clk		:in std_logic:='0';
		DIN2		:in std_logic_vector(6 downto 0);
		DIN1		:in std_logic_vector(6 downto 0);
		DOUT		:out std_logic_vector(6 downto 0);
		DIG2		:out std_logic;
		DIG1		:out std_logic
	);
	end component;
	
-- Seven segment decoder, reused from lab2	
   component SevenSegment port (
		hex   		:  in  std_logic_vector(3 downto 0);   -- The 4 bit data to be displayed
		sevenseg 	:  out std_logic_vector(6 downto 0)    -- 7-bit outputs to a 7-segment
   ); 
   end component;
	
-- Energy Monitor and control monnitor, uses power buttons as input and implements logic gates to generate the correct display output
	component EMCL port (
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
		BLOWER_ON_display 					: 	out std_logic; -- Output signal indicating Blower status
		Door_Open_display						:	out std_logic; -- Output signal indicating door is open
		Windows_Open_display					:	out std_logic; -- Output signal indicating window is open
		Vacation_Mode_display				:	out std_logic  -- Output signal indicating vacation mode is on
	); 
	end component;
	
-- TestBench, to test if the display numbers match the relation with the switch input
	component TestBench port (
		sw							: in std_logic_vector(7 downto 0);
		Desired_EQ_Current	: in std_logic;
		Desired_GT_Current	: in std_logic;
		Desired_LT_Current	: in std_logic;
		MC_TESTMODE				: in std_logic;
		
		TEST_PASS				: out std_logic
	); 
	end component;


------------------------------------------------------------------
	
	
	
-- Create any signals, or temporary variables to be used

-- input signals
	signal Current_Temp				: std_logic_vector(3 downto 0); -- 4-bit input signals from switch 3 downto 0
	signal Desired_Temp				: std_logic_vector(3 downto 0); -- 4-bit input signals from switch 7 downto 4
	signal Vacation_Mode				: std_logic; -- input signal from power button 3
	signal MC_TESTMODE				: std_logic; -- input signal from power button 2
	signal Windows_Open				: std_logic; -- input signal from power button 1
	signal Door_Open					: std_logic; -- input signal from power button 0
	
-- output signals

--	signal TEST_PASS					: std_logic; -- Output signal indicating if the test bench passed or not
	signal Current_Temp_hex			: std_logic_vector(6 downto 0); -- Decoded current temperature, to be displayed on digit 2
	signal Desired_Temp_hex			: std_logic_vector(6 downto 0); -- Decoded desired temperature, to be displayed on digit 1
	
--	signal Door_and_Window_Closed 												: std_logic; -- Signal indicating if both door and window are closed
	signal Desired_EQ_Current,Desired_GT_Current,Desired_LT_Current	: std_logic; -- Signal indicating if desired temperature is equal to current temperature
																											 --                   if desired temperature is greater than current temperature
																											 --                   if desired temperature is less than current temperature
	signal FURNACE_ON								: std_logic; -- Output signal indicating furnace status
	signal SYSTEM_AT_TEMP						: std_logic; -- Output signal indicating if current temperature matches desired temperature
	signal AC_ON									: std_logic; -- Output signal indicating A/C status
	signal BLOWER_ON			 					: std_logic; -- Output signal indicating Blower status
			

			
																													 
-- Here the circuit begins

begin
	-- Receive current temperature from switch 3 downto 0 
	Current_Temp <= sw(3 downto 0);
	
	--invert the power button to compensate for active-low pb
	Vacation_Mode <= not pb(3); -- Vacation mode setting: Activated if power button 3 if pressed, vice versa. (vACATION MODE FORCES THE DESIRED TEMPERATURE TO 4)
	MC_TESTMODE   <= not pb(2); -- Test indicator activation: test passes if the relation between current temperature 
										 -- and desired temperature matches with the displayed relation
	Windows_Open  <= not pb(1); -- Windows Open activation: represents the window is opening when the power button 1 is pressed, vice versa
	Door_Open     <= not pb(0); -- Door open activation: represents the door is opening when the power button 0 is pressed, vice versa
	



--instantiates
	-- Connect vacation mode temperature and desired temperature as 2 inputs for the 2-to-1 mux
	-- Use Pb3 to select (whether vacation mode is activated or not)
	Vacation: mux port map(Vacation_Mode, sw(7 downto 4), "0100", Desired_Temp);
	
	-- Connect 4-bit binary representations for current temperature and desired temperature as inputs for the comparator
	-- Connect 3 output signals: one for desired less than current; one for desired equal to current; one for desired greater than current
	Comparator : Compx4 port map(Current_Temp, Desired_Temp, Desired_LT_Current, Desired_EQ_Current, Desired_GT_Current);

	-- Convert 4-bit binary representation of the current temperature into digit 2
	Decoder1: SevenSegment port map(Current_Temp, Current_Temp_hex);
	
	-- Convert 4-bit binary representation of the desired temperature into digit 1
	Decoder2: SevenSegment port map(Desired_Temp, Desired_Temp_hex);

	SEG7_MULTIPLEXER: segment7_mux port map(clkin_50, Current_Temp_hex, Desired_Temp_hex, seg7_data, seg7_char2, seg7_char1);
	
	-- Take vacation_mode, mc_testmode, windows_open, door_open, and comparing results as input to the energy monitor and control logic component
	-- inputs go through logic relation
	-- output furnace_on, system_at_temp, ac_on, blower_on to display on led
	inst1: EMCL port map(Vacation_Mode, MC_TESTMODE, Windows_Open, Door_Open, Desired_LT_Current, Desired_EQ_Current, Desired_GT_Current, 
								leds(0), leds(1), leds(2), leds(3), leds(4), leds(5), leds(7));
	
	inst2: TestBench port map(sw(7 downto 0), Desired_EQ_Current, Desired_GT_Current, Desired_LT_Current, MC_TESTMODE, leds(6));

-- led 0 is on when the furnace is on, vice versa
-- led 1 is on when current temperature matches the desire temperature
-- led 2 is on when A/C is on, vice versa
-- led 3 is on when blower is on, vice versa
-- led 4 is on when door is open, vice versa
-- led 5 is on when window is open, vice versa
-- led 6 is on when the test passes, vice versa
-- led 7 is on when vacation mode is activated, vice versa

end Energy_Monitor;

