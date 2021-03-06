library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-------------------------------------------------------------------------

entity TestBench is port (
	sw		: in std_logic_vector(7 downto 0);
	Desired_EQ_Current	: in std_logic;
	Desired_GT_Current	: in std_logic;
	Desired_LT_Current	: in std_logic;
	MC_TESTMODE				: in std_logic;
	
	TEST_PASS				: out std_logic
); 
end TestBench;

architecture syn of TestBench is

begin

-- testbench
-- Used code from lab manual
-- Test indicator activation: test passes if the relation between current temperature 
-- and desired temperature matches with the displayed relation
Testbench1: PROCESS (sw, Desired_EQ_Current, Desired_GT_Current, Desired_LT_Current, MC_TESTMODE) is

variable EQ_PASS, GT_PASS, LT_PASS		: std_logic :='0'; -- declare test-pass variables

begin
		-- Test if the values from the switches are equal and the displayed digits are equal
		-- If so, output 1 for EQ-PASS signal
		IF ((sw(3 downto 0) = sw(7 downto 4)) AND (Desired_EQ_Current='1')) THEN
		EQ_PASS := '1';
		GT_PASS := '0';
		LT_PASS := '0';
	
	   -- Test if the current temperature is greater than the desired temperature and the displayed digits match that relation
		-- If so, output 1 for GT-PASS signal
		ELSIF ((sw(3 downto 0) > sw(7 downto 4)) AND (Desired_LT_Current='1')) THEN
		EQ_PASS := '0';
		GT_PASS := '1';
		LT_PASS := '0';

		-- Test if the current temperature is less than the desired temperature and the displayed digits match that relation
		-- If so, output 1 for LT-PASS signal
		ELSIF ((sw(3 downto 0) < sw(7 downto 4)) AND (Desired_GT_Current='1')) THEN
		EQ_PASS := '0';
		GT_PASS := '0';
		LT_PASS := '1';
		
		-- If the above relations all failed, output 0 for every output signals
		ELSE
		EQ_PASS := '0';
		GT_PASS := '0';
		LT_PASS := '0';

		-- When TestMode is activated (pb2 is pressed) and either of the relation matches, test passes (output 1 for TEST_PASS signal);
		-- else, test fails (output 0 for TEST_PASS signal);
		END IF;
		TEST_PASS <= MC_TESTMODE AND (EQ_PASS OR GT_PASS OR LT_PASS);

end process;

end architecture syn; 